//
//  PostEventViewController.swift
//  BostonFree
//
//  Created by user267597 on 12/3/24.
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class PostEventViewController: UIViewController {
    
    let postEventView = PostEventView()
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    override func loadView() {
        self.view = postEventView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Post Free Event"
        postEventView.postButton.addTarget(self, action: #selector(handlePostEvent), for: .touchUpInside)
    }
    
    @objc func handlePostEvent() {
        guard let name = postEventView.eventNameTextField.text, !name.isEmpty,
              let location = postEventView.locationTextField.text, !location.isEmpty,
              let image = postEventView.eventImageView.image else {
            showAlert(message: "Please fill in all required fields and select an image.")
            return
        }
        
        let description = postEventView.descriptionTextView.text.isEmpty ? nil : postEventView.descriptionTextView.text
        let website = postEventView.websiteTextField.text?.isEmpty == false ? postEventView.websiteTextField.text : nil
        
        // Upload image to Firebase Storage
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            showAlert(message: "Failed to process image.")
            return
        }
        
        let imageName = UUID().uuidString
        let storageRef = storage.reference().child("event_images/\(imageName).jpg")
        
        let uploadTask = storageRef.putData(imageData, metadata: nil) { [weak self] metadata, error in
            if let error = error {
                self?.showAlert(message: "Image upload failed: \(error.localizedDescription)")
                return
            }
            // get image URL
            storageRef.downloadURL { url, error in
                if let error = error {
                    self?.showAlert(message: "Failed to get image URL: \(error.localizedDescription)")
                    return
                }
                guard let imageUrl = url?.absoluteString else {
                    self?.showAlert(message: "Invalid image URL.")
                    return
                }
                // store date to Firestore
                self?.storeEventData(name: name, location: location, imageUrl: imageUrl, description: description, website: website)
            }
        }
        
        // show progress
        uploadTask.observe(.progress) { snapshot in
            if let progress = snapshot.progress {
                let percentComplete = Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
                DispatchQueue.main.async {
                    self.showLoadingIndicator(message: "Uploading: \(Int(percentComplete * 100))%")
                }
            }
        }
        
        uploadTask.observe(.success) { _ in
            DispatchQueue.main.async {
                self.hideLoadingIndicator()
            }
        }
    }
    
    func storeEventData(name: String, location: String, imageUrl: String, description: String?, website: String?) {
        let eventData: [String: Any] = [
            "name": name,
            "location": location,
            "imageUrl": imageUrl,
            "description": description ?? "",
            "website": website ?? "",
            "createdAt": Timestamp(date: Date())
        ]
        
        db.collection("events").addDocument(data: eventData) { [weak self] error in
            if let error = error {
                self?.showAlert(message: "Failed to post event: \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    var loadingIndicator: UIAlertController?
    
    func showLoadingIndicator(message: String) {
        if loadingIndicator == nil {
            loadingIndicator = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let loadingView = UIActivityIndicatorView(style: .medium)
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            loadingView.startAnimating()
            loadingIndicator?.view.addSubview(loadingView)
            NSLayoutConstraint.activate([
                loadingView.centerXAnchor.constraint(equalTo: loadingIndicator!.view.centerXAnchor),
                loadingView.bottomAnchor.constraint(equalTo: loadingIndicator!.view.bottomAnchor, constant: -20)
            ])
        } else {
            loadingIndicator?.message = message
        }
        if let loadingIndicator = loadingIndicator, presentedViewController != loadingIndicator {
            present(loadingIndicator, animated: true, completion: nil)
        }
    }
    
    func hideLoadingIndicator() {
        loadingIndicator?.dismiss(animated: true, completion: nil)
        loadingIndicator = nil
    }

    func showAlert(title: String = "Error", message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: title == "Error" ? "OK" : "OK",
                                      style: .default,
                                      handler: { _ in
                                        completion?()
                                      }))
        present(alert, animated: true, completion: nil)
    }
    
    init() {
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

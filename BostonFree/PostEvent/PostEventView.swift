//
//  PostEventView.swift
//  BostonFree
//
//  Created by user267597 on 12/3/24.
//
import UIKit

class PostEventView: UIView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let contentView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let eventNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Event Name"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let locationTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Location"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.layer.borderColor = UIColor.systemGray4.cgColor
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 8
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let websiteTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Website (Optional)"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let selectImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Event Image", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let eventImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor.systemGray5
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post Free Event!", for: .normal)
        button.backgroundColor = UIColor.systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var imageSelected: ((UIImage?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupLayout()
        selectImageButton.addTarget(self, action: #selector(handleSelectImage), for: .touchUpInside)
    }
    
    func setupLayout() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(eventNameTextField)
        contentView.addSubview(locationTextField)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(websiteTextField)
        contentView.addSubview(selectImageButton)
        contentView.addSubview(eventImageView)
        contentView.addSubview(postButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: self.leftAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            eventNameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            eventNameTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            eventNameTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            eventNameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            locationTextField.topAnchor.constraint(equalTo: eventNameTextField.bottomAnchor, constant: 16),
            locationTextField.leftAnchor.constraint(equalTo: eventNameTextField.leftAnchor),
            locationTextField.rightAnchor.constraint(equalTo: eventNameTextField.rightAnchor),
            locationTextField.heightAnchor.constraint(equalToConstant: 40),
            
            descriptionTextView.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 16),
            descriptionTextView.leftAnchor.constraint(equalTo: eventNameTextField.leftAnchor),
            descriptionTextView.rightAnchor.constraint(equalTo: eventNameTextField.rightAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),
            
            websiteTextField.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 16),
            websiteTextField.leftAnchor.constraint(equalTo: eventNameTextField.leftAnchor),
            websiteTextField.rightAnchor.constraint(equalTo: eventNameTextField.rightAnchor),
            websiteTextField.heightAnchor.constraint(equalToConstant: 40),

            selectImageButton.topAnchor.constraint(equalTo: websiteTextField.bottomAnchor, constant: 16),
            selectImageButton.leftAnchor.constraint(equalTo: eventNameTextField.leftAnchor),
            selectImageButton.rightAnchor.constraint(equalTo: eventNameTextField.rightAnchor),
            selectImageButton.heightAnchor.constraint(equalToConstant: 50),

            eventImageView.topAnchor.constraint(equalTo: selectImageButton.bottomAnchor, constant: 16),
            eventImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            eventImageView.widthAnchor.constraint(equalToConstant: 200),
            eventImageView.heightAnchor.constraint(equalToConstant: 200),

            postButton.topAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: 24),
            postButton.leftAnchor.constraint(equalTo: eventNameTextField.leftAnchor),
            postButton.rightAnchor.constraint(equalTo: eventNameTextField.rightAnchor),
            postButton.heightAnchor.constraint(equalToConstant: 50),
            postButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    @objc func handleSelectImage() {
        // Trigger image selection
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        if let viewController = self.findViewController() {
            viewController.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // Called when an image is selected
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        eventImageView.image = selectedImage
        imageSelected?(selectedImage)
        picker.dismiss(animated: true, completion: nil)
    }
    
    //Finds the current view's UIViewController by traversing the responder chain
    func findViewController() -> UIViewController? {
        var nextResponder: UIResponder? = self
        while nextResponder != nil {
            nextResponder = nextResponder?.next
            if let vc = nextResponder as? UIViewController {
                return vc
            }
        }
        return nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


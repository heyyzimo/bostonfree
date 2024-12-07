//
//  PostEventViewController.swift
//  BostonFree
//
//  Created by user267597 on 12/4/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import MapKit
import CoreLocation

class PostEventViewController: UIViewController {
    
    let postEventView = PostEventView()
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    let locationManager = CLLocationManager()
    var selectedCoordinate: CLLocationCoordinate2D?
    var userLocation: CLLocation?
    let completer = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    override func loadView() {
        self.view = postEventView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Post Free Event"
        postEventView.postButton.addTarget(self, action: #selector(handlePostEvent), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectImage))
        postEventView.eventImageView.isUserInteractionEnabled = true
        postEventView.eventImageView.addGestureRecognizer(tapGesture)
        
        postEventView.locationTextField.delegate = self
        postEventView.didTapSuggestion = { [weak self] suggestion in
            self?.selectLocation(suggestion: suggestion)
        }
        
        setupLocationManager()
        setupCompleter()
        postEventView.locationSuggestionsTableView.delegate = self
        postEventView.locationSuggestionsTableView.dataSource = self
        postEventView.mapView.isHidden = false
        postEventView.mapView.showsUserLocation = true
        
        let startDatePicker = UIDatePicker()
        startDatePicker.datePickerMode = .dateAndTime
        startDatePicker.preferredDatePickerStyle = .wheels
        startDatePicker.addTarget(self, action: #selector(handleStartDateChange(_:)), for: .valueChanged)
        postEventView.startTimeTextField.inputView = startDatePicker

        let endDatePicker = UIDatePicker()
        endDatePicker.datePickerMode = .dateAndTime
        endDatePicker.preferredDatePickerStyle = .wheels
        endDatePicker.addTarget(self, action: #selector(handleEndDateChange(_:)), for: .valueChanged)
        postEventView.endTimeTextField.inputView = endDatePicker
    }
    
    @objc func handleStartDateChange(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        postEventView.startTimeTextField.text = formatter.string(from: sender.date)
    }

    @objc func handleEndDateChange(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        postEventView.endTimeTextField.text = formatter.string(from: sender.date)
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func setupCompleter() {
        completer.delegate = self
        completer.filterType = .locationsAndQueries
    }
    
    @objc func handleSelectImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = postEventView
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handlePostEvent() {
        guard let name = postEventView.eventNameTextField.text, !name.isEmpty,
              let location = postEventView.locationTextField.text, !location.isEmpty,
              let image = postEventView.eventImageView.image,
              let coordinate = selectedCoordinate else {
            showAlert(message: "Please fill in all required fields, select an image, and choose a location.")
            return
        }
        
        guard let startText = postEventView.startTimeTextField.text, !startText.isEmpty,
              let endText = postEventView.endTimeTextField.text, !endText.isEmpty else {
            showAlert(message: "Please select start and end times for the event.")
            return
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        guard let startTime = formatter.date(from: startText),
              let endTime = formatter.date(from: endText) else {
            showAlert(message: "Invalid date format.")
            return
        }
        
        if startTime > endTime {
            showAlert(message: "Start time cannot be later than end time.")
            return
        }
        
        let now = Date()
        if endTime < now {
            showAlert(message: "End time cannot be in the past.")
            return
        }
        
        let description = postEventView.descriptionTextView.text.isEmpty ? nil : postEventView.descriptionTextView.text
        let website = postEventView.websiteTextField.text?.isEmpty == false ? postEventView.websiteTextField.text : nil
        
        // upload image to Firebase Storage
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
                // store event data to Firestore including startTime and endTime
                self?.storeEventData(name: name, location: location, imageUrl: imageUrl, description: description, website: website, latitude: coordinate.latitude, longitude: coordinate.longitude, startTime: startTime, endTime: endTime)
            }
        }
        
        // progress
        uploadTask.observe(.progress) { [weak self] snapshot in
            if let progress = snapshot.progress {
                let percentComplete = Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
                DispatchQueue.main.async {
                    self?.showLoadingIndicator(message: "Uploading: \(Int(percentComplete * 100))%")
                }
            }
        }
        
        uploadTask.observe(.success) { [weak self] _ in
            DispatchQueue.main.async {
                self?.hideLoadingIndicator()
            }
        }
    }
    
    func storeEventData(name: String, location: String, imageUrl: String, description: String?, website: String?, latitude: Double, longitude: Double, startTime: Date, endTime: Date) {
        let eventData: [String: Any] = [
            "name": name,
            "location": location,
            "latitude": latitude,
            "longitude": longitude,
            "imageUrl": imageUrl,
            "description": description ?? "",
            "website": website ?? "",
            "createdAt": Timestamp(date: Date()),
            "startTime": Timestamp(date: startTime),
            "endTime": Timestamp(date: endTime)
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
   
    func selectLocation(suggestion: MKLocalSearchCompletion) {
        postEventView.locationTextField.text = suggestion.title + ", " + suggestion.subtitle
        let searchRequest = MKLocalSearch.Request(completion: suggestion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] response, error in
            if let error = error {
                self?.showAlert(message: "Location search failed: \(error.localizedDescription)")
                return
            }
            guard let coordinate = response?.mapItems.first?.placemark.coordinate else {
                self?.showAlert(message: "Could not find the location。")
                return
            }
            self?.selectedCoordinate = coordinate
            self?.updateMapView(with: coordinate)
            
            self?.postEventView.mapView.isHidden = false
            self?.postEventView.locationSuggestionsTableView.isHidden = true
        }
    }
    
    func updateMapView(with coordinate: CLLocationCoordinate2D) {
        postEventView.mapView.isHidden = false
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        postEventView.mapView.setRegion(region, animated: true)

        postEventView.mapView.removeAnnotations(postEventView.mapView.annotations)
 
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        postEventView.mapView.addAnnotation(annotation)

        postEventView.locationSuggestionsTableView.isHidden = true
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
        alert.addAction(UIAlertAction(title: "OK",
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

extension PostEventViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        postEventView.locationSuggestionsTableView.isHidden = searchResults.isEmpty
        postEventView.locationSuggestionsTableView.reloadData()

        if searchResults.isEmpty {
            postEventView.mapView.isHidden = false
        } else {
            postEventView.mapView.isHidden = true
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search completer error: \(error.localizedDescription)")
    }
}

extension PostEventViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            showAlert(message: "Location access is needed to select event location.")
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           guard let latestLocation = locations.last else { return }
           userLocation = latestLocation

           let region = MKCoordinateRegion(center: latestLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
           postEventView.mapView.setRegion(region, animated: true)

           selectedCoordinate = latestLocation.coordinate

           locationManager.stopUpdatingLocation()
       }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert(message: "Failed to get your location: \(error.localizedDescription)")
    }
}

extension PostEventViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == postEventView.locationTextField {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            completer.queryFragment = updatedText
        }
        return true
    }
}

extension PostEventViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return searchResults.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath)
        let suggestion = searchResults[indexPath.row]
        cell.textLabel?.text = suggestion.title + ", " + suggestion.subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let suggestion = searchResults[indexPath.row]
        selectLocation(suggestion: suggestion)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//
//  PostEventView.swift
//  BostonFree
//
//  Created by user267597 on 12/4/24.
//
import UIKit
import MapKit

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
    
    let locationContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let locationSuggestionsTableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "SuggestionCell")
        tv.isHidden = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let mapView: MKMapView = {
        let mv = MKMapView()
        mv.isHidden = true
        mv.translatesAutoresizingMaskIntoConstraints = false
        return mv
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
    
    let eventImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .center
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor.systemGray5
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "plus")
        iv.tintColor = .gray
        return iv
    }()
    
    let startTimeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Start Time"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    let endTimeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "End Time"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
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
    
    var didTapSuggestion: ((MKLocalSearchCompletion) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupLayout()
    }
    
    func setupLayout() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(eventNameTextField)
        contentView.addSubview(locationTextField)
        contentView.addSubview(locationContainerView)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(websiteTextField)
        contentView.addSubview(eventImageView)
        contentView.addSubview(postButton)
        contentView.addSubview(startTimeTextField)
        contentView.addSubview(endTimeTextField)
        
        locationContainerView.addSubview(locationSuggestionsTableView)
        locationContainerView.addSubview(mapView)
        
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
            
            locationContainerView.topAnchor.constraint(equalTo: locationTextField.bottomAnchor),
            locationContainerView.leftAnchor.constraint(equalTo: locationTextField.leftAnchor),
            locationContainerView.rightAnchor.constraint(equalTo: locationTextField.rightAnchor),
            locationContainerView.heightAnchor.constraint(equalToConstant: 200),
            
            locationSuggestionsTableView.topAnchor.constraint(equalTo: locationContainerView.topAnchor),
            locationSuggestionsTableView.leftAnchor.constraint(equalTo: locationContainerView.leftAnchor),
            locationSuggestionsTableView.rightAnchor.constraint(equalTo: locationContainerView.rightAnchor),
            locationSuggestionsTableView.bottomAnchor.constraint(equalTo: locationContainerView.bottomAnchor),
            
            mapView.topAnchor.constraint(equalTo: locationContainerView.topAnchor),
            mapView.leftAnchor.constraint(equalTo: locationContainerView.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: locationContainerView.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: locationContainerView.bottomAnchor),
            
            startTimeTextField.topAnchor.constraint(equalTo: locationContainerView.bottomAnchor, constant: 16),
            startTimeTextField.leftAnchor.constraint(equalTo: eventNameTextField.leftAnchor),
            startTimeTextField.rightAnchor.constraint(equalTo: eventNameTextField.rightAnchor),
            startTimeTextField.heightAnchor.constraint(equalToConstant: 40),
            
            endTimeTextField.topAnchor.constraint(equalTo: startTimeTextField.bottomAnchor, constant: 16),
            endTimeTextField.leftAnchor.constraint(equalTo: eventNameTextField.leftAnchor),
            endTimeTextField.rightAnchor.constraint(equalTo: eventNameTextField.rightAnchor),
            endTimeTextField.heightAnchor.constraint(equalToConstant: 40),

            descriptionTextView.topAnchor.constraint(equalTo: endTimeTextField.bottomAnchor, constant: 16),
            descriptionTextView.leftAnchor.constraint(equalTo: eventNameTextField.leftAnchor),
            descriptionTextView.rightAnchor.constraint(equalTo: eventNameTextField.rightAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),
            
            websiteTextField.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 16),
            websiteTextField.leftAnchor.constraint(equalTo: eventNameTextField.leftAnchor),
            websiteTextField.rightAnchor.constraint(equalTo: eventNameTextField.rightAnchor),
            websiteTextField.heightAnchor.constraint(equalToConstant: 40),
            
            eventImageView.topAnchor.constraint(equalTo: websiteTextField.bottomAnchor, constant: 16),
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            eventImageView.image = editedImage
            eventImageView.contentMode = .scaleAspectFill
        } else if let originalImage = info[.originalImage] as? UIImage {
            eventImageView.image = originalImage
            eventImageView.contentMode = .scaleAspectFill
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

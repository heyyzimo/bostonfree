//
//  EditProfileView.swift
//  BostonFree
//
//  Created by Zimo Liu on 12/6/24.
//

import UIKit

class EditProfileView: UIView {
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 50
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor.systemGray5
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    let selectProfileImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Profile Image", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    let cityTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "City"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    let hobbyTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Hobby"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    let pronounTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Pronoun (e.g., she/her)"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    let phoneNumberTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Phone Number"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .phonePad
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    let selfIntroductionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Profile", for: .normal)
        button.backgroundColor = UIColor.systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLayout() {
        self.addSubview(profileImageView)
        self.addSubview(selectProfileImageButton)
        self.addSubview(nameTextField)
        self.addSubview(cityTextField)
        self.addSubview(hobbyTextField)
        self.addSubview(pronounTextField)
        self.addSubview(phoneNumberTextField)
        self.addSubview(selfIntroductionTextView)
        self.addSubview(saveButton)
        self.addSubview(activityIndicator) // 添加 Activity Indicator


        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),

            selectProfileImageButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 15),
            selectProfileImageButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            nameTextField.topAnchor.constraint(equalTo: selectProfileImageButton.bottomAnchor, constant: 15),
            nameTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),

            cityTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15),
            cityTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cityTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),

            hobbyTextField.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 15),
            hobbyTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            hobbyTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),

            pronounTextField.topAnchor.constraint(equalTo: hobbyTextField.bottomAnchor, constant: 15),
            pronounTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            pronounTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),

            phoneNumberTextField.topAnchor.constraint(equalTo: pronounTextField.bottomAnchor, constant: 15),
            phoneNumberTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            phoneNumberTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),

            selfIntroductionTextView.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 15),
            selfIntroductionTextView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            selfIntroductionTextView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            selfIntroductionTextView.heightAnchor.constraint(equalToConstant: 120),

            saveButton.topAnchor.constraint(equalTo: selfIntroductionTextView.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor), // 居中布局 Activity Indicator
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

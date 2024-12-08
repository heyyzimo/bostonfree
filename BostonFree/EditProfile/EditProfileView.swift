//
//  EditProfileView.swift
//  BostonFree
//
//  Created by Zimo Liu on 12/6/24.
//
import UIKit

class EditProfileView: UIView {
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your name"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "City"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cityTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your city"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let hobbyLabel: UILabel = {
        let label = UILabel()
        label.text = "Hobby"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let hobbyTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your hobby"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let pronounLabel: UILabel = {
        let label = UILabel()
        label.text = "Pronoun"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pronounTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "e.g., she/her"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "Phone Number"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let phoneNumberTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your phone number"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .phonePad
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let selfIntroductionLabel: UILabel = {
        let label = UILabel()
        label.text = "Self Introduction"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    private func createInputStack(label: UILabel, inputView: UIView) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [label, inputView])
        stack.axis = .vertical
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(profileImageView)
        contentView.addSubview(selectProfileImageButton)
        contentView.addSubview(mainStackView)
        contentView.addSubview(activityIndicator)
        
        let nameStack = createInputStack(label: nameLabel, inputView: nameTextField)
        let cityStack = createInputStack(label: cityLabel, inputView: cityTextField)
        let hobbyStack = createInputStack(label: hobbyLabel, inputView: hobbyTextField)
        let pronounStack = createInputStack(label: pronounLabel, inputView: pronounTextField)
        let phoneNumberStack = createInputStack(label: phoneNumberLabel, inputView: phoneNumberTextField)
        let selfIntroductionStack = createInputStack(label: selfIntroductionLabel, inputView: selfIntroductionTextView)
        
        mainStackView.addArrangedSubview(nameStack)
        mainStackView.addArrangedSubview(cityStack)
        mainStackView.addArrangedSubview(hobbyStack)
        mainStackView.addArrangedSubview(pronounStack)
        mainStackView.addArrangedSubview(phoneNumberStack)
        mainStackView.addArrangedSubview(selfIntroductionStack)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            selectProfileImageButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 15),
            selectProfileImageButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            selectProfileImageButton.heightAnchor.constraint(equalToConstant: 44),
            selectProfileImageButton.widthAnchor.constraint(equalToConstant: 200),
            
            mainStackView.topAnchor.constraint(equalTo: selectProfileImageButton.bottomAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            cityTextField.heightAnchor.constraint(equalToConstant: 40),
            hobbyTextField.heightAnchor.constraint(equalToConstant: 40),
            pronounTextField.heightAnchor.constraint(equalToConstant: 40),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: 40),
            selfIntroductionTextView.heightAnchor.constraint(equalToConstant: 120),
            
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: mainStackView.bottomAnchor, constant: 20)
        ])
    }
}

//
//  SignupScreenView.swift
//  BostonFree
//
//  Created by Zimo Liu on 11/26/24.
//

import UIKit

class SignupView: UIView {
    var textFieldName: UITextField!
    var textFieldEmail: UITextField!
    var textFieldPassword: UITextField!
    var textFieldConfirmPassword: UITextField!
    var registerButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupTextFields()
        setupRegisterButton()
        setupConstraints()
    }
    
    func setupTextFields(){
        textFieldName = UITextField()
        textFieldName.placeholder = "Name"
        textFieldName.borderStyle = .roundedRect
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        
        textFieldEmail = UITextField()
        textFieldEmail.placeholder = "Email"
        textFieldEmail.borderStyle = .roundedRect
        textFieldEmail.keyboardType = .emailAddress
        textFieldEmail.translatesAutoresizingMaskIntoConstraints = false
        
        textFieldPassword = UITextField()
        textFieldPassword.placeholder = "Password"
        textFieldPassword.borderStyle = .roundedRect
        textFieldPassword.isSecureTextEntry = true
        textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        
        textFieldConfirmPassword = UITextField()
        textFieldConfirmPassword.placeholder = "Confirm Password"
        textFieldConfirmPassword.borderStyle = .roundedRect
        textFieldConfirmPassword.isSecureTextEntry = true
        textFieldConfirmPassword.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(textFieldName)
        self.addSubview(textFieldEmail)
        self.addSubview(textFieldPassword)
        self.addSubview(textFieldConfirmPassword)
    }
    
    func setupRegisterButton(){
        registerButton = UIButton(type: .system)
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.backgroundColor = .systemBlue
        registerButton.layer.cornerRadius = 5
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(registerButton)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            textFieldName.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 100),
            textFieldName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            textFieldName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            textFieldName.heightAnchor.constraint(equalToConstant: 40),
            
            textFieldEmail.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 20),
            textFieldEmail.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            textFieldEmail.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            textFieldEmail.heightAnchor.constraint(equalToConstant: 40),
            
            textFieldPassword.topAnchor.constraint(equalTo: textFieldEmail.bottomAnchor, constant: 20),
            textFieldPassword.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            textFieldPassword.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            textFieldPassword.heightAnchor.constraint(equalToConstant: 40),
            
            textFieldConfirmPassword.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 20),
            textFieldConfirmPassword.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            textFieldConfirmPassword.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            textFieldConfirmPassword.heightAnchor.constraint(equalToConstant: 40),
            
            
            registerButton.topAnchor.constraint(equalTo: textFieldConfirmPassword.bottomAnchor, constant: 30),
            registerButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            registerButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

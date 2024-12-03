//
//  LoginView.swift
//  BostonFree
//
//  Created by user267597 on 12/3/24.
//
import UIKit

class LoginView: UIView {
    
    // UI Elements
    let signinLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign In"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Boston Free"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.keyboardType = .emailAddress
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let signinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let signupPrompt: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ",
                                                         attributes: [.foregroundColor: UIColor.black])
        attributedTitle.append(NSAttributedString(string: "Sign Up",
                                                  attributes: [.foregroundColor: UIColor.systemGreen]))
        button.setAttributedTitle(attributedTitle, for: .normal)
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
        self.addSubview(signinLabel)
        self.addSubview(welcomeLabel)
        self.addSubview(emailTextField)
        self.addSubview(passwordTextField)
        self.addSubview(signinButton)
        self.addSubview(signupPrompt)
        
        NSLayoutConstraint.activate([
            // Sign In Label
            signinLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40),
            signinLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            // Welcome Label
            welcomeLabel.topAnchor.constraint(equalTo: signinLabel.bottomAnchor, constant: 10),
            welcomeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            // Email TextField
            emailTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40),
            emailTextField.widthAnchor.constraint(equalToConstant: 300),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // Password TextField
            passwordTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            
            // Sign In Button
            signinButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            signinButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            signinButton.widthAnchor.constraint(equalToConstant: 200),
            signinButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Signup Prompt
            signupPrompt.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            signupPrompt.topAnchor.constraint(equalTo: signinButton.bottomAnchor, constant: 20),
            signupPrompt.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}


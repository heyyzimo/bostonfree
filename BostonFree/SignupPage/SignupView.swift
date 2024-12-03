//
//  SignupView.swift
//  BostonFree
//
//  Created by user267597 on 12/3/24.
//
import UIKit

class SignupView: UIView {
    
    // UI Elements
    let signupLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign Up"
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
    
    let confirmPasswordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Confirm Password"
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let signinPrompt: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ",
                                                         attributes: [.foregroundColor: UIColor.black])
        attributedTitle.append(NSAttributedString(string: "Sign In",
                                                  attributes: [.foregroundColor: UIColor.systemBlue]))
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
        self.addSubview(signupLabel)
        self.addSubview(welcomeLabel)
        self.addSubview(emailTextField)
        self.addSubview(passwordTextField)
        self.addSubview(confirmPasswordTextField)
        self.addSubview(signupButton)
        self.addSubview(signinPrompt)
        
        NSLayoutConstraint.activate([
            // Sign Up Label
            signupLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40),
            signupLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            // Welcome Label
            welcomeLabel.topAnchor.constraint(equalTo: signupLabel.bottomAnchor, constant: 10),
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
            
            // Confirm Password TextField
            confirmPasswordTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            confirmPasswordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
            confirmPasswordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            
            // Sign Up Button
            signupButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            signupButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 30),
            signupButton.widthAnchor.constraint(equalToConstant: 200),
            signupButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Sign In Prompt
            signinPrompt.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            signinPrompt.topAnchor.constraint(equalTo: signupButton.bottomAnchor, constant: 20),
            signinPrompt.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}


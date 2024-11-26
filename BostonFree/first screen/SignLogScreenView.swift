//
//  SignLogScreenView.swift
//  BostonFree
//
//  Created by Zimo Liu on 11/26/24.
//

import UIKit

class SignLogScreenView: UIView {
    
    
    // MARK: declaring the UI elements...
    var imageViewLogo: UIImageView! // Logo image
    var labelHello: UILabel! //"Hello World!" Label...
    var buttonLogin: UIButton! // Button...
    var buttonSignup: UIButton! // Button...
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        // Do any additional setup after loading the self.
        
        // MARK: setting up UI elements...
        setupImageViewLogo()
        setupLabelHello()
        setupButtonLogin()
        setupButtonSignup()
        
        // MARK: initializing the constraints...
        initConstraints()
    }
    
    // Defining the Logo Image attributes...
    func setupImageViewLogo() {
        imageViewLogo = UIImageView()
        imageViewLogo.image = UIImage(named: "logo") // Replace "logo" with your actual image file name
        imageViewLogo.contentMode = .scaleAspectFit // Maintain aspect ratio
        imageViewLogo.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageViewLogo)
    }
    
    // Defining the Label attributes...
    func setupLabelHello() {
        labelHello = UILabel()
        labelHello.text = "FREE STUFF IN BOSTON!"
        labelHello.font = UIFont.systemFont(ofSize: 24)
        labelHello.textColor = .systemBlue
        labelHello.textAlignment = .center
        labelHello.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelHello)
    }
    
    // Defining the Button attributes...
    func setupButtonLogin() {
            buttonLogin = UIButton(type: .system)
            var configuration = UIButton.Configuration.filled()
            configuration.title = "Log In!"
            configuration.baseBackgroundColor = .systemBlue
            configuration.baseForegroundColor = .white
            configuration.cornerStyle = .medium // Rounded corners
            configuration.titlePadding = 10
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20) // Padding
            buttonLogin.configuration = configuration
            buttonLogin.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(buttonLogin)
        }
        
        func setupButtonSignup() {
            buttonSignup = UIButton(type: .system)
            var configuration = UIButton.Configuration.filled()
            configuration.title = "Sign Up!"
            configuration.baseBackgroundColor = .systemGreen
            configuration.baseForegroundColor = .white
            configuration.cornerStyle = .medium // Rounded corners
            configuration.titlePadding = 10
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20) // Padding
            buttonSignup.configuration = configuration
            buttonSignup.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(buttonSignup)
        }
    // MARK: Initializing the constraints...
    func initConstraints() {
        NSLayoutConstraint.activate(
            [
                // MARK: constraints for imageViewLogo...
                imageViewLogo.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
                imageViewLogo.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                imageViewLogo.widthAnchor.constraint(equalToConstant: 100),
                imageViewLogo.heightAnchor.constraint(equalToConstant: 100),
                
                // MARK: constraints for labelHello...
                labelHello.topAnchor.constraint(equalTo: imageViewLogo.bottomAnchor, constant:60),
                labelHello.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
             
                // MARK: constraints for buttonLogin...
                buttonLogin.topAnchor.constraint(equalTo: labelHello.bottomAnchor, constant: 60),
                buttonLogin.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
                
                // MARK: constraints for buttonSignup...
                buttonSignup.topAnchor.constraint(equalTo: buttonLogin.bottomAnchor, constant: 16),
                buttonSignup.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor)
            ]
        )
    }
    
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
}

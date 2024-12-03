//
//  InitialView.swift
//  BostonFree
//
//  Created by user267597 on 12/3/24.

import UIKit

class InitialView: UIView {
    
    // UI Elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "BostonFree"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Signup", for: .normal)
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
        self.addSubview(titleLabel)
        self.addSubview(loginButton)
        self.addSubview(signupButton)
        
        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -100),
            
            // Login Button
            loginButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Signup Button
            signupButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            signupButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 40),
            signupButton.widthAnchor.constraint(equalToConstant: 200),
            signupButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}


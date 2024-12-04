//
//  HomePageView.swift
//  BostonFree
//
//  Created by user267597 on 12/3/24.
//
import UIKit

class HomePageView: UIView {
    
    // UI Elements
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Home Page"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email: "
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.backgroundColor = UIColor.systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let viewEventsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View Free Events", for: .normal)
        button.backgroundColor = UIColor.systemBlue
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
        self.addSubview(welcomeLabel)
        self.addSubview(emailLabel)
        self.addSubview(logoutButton)
        self.addSubview(viewEventsButton)
        
        NSLayoutConstraint.activate([
            // Welcome Label
            welcomeLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40),
            welcomeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            // Email Label
            emailLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            emailLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            // View Events Button
            viewEventsButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            viewEventsButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 30),
            viewEventsButton.widthAnchor.constraint(equalToConstant: 200),
            viewEventsButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Logout Button
            logoutButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoutButton.topAnchor.constraint(equalTo: viewEventsButton.bottomAnchor, constant: 20),
            logoutButton.widthAnchor.constraint(equalToConstant: 200),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}


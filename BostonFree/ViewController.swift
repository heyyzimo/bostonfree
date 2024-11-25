//
//  SignLogScreenView.swift
//  BostonFree
//
//  Created by Zimo Liu on 11/25/24.
//


import UIKit

class ViewController: UIViewController {
    
    //MARK: declaring the UI elements...
    var labelHello:UILabel! //"Hello World!" Label...
    var buttonLogin: UIButton! //Button...
    var buttonSignup: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //MARK: setting up UI elements...
        setupLabelHello()
        setupButtonLogin()
        setupButtonSignup()
        
        //MARK: initializing the constraints...
        initConstraints()
    }
    
    //Defining the Label attributes...
    func setupLabelHello(){
        labelHello = UILabel()
        labelHello.text = "FREE STUFF IN BOSTON!"
        labelHello.font = UIFont.systemFont(ofSize: 24)
        labelHello.textColor = .systemBlue
        labelHello.textAlignment = .center
        labelHello.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelHello)
    }
    
    //Defining the Button attributes...
    func setupButtonLogin(){
        buttonLogin = UIButton(type: .system) //You need to set the type when you create a Button. We use default system button...
        buttonLogin.setTitle("Log In!", for: .normal)
        buttonLogin.tintColor = .systemBlue
        buttonLogin.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonLogin)
    }
    
    //Defining the Button attributes...
    func setupButtonSignup(){
        buttonSignup = UIButton(type: .system) //You need to set the type when you create a Button. We use default system button...
        buttonSignup.setTitle("Sign Up!", for: .normal)
        buttonSignup.tintColor = .systemBlue
        buttonSignup.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonSignup)
    }
    
    //MARK: Initializing the constraints...
    func initConstraints(){
        NSLayoutConstraint.activate(
            [
                //MARK: constraints for labelHello...
                labelHello.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
                labelHello.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
             
                
                //MARK: constraints for buttonLogin...
                buttonLogin.topAnchor.constraint(equalTo: labelHello.bottomAnchor, constant: 16),
                buttonLogin.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                                
                
                buttonSignup.topAnchor.constraint(equalTo: buttonLogin.bottomAnchor, constant: 16),
                buttonSignup.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)

            ]
        )
    }
    
}

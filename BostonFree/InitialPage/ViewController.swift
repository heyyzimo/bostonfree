//
//  ViewController.swift
//  BostonFree
//
//  Created by user267597 on 12/3/24.
//
// Controllers/InitialViewController.swift
import UIKit

class ViewController: UIViewController {
    
    let initialView = InitialView()
    
    override func loadView() {
        self.view = initialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialView.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        initialView.signupButton.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
    }
    
    @objc func handleLogin() {
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @objc func handleSignup() {
        let signupVC = SignupViewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
}

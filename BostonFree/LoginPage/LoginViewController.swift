//
//  LoginViewController.swift
//  BostonFree
//
//  Created by user267597 on 12/3/24.
//
import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    let loginView = LoginView()
    let db = Firestore.firestore()
    
    override func loadView() {
        self.view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginView.signinButton.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        loginView.signupPrompt.addTarget(self, action: #selector(handleSignupPrompt), for: .touchUpInside)
    }
    
    @objc func handleSignIn() {
        guard let email = loginView.emailTextField.text, !email.isEmpty,
              let password = loginView.passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please enter email and password.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.showAlert(message: error.localizedDescription)
                return
            }
            // login successed, jump to home page
            let homeVC = HomePageViewController()
            self?.navigationController?.setViewControllers([homeVC], animated: true)
        }
    }
    
    @objc func handleSignupPrompt() {
        guard let navigationController = self.navigationController,
              let initialVC = navigationController.viewControllers.first else {
            return
        }
        let signupVC = SignupViewController()
        navigationController.setViewControllers([initialVC, signupVC], animated: true)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


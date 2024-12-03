//
//  SignupViewController.swift
//  BostonFree
//
//  Created by user267597 on 12/3/24.
//
import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignupViewController: UIViewController {
    
    let signupView = SignupView()
    let db = Firestore.firestore()
    
    override func loadView() {
        self.view = signupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signupView.signupButton.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        signupView.signinPrompt.addTarget(self, action: #selector(handleSigninPrompt), for: .touchUpInside)
    }
    
    @objc func handleSignup() {
        guard let email = signupView.emailTextField.text, !email.isEmpty,
              let password = signupView.passwordTextField.text, !password.isEmpty,
              let confirmPassword = signupView.confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert(message: "Please fill in all fields.")
            return
        }
        
        guard password == confirmPassword else {
            showAlert(message: "Passwords do not match.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.showAlert(message: error.localizedDescription)
                return
            }
            
            guard let user = authResult?.user else { return }
            
            // store user data to Firestore
            self?.db.collection("users").document(user.uid).setData([
                "email": email,
                "uid": user.uid,
                "createdAt": Timestamp(date: Date())
            ]) { err in
                if let err = err {
                    self?.showAlert(message: "Error adding user to Firestore: \(err.localizedDescription)")
                    return
                }
                // sign up successed, jump to home page
                let homeVC = HomePageViewController()
                self?.navigationController?.setViewControllers([homeVC], animated: true)
            }
        }
    }
    
    @objc func handleSigninPrompt() {
        guard let navigationController = self.navigationController,
              let initialVC = navigationController.viewControllers.first else {
            return
        }
        let loginVC = LoginViewController()
        navigationController.setViewControllers([initialVC, loginVC], animated: true)
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


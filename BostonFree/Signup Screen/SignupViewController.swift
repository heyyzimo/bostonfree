//
//  SignupViewController.swift
//  BostonFree
//
//  Created by Zimo Liu on 11/26/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {
    
    let registerView = SignupView()
    let childProgressView = ProgressSpinnerViewController()
    
    override func loadView() {
        view = registerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Register"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        registerView.registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    @objc func registerButtonTapped(){
        registerNewAccount()
    }
    
    
    func registerNewAccount() {
            showActivityIndicator()

            guard let name = registerView.textFieldName.text,
                  let email = registerView.textFieldEmail.text,
                  let password = registerView.textFieldPassword.text,
                  let confirmPassword = registerView.textFieldConfirmPassword.text,
                  !name.isEmpty,
                  !email.isEmpty,
                  !password.isEmpty,
                  !confirmPassword.isEmpty else {
                hideActivityIndicator()
                showAlert(message: "Please fill in all fields.")
                return
            }

            // Check if passwords match
            if password != confirmPassword {
                hideActivityIndicator()
                showAlert(message: "Passwords do not match. Please try again.")
                return
            }

            // Proceed with Firebase Authentication
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                guard let self = self else { return }
                if let error = error {
                    self.hideActivityIndicator()
                    self.showAlert(message: error.localizedDescription)
                    return
                }

                guard let user = result?.user else {
                    self.hideActivityIndicator()
                    self.showAlert(message: "User data not available.")
                    return
                }

                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChanges { [weak self] error in
                    if let error = error {
                        self?.hideActivityIndicator()
                        self?.showAlert(message: error.localizedDescription)
                        return
                    }

                    self?.saveUserToFirestore(user: user, name: name, email: email)
                }
            }
        }


        func saveUserToFirestore(user: FirebaseAuth.User, name: String, email: String){
            let db = Firestore.firestore()
            let userData: [String: Any] = [
                "name": name,
                "email": email,
                "uid": user.uid
            ]
            
            db.collection("users").document(user.uid).setData(userData) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    self.hideActivityIndicator()
                    self.showAlert(message: error.localizedDescription)
                    return
                }

                self.hideActivityIndicator()
                let chatListVC = ChatListViewController()
                self.navigationController?.pushViewController(chatListVC, animated: true)
            }
        }
    }

    extension RegisterViewController: ProgressSpinnerDelegate {
        func showActivityIndicator(){
            addChild(childProgressView)
            view.addSubview(childProgressView.view)
            childProgressView.view.frame = view.bounds
            childProgressView.didMove(toParent: self)
        }
        
        func hideActivityIndicator(){
            childProgressView.willMove(toParent: nil)
            childProgressView.view.removeFromSuperview()
            childProgressView.removeFromParent()
        }
    }

    extension RegisterViewController {
        func showAlert(message: String){
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

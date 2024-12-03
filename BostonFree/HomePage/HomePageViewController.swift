//
//  HomePageViewController.swift
//  BostonFree
//
//  Created by user267597 on 12/3/24.
//
import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomePageViewController: UIViewController {
    
    let homeView = HomePageView()
    let db = Firestore.firestore()
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeView.logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        fetchUserData()
    }
    
    func fetchUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).getDocument { [weak self] (document, error) in
            if let error = error {
                self?.showAlert(message: "Error fetching user data: \(error.localizedDescription)")
                return
            }
            if let document = document, document.exists {
                let data = document.data()
                let email = data?["email"] as? String ?? "N/A"
                DispatchQueue.main.async {
                    self?.homeView.emailLabel.text = "Email: \(email)"
                }
            } else {
                self?.showAlert(message: "User data not found.")
            }
        }
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            // back to initial page
            let initialVC = ViewController()
            navigationController?.setViewControllers([initialVC], animated: true)
        } catch let signOutError as NSError {
            showAlert(message: "Error signing out: \(signOutError.localizedDescription)")
        }
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


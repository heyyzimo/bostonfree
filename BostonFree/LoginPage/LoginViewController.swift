//
//  LoginViewController.swift
//  BostonFree
//
//  Created by user267597 on 12/3/24.
//增加了验证邮箱格式
//增加了显示加载动画，就是没反应过来时会有小圈圈
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
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    @objc func handleSignIn() {
        guard let email = loginView.emailTextField.text, !email.isEmpty,
              let password = loginView.passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please enter email and password.")
            return
        }
        
        //验证邮箱
        if !isValidEmail(email) {
                showAlert(message: "Please enter a valid email address.")
                return
            }
        
        // 显示加载动画
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.center = view.center
            activityIndicator.startAnimating()
            self.view.addSubview(activityIndicator)
        
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            
            // 停止加载动画
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()

            if let error = error {
                self?.showAlert(message: error.localizedDescription)
                return
            }
            
            
            // 获取 user 对象
            guard let user = authResult?.user else {
                self?.showAlert(message: "Failed to retrieve user information.")
                return
            }
        
            // 检查并创建初始 Profile
            self?.checkAndCreateProfile(for: user.uid)

            // login successed, jump to home page
            let homeVC = HomePageViewController()
            self?.navigationController?.setViewControllers([homeVC], animated: true)
        }
    }
    
    
    // 检查并创建初始 Profile
    func checkAndCreateProfile(for userId: String) {
        db.collection("profiles").document(userId).getDocument { document, error in
            if let error = error {
                print("Failed to check user profile: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                print("User profile already exists.")
            } else {
                self.createInitialProfile(for: userId)
            }
        }
    }

    // 创建初始用户 Profile
    func createInitialProfile(for userId: String) {
        let initialProfile: [String: Any] = [
            "name": "New222User",
            "bio": "This222 is a new profile.",
            "city": "Unkn222own",
            "hobby": "Non22e",
            "pronoun": "Th22ey/Them",
            "phoneNumber": "22N/A"
        ]
        
        db.collection("profiles").document(userId).setData(initialProfile) { error in
            if let error = error {
                print("Failed to create initial profile: \(error.localizedDescription)")
            } else {
                print("Initial profile created successfully.")
            }
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


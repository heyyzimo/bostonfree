//
//  SignupViewController.swift
//  BostonFree
//
//  Created by user267597 on 12/3/24.
//一signup自动给他建造一个default版本的userprofile数据库一面制造bug
//验证邮箱对不对
//firebase识别具体是什么error并且显示showalert里
//设置密码too weak会有提示不行
//邮箱in use也会有提示
//增加了加载时的小圈圈！
//重建了profile初始化

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
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}" // 邮箱格式
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx) // 匹配正则表达式
        return emailTest.evaluate(with: email) // 验证是否符合正则
    }
    
    func handleFirebaseError(_ error: Error) {
        let errorCode = (error as NSError).code
        switch errorCode {
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            showAlert(message: "This email is already in use. Please use a different email.")
        case AuthErrorCode.weakPassword.rawValue:
            showAlert(message: "Your password is too weak. Please use a stronger password.")
        case AuthErrorCode.invalidEmail.rawValue:
            showAlert(message: "The email address is invalid.")
        default:
            showAlert(message: error.localizedDescription) // 其他错误显示默认信息
        }
    }


    
    @objc func handleSignup() {
        guard let email = signupView.emailTextField.text, !email.isEmpty,
              let password = signupView.passwordTextField.text, !password.isEmpty,
              let confirmPassword = signupView.confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert(message: "Please fill in all fields.")
            return
        }
        
        // 验证邮箱格式
        if !isValidEmail(email) {
            signupView.errorLabel.text = "Invalid email format."
            return
        }
        
        if password != confirmPassword {
            signupView.errorLabel.text = "Passwords do not match."
            return
        }
        signupView.errorLabel.text = ""
        
        // 显示加载动画小圈圈
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            // 移除加载动画
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            
            if let error = error {
                self?.handleFirebaseError(error)
                return
            }
            
            guard let user = authResult?.user else { return }
            
            // 存储用户基础数据到 Firestore
            self?.db.collection("users").document(user.uid).setData([
                "email": email,
                "uid": user.uid,
                "createdAt": Timestamp(date: Date())
            ]) { err in
                if let err = err {
                    self?.showAlert(message: "Error adding user to Firestore: \(err.localizedDescription)")
                    return
                }
                
                // 创建用户初始 Profile
                self?.createInitialProfile(for: user.uid)
                
                // 注册成功后跳转到主页
                let homeVC = HomePageViewController()
                self?.navigationController?.setViewControllers([homeVC], animated: true)
            }
        }
    }

    
    func createInitialProfile(for userId: String) {
        let initialProfile: [String: Any] = [
            "name": "Newuer",
            "bio": "This is profile.",
            "city": "boston(default value)",
            "hobby": "unknown",
            "pronoun": "unknow",
            "phoneNumber": "unknown"
        ]
        
        db.collection("profiles").document(userId).setData(initialProfile) { error in
            if let error = error {
                print("Failed to create initial profile: \(error.localizedDescription)")
            } else {
                print("Initial profile created successfully.")
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


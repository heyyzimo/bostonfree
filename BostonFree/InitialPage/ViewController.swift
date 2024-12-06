//
//  ViewController.swift
//  BostonFree
//
//  Created by user267597 on 12/3/24.
//
// Controllers/InitialViewController.swift

//added title

import UIKit

class ViewController: UIViewController {
    
    let initialView = InitialView()
    
    override func loadView() {
        self.view = initialView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Welcome"
        
        initialView.loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        initialView.signupButton.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        
        // 检查用户登录状态
        checkLoginStatus()
    }
    
    // 检查用户登录状态
    func checkLoginStatus() {
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        if isLoggedIn {
            // 如果用户已登录，直接跳转到主页
            let homeVC = HomePageViewController()
            navigationController?.setViewControllers([homeVC], animated: true)
        }
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

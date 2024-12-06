//
//  ProfileViewController.swift
//  BostonFree
//
//  Created by Zimo Liu on 12/6/24.
//

import UIKit

class ProfileViewController: UIViewController {
    let profileView = ProfileView()
    var userProfile: UserProfile? // 添加 userProfile 属性

    override func loadView() {
        self.view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"

        // 使用 userProfile 更新界面
        if let userProfile = userProfile {
            profileView.detailsLabel.text = """
            Name: \(userProfile.name ?? "N/33A")
            City: \(userProfile.city ?? "N/33A")
            Hobby: \(userProfile.hobby ?? "N/33A")
            Pronoun: \(userProfile.pronoun ?? "N33/A")
            Phone Number: \(userProfile.phoneNumber ?? "N/33A")
            Bio: \(userProfile.selfIntroduction ?? "N33/A")
            """
        } else {
            profileView.detailsLabel.text = "No profile data available."
        }
    }
}

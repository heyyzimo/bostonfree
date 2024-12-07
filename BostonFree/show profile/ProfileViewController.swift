//
//  ProfileViewController.swift
//  BostonFree
//
//  Created by Zimo Liu on 12/6/24.
//

import UIKit
import FirebaseFirestore

class ProfileViewController: UIViewController {
    let profileView = ProfileView()
    var userProfile: UserProfile? // 用于接收用户资料
    var userId: String? // 用户 ID
    let db = Firestore.firestore()

    override func loadView() {
        self.view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"

        // 加载用户数据
        loadUserProfile()
        
        // 监听用户数据更新通知
        NotificationCenter.default.addObserver(self, selector: #selector(handleProfileUpdated), name: Notification.Name("ProfileUpdated"), object: nil)
    }

    func loadUserProfile() {
        guard let userId = userId else { return }
        
        db.collection("profiles").document(userId).getDocument { [weak self] document, error in
            if let error = error {
                print("Failed to load user profile: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data() ?? [:]
                self?.updateUI(with: UserProfile(data: data))
            } else {
                print("No profile found for user ID \(userId)")
            }
        }
    }

    func updateUI(with userProfile: UserProfile) {
        profileView.detailsLabel.text = """
        Name: \(userProfile.name ?? "N/A")
        City: \(userProfile.city ?? "N/A")
        Hobby: \(userProfile.hobby ?? "N/A")
        Pronoun: \(userProfile.pronoun ?? "N/A")
        Phone Number: \(userProfile.phoneNumber ?? "N/A")
        Bio: \(userProfile.selfIntroduction ?? "N/A")
        """
        
        if let profileImageUrl = userProfile.profileImageUrl, let url = URL(string: profileImageUrl) {
            profileView.profileImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person.circle"))
        } else {
            profileView.profileImageView.image = UIImage(systemName: "person.circle")
        }
    }

    @objc func handleProfileUpdated() {
        // 在用户更新后重新加载数据
        loadUserProfile()
    }
}



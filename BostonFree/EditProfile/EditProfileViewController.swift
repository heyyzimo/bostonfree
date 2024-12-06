//
//  EditProfileViewController.swift
//  BostonFree
//
//  Created by Zimo Liu on 12/6/24.
//

import UIKit
import FirebaseFirestore

class EditProfileViewController: UIViewController {
    
    let editProfileView = EditProfileView()
    let db = Firestore.firestore()
    var userId: String?
    
    override func loadView() {
        self.view = editProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Profile"
        
        editProfileView.saveButton.addTarget(self, action: #selector(saveProfile), for: .touchUpInside)
    }
    
    @objc func saveProfile() {
        guard let userId = userId else { return }
        
        let name = editProfileView.nameTextField.text ?? ""
        let city = editProfileView.cityTextField.text ?? ""
        let hobby = editProfileView.hobbyTextField.text ?? ""
        let pronoun = editProfileView.pronounTextField.text ?? ""
        let phoneNumber = editProfileView.phoneNumberTextField.text ?? ""
        let selfIntroduction = editProfileView.selfIntroductionTextView.text ?? ""
        
        let userData: [String: Any] = [
            "name": name,
            "city": city,
            "hobby": hobby,
            "pronoun": pronoun,
            "phoneNumber": phoneNumber,
            "selfIntroduction": selfIntroduction
        ]
        
        db.collection("profiles").document(userId).setData(userData, merge: true) { [weak self] error in
            if let error = error {
                self?.showAlert(message: "Failed to save profile: \(error.localizedDescription)")
                return
            }
            
            self?.navigationController?.popViewController(animated: true)
            
            // 通知主页刷新数据
            NotificationCenter.default.post(name: Notification.Name("ProfileUpdated"), object: nil, userInfo: userData)

        }
    }


    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

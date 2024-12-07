//
//  EditProfileViewController.swift
//  BostonFree
//
//  Created by Zimo Liu on 12/6/24.
//填充已有信息在edit界面
//把userprofile data collect了传给了firebase
//最重要的是把最终数据库结果传回了homepage notification center
//通过profileupdated
import UIKit
import FirebaseFirestore
import FirebaseStorage


class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let editProfileView = EditProfileView()
    let db = Firestore.firestore()
    var userId: String?
    var userProfile: UserProfile? // 用于接收用户的现有资料

    override func loadView() {
        self.view = editProfileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Profile"

        // 预填充用户资料
        populateFieldsWithUserProfile()

        // 保存按钮事件
        editProfileView.saveButton.addTarget(self, action: #selector(saveProfile), for: .touchUpInside)
        editProfileView.selectProfileImageButton.addTarget(self, action: #selector(selectProfileImage), for: .touchUpInside)

    }
    
    @objc func selectProfileImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self // 设置代理
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }


    func populateFieldsWithUserProfile() {
        guard let userProfile = userProfile else { return }

        // 将 userProfile 的数据填入相应的输入框
        editProfileView.nameTextField.text = userProfile.name
        editProfileView.cityTextField.text = userProfile.city
        editProfileView.hobbyTextField.text = userProfile.hobby
        editProfileView.pronounTextField.text = userProfile.pronoun
        editProfileView.phoneNumberTextField.text = userProfile.phoneNumber
        editProfileView.selfIntroductionTextView.text = userProfile.selfIntroduction
    }

//    @objc func saveProfile() {
//        guard let userId = userId else { return }
//
//        let name = editProfileView.nameTextField.text ?? ""
//        let city = editProfileView.cityTextField.text ?? ""
//        let hobby = editProfileView.hobbyTextField.text ?? ""
//        let pronoun = editProfileView.pronounTextField.text ?? ""
//        let phoneNumber = editProfileView.phoneNumberTextField.text ?? ""
//        let selfIntroduction = editProfileView.selfIntroductionTextView.text ?? ""
//
//        let userData: [String: Any] = [
//            "name": name,
//            "city": city,
//            "hobby": hobby,
//            "pronoun": pronoun,
//            "phoneNumber": phoneNumber,
//            "selfIntroduction": selfIntroduction
//        ]
//
//        db.collection("profiles").document(userId).setData(userData, merge: true) { [weak self] error in
//            if let error = error {
//                self?.showAlert(message: "Failed to save profile: \(error.localizedDescription)")
//                return
//            }
//
//            self?.navigationController?.popViewController(animated: true)
//
//            // 通知主页刷新数据
//            NotificationCenter.default.post(name: Notification.Name("hahahaupdated"), object: nil, userInfo: userData)
//        }
//    }
    @objc func saveProfile() {
        guard let userId = userId else { return }

        // 获取文本输入
        let name = editProfileView.nameTextField.text ?? ""
        let city = editProfileView.cityTextField.text ?? ""
        let hobby = editProfileView.hobbyTextField.text ?? ""
        let pronoun = editProfileView.pronounTextField.text ?? ""
        let phoneNumber = editProfileView.phoneNumberTextField.text ?? ""
        let selfIntroduction = editProfileView.selfIntroductionTextView.text ?? ""

        // 检查是否有图片需要上传
        if let image = editProfileView.profileImageView.image, let imageData = image.jpegData(compressionQuality: 0.8) {
            let imageName = "\(userId)_profile.jpg"
            let storageRef = Storage.storage().reference().child("profile_pictures/\(imageName)")

            storageRef.putData(imageData, metadata: nil) { [weak self] _, error in
                if let error = error {
                    self?.showAlert(message: "Failed to upload image: \(error.localizedDescription)")
                    return
                }
                storageRef.downloadURL { url, error in
                    if let error = error {
                        self?.showAlert(message: "Failed to get image URL: \(error.localizedDescription)")
                        return
                    }
                    guard let imageUrl = url?.absoluteString else { return }

                    // 存储用户资料和图片 URL
                    self?.saveUserProfile(name: name, city: city, hobby: hobby, pronoun: pronoun, phoneNumber: phoneNumber, selfIntroduction: selfIntroduction, imageUrl: imageUrl)
                }
            }
        } else {
            // 没有图片上传时只保存文字信息
            saveUserProfile(name: name, city: city, hobby: hobby, pronoun: pronoun, phoneNumber: phoneNumber, selfIntroduction: selfIntroduction, imageUrl: nil)
        }
    }

    func saveUserProfile(name: String, city: String, hobby: String, pronoun: String, phoneNumber: String, selfIntroduction: String, imageUrl: String?) {
        var userData: [String: Any] = [
            "name": name,
            "city": city,
            "hobby": hobby,
            "pronoun": pronoun,
            "phoneNumber": phoneNumber,
            "selfIntroduction": selfIntroduction
        ]
        if let imageUrl = imageUrl {
            userData["profileImageUrl"] = imageUrl
        }

        db.collection("profiles").document(userId!).setData(userData, merge: true) { [weak self] error in
            if let error = error {
                self?.showAlert(message: "Failed to save profile: \(error.localizedDescription)")
                return
            }

            NotificationCenter.default.post(name: Notification.Name("ProfileUpdated"), object: nil, userInfo: userData)
            self?.navigationController?.popViewController(animated: true)
        }
    }


    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

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
import SDWebImage

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let editProfileView = EditProfileView()
    let db = Firestore.firestore()
    var userId: String?
    var userProfile: UserProfile?

    override func loadView() {
        self.view = editProfileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveProfile))
        populateFieldsWithUserProfile()
        editProfileView.selectProfileImageButton.addTarget(self, action: #selector(selectProfileImage), for: .touchUpInside)
    }

    func populateFieldsWithUserProfile() {
        guard let userProfile = userProfile else { return }
        editProfileView.nameTextField.text = userProfile.name
        editProfileView.cityTextField.text = userProfile.city
        editProfileView.hobbyTextField.text = userProfile.hobby
        editProfileView.pronounTextField.text = userProfile.pronoun
        editProfileView.phoneNumberTextField.text = userProfile.phoneNumber
        editProfileView.selfIntroductionTextView.text = userProfile.selfIntroduction
        if let profileImageUrl = userProfile.profileImageUrl, let url = URL(string: profileImageUrl) {
            editProfileView.profileImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person.circle"))
        }
    }

    @objc func selectProfileImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            editProfileView.profileImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            editProfileView.profileImageView.image = originalImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    @objc func saveProfile() {
        guard let userId = userId else {
            showAlert(message: "User ID is missing.")
            return
        }

        editProfileView.activityIndicator.startAnimating()
        navigationItem.rightBarButtonItem?.isEnabled = false

        let name = editProfileView.nameTextField.text ?? ""
        let city = editProfileView.cityTextField.text ?? ""
        let hobby = editProfileView.hobbyTextField.text ?? ""
        let pronoun = editProfileView.pronounTextField.text ?? ""
        let phoneNumber = editProfileView.phoneNumberTextField.text ?? ""
        let selfIntroduction = editProfileView.selfIntroductionTextView.text ?? ""

        if let image = editProfileView.profileImageView.image, let imageData = image.jpegData(compressionQuality: 0.8) {
            let imageName = "\(userId)_profile.jpg"
            let storageRef = Storage.storage().reference().child("profile_pictures/\(imageName)")

            storageRef.putData(imageData, metadata: nil) { [weak self] _, error in
                if let error = error {
                    self?.showAlert(message: "Failed to upload image: \(error.localizedDescription)")
                    self?.stopActivityIndicator()
                    return
                }
                storageRef.downloadURL { url, error in
                    if let error = error {
                        self?.showAlert(message: "Failed to get image URL: \(error.localizedDescription)")
                        self?.stopActivityIndicator()
                        return
                    }
                    guard let imageUrl = url?.absoluteString else {
                        self?.showAlert(message: "Image URL is invalid.")
                        self?.stopActivityIndicator()
                        return
                    }
                    self?.saveUserProfile(userId: userId, name: name, city: city, hobby: hobby, pronoun: pronoun, phoneNumber: phoneNumber, selfIntroduction: selfIntroduction, imageUrl: imageUrl)
                }
            }
        } else {
            saveUserProfile(userId: userId, name: name, city: city, hobby: hobby, pronoun: pronoun, phoneNumber: phoneNumber, selfIntroduction: selfIntroduction, imageUrl: nil)
        }
    }

    func saveUserProfile(userId: String, name: String, city: String, hobby: String, pronoun: String, phoneNumber: String, selfIntroduction: String, imageUrl: String?) {
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

        db.collection("profiles").document(userId).setData(userData, merge: true) { [weak self] error in
            self?.stopActivityIndicator()
            if let error = error {
                self?.showAlert(message: "Failed to save profile: \(error.localizedDescription)")
                return
            }

            NotificationCenter.default.post(name: Notification.Name("ProfileUpdated"), object: nil, userInfo: userData)
            
            self?.navigationController?.popViewController(animated: true)
        }
    }

    func stopActivityIndicator() {
        editProfileView.activityIndicator.stopAnimating()
        navigationItem.rightBarButtonItem?.isEnabled = true
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

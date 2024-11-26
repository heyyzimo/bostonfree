//
//  SignLogScreenView.swift
//  BostonFree
//
//  Created by Zimo Liu on 11/25/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {
    
    let mainScreen = SignLogScreenView()
    
    override func loadView() {
            view = mainScreen
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


    
//    var handleAuth: AuthStateDidChangeListenerHandle?
//    
//    var currentUser: FirebaseAuth.User?
//    
//    let database = Firestore.firestore()
//    
//    var users: [UserModel] = []
//    
//    let childProgressView = ProgressSpinnerViewController()
//    
//    override func loadView() {
//        view = mainScreen
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        handleAuth = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
//            guard let self = self else { return }
//            if user == nil{
//                self.currentUser = nil
//                self.mainScreen.labelText.text = "Please sign in to see the chats!"
//                self.mainScreen.floatingButtonAddContact.isEnabled = false
//                self.mainScreen.floatingButtonAddContact.isHidden = true
//
//                self.users.removeAll()
//                self.mainScreen.tableViewContacts.reloadData()
//
//                self.setupRightBarButton(isLoggedin: false)
//                
//            } else {
//                self.currentUser = user
//                self.mainScreen.labelText.text = "Welcome \(user?.displayName ?? "Anonymous")!"
//                self.mainScreen.floatingButtonAddContact.isEnabled = true
//                self.mainScreen.floatingButtonAddContact.isHidden = false
//                self.setupRightBarButton(isLoggedin: true)
//                self.fetchAllUsers()
//            }
//        }
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        title = "My Chats"
//
//        mainScreen.tableViewContacts.delegate = self
//        mainScreen.tableViewContacts.dataSource = self
//
//        mainScreen.tableViewContacts.separatorStyle = .none
//
//        navigationController?.navigationBar.prefersLargeTitles = true
//
//        view.bringSubviewToFront(mainScreen.floatingButtonAddContact)
//
//        mainScreen.floatingButtonAddContact.addTarget(self, action: #selector(addChatButtonTapped), for: .touchUpInside)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        if let handleAuth = handleAuth {
//            Auth.auth().removeStateDidChangeListener(handleAuth)
//        }
//    }
//    
//    @objc func addChatButtonTapped(){
//        let chatListVC = ChatListViewController()
//        navigationController?.pushViewController(chatListVC, animated: true)
//    }
//    
//    func fetchAllUsers(){
//        showActivityIndicator()
//        
//        database.collection("users").getDocuments { [weak self] snapshot, error in
//            guard let self = self else { return }
//            
//            DispatchQueue.main.async {
//                self.hideActivityIndicator()
//            }
//            
//            if let error = error {
//                self.showAlert(message: error.localizedDescription)
//                return
//            }
//            
//            guard let documents = snapshot?.documents else { return }
//            
//            var allUsers: [UserModel] = []
//            for doc in documents {
//                let data = doc.data()
//                let user = UserModel(dictionary: data)
//                if user.uid != self.currentUser?.uid {
//                    allUsers.append(user)
//                }
//            }
//            
//            self.users = allUsers
//            DispatchQueue.main.async {
//                self.mainScreen.tableViewContacts.reloadData()
//            }
//        }
//    }
//
//    func showAlert(message: String){
//        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
//    }
//}
//
//extension ViewController: UITableViewDataSource, UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//         return users.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let user = users[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
//        
//        var content = cell.defaultContentConfiguration()
//        content.text = user.name
//        content.secondaryText = user.email
//        cell.contentConfiguration = content
//        
//        cell.accessoryType = .disclosureIndicator
//        
//        return cell
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedUser = users[indexPath.row]
//        let chatVC = ChatViewController(receiver: selectedUser)
//        navigationController?.pushViewController(chatVC, animated: true)
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//}
//
//extension ViewController: ProgressSpinnerDelegate {
//    func showActivityIndicator(){
//        addChild(childProgressView)
//        view.addSubview(childProgressView.view)
//        childProgressView.view.frame = view.bounds
//        childProgressView.didMove(toParent: self)
//    }
//    
//    func hideActivityIndicator(){
//        childProgressView.willMove(toParent: nil)
//        childProgressView.view.removeFromSuperview()
//        childProgressView.removeFromParent()
//    }
//}

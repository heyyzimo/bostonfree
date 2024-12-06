import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomePageViewController: UIViewController {
    
    let homeView = HomePageView()
    let db = Firestore.firestore()
    var userModel: UserModel? // 注册时的基础数据
    var userProfile: UserProfile? // 用户详细信息
    var isProfileLoading = false // 控制 Profile 加载状态
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 加载注册用户的基本信息
        fetchUserData()
        
        // 加载用户的扩展信息
        loadUserProfile()
        
        // 按钮事件绑定
        homeView.editProfileButton.addTarget(self, action: #selector(handleEditProfile), for: .touchUpInside)
        homeView.showProfileButton.addTarget(self, action: #selector(handleShowProfile), for: .touchUpInside)
        homeView.viewEventsButton.addTarget(self, action: #selector(handleViewEvents), for: .touchUpInside)
        homeView.logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        // 监听用户资料更新
        NotificationCenter.default.addObserver(self, selector: #selector(handleProfileUpdated(_:)), name: Notification.Name("ProfileUpdated"), object: nil)
    }
    
    
    
    /// 加载注册用户的基础信息
    func fetchUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).getDocument { [weak self] (document, error) in
            if let error = error {
                self?.showAlert(message: "Error fetching user data: \(error.localizedDescription)")
                return
            }
            if let document = document, document.exists {
                let data = document.data()
                self?.userModel = UserModel(dictionary: data ?? [:]) // 初始化 UserModel
                DispatchQueue.main.async {
                    self?.homeView.emailLabel.text = "Email: \(self?.userModel?.email ?? "N/A")"
                }
            } else {
                self?.showAlert(message: "User data not found.")
            }
        }
    }
    
    
    func loadUserProfile() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        isProfileLoading = true
        db.collection("profiles").document(userId).getDocument { [weak self] document, error in
            if let error = error {
                self?.showAlert(message: "Failed to load user profile: \(error.localizedDescription)")
                self?.isProfileLoading = false
                return
            }
            
            if let document = document, document.exists {
                let data = document.data() ?? [:]
                self?.userProfile = UserProfile(data: data) // 初始化 UserProfile
                print("User profile loaded:")
            } else {
                print("User profile not found.")
            }
            self?.isProfileLoading = false
        }
    }

    
    /// 更新用户资料
    @objc func handleProfileUpdated(_ notification: Notification) {
        print("updaed")
        loadUserProfile() // 重加载用户详细信息
    }

    
    /// 编辑用户资料
    @objc func handleEditProfile() {
        let editProfileVC = EditProfileViewController()
        editProfileVC.userId = Auth.auth().currentUser?.uid
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    
    @objc func handleShowProfile() {
        guard let userProfile = userProfile else {
            showAlert(message: "User profile is still loading. Please wait a moment.")
            return
        }
        
        let profileVC = ProfileViewController()
        profileVC.userProfile = userProfile
        navigationController?.pushViewController(profileVC, animated: true)
    }

    
    /// 查看活动
    @objc func handleViewEvents() {
        let eventsListVC = EventsListViewController()
        navigationController?.pushViewController(eventsListVC, animated: true)
    }
    
    /// 登出
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let initialVC = ViewController()
            navigationController?.setViewControllers([initialVC], animated: true)
        } catch let signOutError as NSError {
            showAlert(message: "Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    /// 显示错误信息
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

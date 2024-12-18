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
        NotificationCenter.default.addObserver(self, selector: #selector(handleProfileUpdated(_:)), name: Notification.Name("hahahaupdated"), object: nil)
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
        editProfileVC.userProfile = userProfile // 传递当前用户的详细资料
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    
    @objc func handleShowProfile() {
        guard let userId = Auth.auth().currentUser?.uid else {
            showAlert(message: "User ID not found. Please log in again.")
            return
        }
        
        let profileVC = ProfileViewController()
        profileVC.userId = userId // 传递用户 ID
        
        // 跳转前重新加载用户数据
        db.collection("profiles").document(userId).getDocument { [weak self] document, error in
            if let error = error {
                self?.showAlert(message: "Failed to load user profile: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data() ?? [:]
                profileVC.userProfile = UserProfile(data: data) // 将最新数据传递给 ProfileViewController
            } else {
                print("User profile not found.")
            }
            
            // 在数据加载完成后跳转
            self?.navigationController?.pushViewController(profileVC, animated: true)
        }
    }


    
    /// 查看活动
    @objc func handleViewEvents() {
        let eventsListVC = EventsListViewController()
        navigationController?.pushViewController(eventsListVC, animated: true)
    }
    

    @objc func handleLogout() {
        do {
            // 调用 Firebase 的登出方法
            try Auth.auth().signOut()
            
            // 清除 UserDefaults 中的登录状态
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            UserDefaults.standard.removeObject(forKey: "userEmail") // 如果需要也可以移除用户数据
            
            // 跳转到初始页面
            let initialVC = ViewController() // 假设 ViewController 是初始页面
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

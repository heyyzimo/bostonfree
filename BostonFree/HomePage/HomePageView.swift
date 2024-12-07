//做了edit profile和show profile两个按钮
//用来更新显示profile
import UIKit

class HomePageView: UIView {
    
    let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.backgroundColor = UIColor.systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let showProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Profile", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // UI Elements
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Home Page"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email: "
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "freehomepage") // 确保图片名与项目中的一致
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.backgroundColor = UIColor.systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let viewEventsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View Free Events", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        self.addSubview(welcomeLabel)
        self.addSubview(emailLabel)
        self.addSubview(logoImageView)
        self.addSubview(logoutButton)
        self.addSubview(editProfileButton)
        self.addSubview(viewEventsButton)
        self.addSubview(showProfileButton)
        
        NSLayoutConstraint.activate([
            // Welcome Label
            welcomeLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40),
            welcomeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            // Email Label
            emailLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            emailLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            // Logo Image View
            logoImageView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            // Edit Profile Button
            editProfileButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            editProfileButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            editProfileButton.widthAnchor.constraint(equalToConstant: 200),
            editProfileButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Show Profile Button
            showProfileButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            showProfileButton.topAnchor.constraint(equalTo: editProfileButton.bottomAnchor, constant: 20),
            showProfileButton.widthAnchor.constraint(equalToConstant: 200),
            showProfileButton.heightAnchor.constraint(equalToConstant: 50),
            
            // View Events Button
            viewEventsButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            viewEventsButton.topAnchor.constraint(equalTo: showProfileButton.bottomAnchor, constant: 30),
            viewEventsButton.widthAnchor.constraint(equalToConstant: 200),
            viewEventsButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Logout Button
            logoutButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logoutButton.topAnchor.constraint(equalTo: viewEventsButton.bottomAnchor, constant: 20),
            logoutButton.widthAnchor.constraint(equalToConstant: 200),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

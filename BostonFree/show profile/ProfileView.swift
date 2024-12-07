//
//  ProfileView.swift
//  BostonFree
//
//  Created by Zimo Liu on 12/6/24.
//

import UIKit

class ProfileView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 60 // 圆形头像
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.systemGray5 // 默认背景
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupLayout() {
        self.addSubview(profileImageView)
        self.addSubview(detailsLabel)
        
        NSLayoutConstraint.activate([
            // Profile Image View
            profileImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            
            // Details Label
            detailsLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            detailsLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            detailsLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9)
        ])
    }
}

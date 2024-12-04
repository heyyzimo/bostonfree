//
//  EventDetailsView.swift
//  BostonFree
//
//  Created by user267597 on 12/3/24.
//
import UIKit
import SDWebImage

class EventDetailsView: UIView {
    
    let eventImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let eventNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let websiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Visit Website", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupLayout()
    }
    
    func setupLayout() {
        self.addSubview(eventImageView)
        self.addSubview(eventNameLabel)
        self.addSubview(locationLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(websiteButton)
        
        NSLayoutConstraint.activate([
            eventImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            eventImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            eventImageView.widthAnchor.constraint(equalToConstant: 200),
            eventImageView.heightAnchor.constraint(equalToConstant: 200),
            
            eventNameLabel.topAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: 16),
            eventNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            eventNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            
            locationLabel.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 8),
            locationLabel.leftAnchor.constraint(equalTo: eventNameLabel.leftAnchor),
            locationLabel.rightAnchor.constraint(equalTo: eventNameLabel.rightAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 16),
            descriptionLabel.leftAnchor.constraint(equalTo: eventNameLabel.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: eventNameLabel.rightAnchor),
            
            websiteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            websiteButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func configure(with event: EventModel) {
        eventNameLabel.text = event.name
        locationLabel.text = "Location: \(event.location)"
        descriptionLabel.text = event.description ?? "No Description"
        if let website = event.website, let _ = URL(string: website) {
            websiteButton.isHidden = false
            websiteButton.addTarget(self, action: #selector(openWebsite), for: .touchUpInside)
            websiteButton.tag = event.eventId.hash 
            websiteButton.accessibilityLabel = website
        } else {
            websiteButton.isHidden = true
        }
        if let url = URL(string: event.imageUrl) {
            eventImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
        } else {
            eventImageView.image = UIImage(systemName: "photo")
        }
    }
    
    @objc func openWebsite(sender: UIButton) {
        guard let website = sender.accessibilityLabel, let url = URL(string: website) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

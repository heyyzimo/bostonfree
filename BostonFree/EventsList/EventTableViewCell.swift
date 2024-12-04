//
//  EventTableViewCell.swift
//  BostonFree
//
//  Created by user267597 on 12/3/24.
//
import UIKit
import SDWebImage

class EventTableViewCell: UITableViewCell {
    
    let eventImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let eventNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        contentView.addSubview(eventImageView)
        contentView.addSubview(eventNameLabel)
        contentView.addSubview(distanceLabel)
        
        NSLayoutConstraint.activate([
            eventImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            eventImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            eventImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            eventImageView.widthAnchor.constraint(equalToConstant: 120),
            eventImageView.heightAnchor.constraint(equalToConstant: 120),

            eventNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            eventNameLabel.leftAnchor.constraint(equalTo: eventImageView.rightAnchor, constant: 16),
            eventNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),

            distanceLabel.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 8),
            distanceLabel.leftAnchor.constraint(equalTo: eventNameLabel.leftAnchor),
            distanceLabel.rightAnchor.constraint(equalTo: eventNameLabel.rightAnchor)
        ])
    }

    func configure(with event: EventModel) {
        eventNameLabel.text = event.name
        if let url = URL(string: event.imageUrl) {
            eventImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
        } else {
            eventImageView.image = UIImage(systemName: "photo")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


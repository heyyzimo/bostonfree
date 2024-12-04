//
//  EventTableViewCell.swift
//  BostonFree
//
//  Created by user267597 on 12/3/24.
//
import UIKit
import SDWebImage

class EventTableViewCell: UITableViewCell {

    let eventNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let eventImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        contentView.addSubview(eventNameLabel)
        contentView.addSubview(eventImageView)
        
        NSLayoutConstraint.activate([
            eventNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            eventNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            eventNameLabel.rightAnchor.constraint(equalTo: eventImageView.leftAnchor, constant: -16),

            eventImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            eventImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            eventImageView.widthAnchor.constraint(equalToConstant: 120),
            eventImageView.heightAnchor.constraint(equalToConstant: 120) 
        ])
    }
    
    //configure cell content
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

//
//  EventsListView.swift
//  BostonFree
//
//  Created by user267597 on 12/3/24.
//
import UIKit

class EventsListView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.register(EventTableViewCell.self, forCellReuseIdentifier: "EventCell")
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // init data source
    var events: [EventModel] = []
    
    // Callback when an event is selected
    var didSelectEvent: ((EventModel) -> Void)?
    
    let postEventButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post Free Event!", for: .normal)
        button.backgroundColor = UIColor.systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Callback for post event button tap
    var didTapPostEvent: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupLayout()
        tableView.delegate = self
        tableView.dataSource = self
        postEventButton.addTarget(self, action: #selector(handlePostEvent), for: .touchUpInside)
        
        tableView.rowHeight = 150
        tableView.estimatedRowHeight = 150
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupLayout() {
        self.addSubview(tableView)
        self.addSubview(postEventButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: postEventButton.topAnchor, constant: -10),
            
            postEventButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            postEventButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            postEventButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            postEventButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func handlePostEvent() {
        didTapPostEvent?()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return events.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventTableViewCell else {
            return UITableViewCell()
        }
        let event = events[indexPath.row]
        cell.configure(with: event)
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        didSelectEvent?(event)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//
//  EventsListView.swift
//  BostonFree
//
//  Created by user267597 on 12/3/24.
//
import UIKit

class EventsListView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    let currentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Current", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let upcomingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Upcoming", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let segmentLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.register(EventTableViewCell.self, forCellReuseIdentifier: "EventCell")
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // init data
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
    
    var didSelectSegment: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupLayout()
        tableView.delegate = self
        tableView.dataSource = self
        postEventButton.addTarget(self, action: #selector(handlePostEvent), for: .touchUpInside)
        tableView.rowHeight = 150
        tableView.estimatedRowHeight = 150
        
        currentButton.addTarget(self, action: #selector(handleCurrentTapped), for: .touchUpInside)
        upcomingButton.addTarget(self, action: #selector(handleUpcomingTapped), for: .touchUpInside)
    }
    
    @objc func handleCurrentTapped() {
        currentButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        upcomingButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        didSelectSegment?("current")
    }
    
    @objc func handleUpcomingTapped() {
        upcomingButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        currentButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        didSelectSegment?("upcoming")
    }
    
    @objc func handlePostEvent() {
        didTapPostEvent?()
    }

    func setupLayout() {
        self.addSubview(currentButton)
        self.addSubview(upcomingButton)
        self.addSubview(segmentLine)
        self.addSubview(tableView)
        self.addSubview(postEventButton)
        
        NSLayoutConstraint.activate([
            currentButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            currentButton.leftAnchor.constraint(equalTo: self.leftAnchor),
            currentButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            currentButton.heightAnchor.constraint(equalToConstant: 40),
            
            upcomingButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            upcomingButton.rightAnchor.constraint(equalTo: self.rightAnchor),
            upcomingButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            upcomingButton.heightAnchor.constraint(equalToConstant: 40),
            
            segmentLine.topAnchor.constraint(equalTo: currentButton.bottomAnchor),
            segmentLine.leftAnchor.constraint(equalTo: self.leftAnchor),
            segmentLine.rightAnchor.constraint(equalTo: self.rightAnchor),
            segmentLine.heightAnchor.constraint(equalToConstant: 1),
            
            tableView.topAnchor.constraint(equalTo: segmentLine.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: postEventButton.topAnchor, constant: -10),
            
            postEventButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            postEventButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            postEventButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            postEventButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // UITableViewDataSource & Delegate
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

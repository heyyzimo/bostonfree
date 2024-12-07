//
//  EventsListViewController.swift
//  BostonFree
//
//  Created by user267597 on 12/3/24.
//

import UIKit
import FirebaseFirestore

class EventsListViewController: UIViewController {
    
    let eventsListView = EventsListView()
    let db = Firestore.firestore()
    
    var listener: ListenerRegistration?
    
    var allEvents: [EventModel] = []
    var currentMode: String = "current" // 默认为 current
    
    override func loadView() {
        self.view = eventsListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Free Events"
        let mapImage = UIImage(systemName: "map")
        let mapBarButton = UIBarButtonItem(image: mapImage, style: .plain, target: self, action: #selector(mapButtonTapped))
        self.navigationItem.rightBarButtonItem = mapBarButton

        eventsListView.didSelectEvent = { [weak self] event in
            let detailsVC = EventDetailsViewController(event: event)
            self?.navigationController?.pushViewController(detailsVC, animated: true)
        }
        
        eventsListView.didTapPostEvent = { [weak self] in
            let postEventVC = PostEventViewController()
            self?.navigationController?.pushViewController(postEventVC, animated: true)
        }
        
        eventsListView.didSelectSegment = { [weak self] mode in
            self?.currentMode = mode
            self?.filterEvents()
        }

        fetchEvents()
    }
    
    @objc func mapButtonTapped() {
        let mapVC = MapViewController()
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func fetchEvents() {
        listener = db.collection("events").order(by: "createdAt", descending: true).addSnapshotListener { [weak self] (snapshot, error) in
            if let error = error {
                self?.showAlert(message: "Error fetching events: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else { return }
            
            self?.allEvents = documents.map { doc in
                return EventModel(documentId: doc.documentID, dictionary: doc.data())
            }
            
            DispatchQueue.main.async {
                self?.filterEvents()
            }
        }
    }
    
    func filterEvents() {
        let now = Date()
        if currentMode == "current" {
            // current events：startTime <= now <= endTime
            eventsListView.events = allEvents.filter { event in
                return event.startTime <= now && now <= event.endTime
            }
        } else {
            // upcoming events：now < startTime
            eventsListView.events = allEvents.filter { event in
                return now < event.startTime
            }
        }
        eventsListView.tableView.reloadData()
    }
    
    deinit {
        listener?.remove()
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

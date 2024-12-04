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
    
    override func loadView() {
        self.view = eventsListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Free Events"
        eventsListView.didSelectEvent = { [weak self] event in
            let detailsVC = EventDetailsViewController(event: event)
            self?.navigationController?.pushViewController(detailsVC, animated: true)
        }
        eventsListView.didTapPostEvent = { [weak self] in
            let postEventVC = PostEventViewController()
            self?.navigationController?.pushViewController(postEventVC, animated: true)
        }
        fetchEvents()
    }
    
    func fetchEvents() {
        listener = db.collection("events").order(by: "createdAt", descending: true).addSnapshotListener { [weak self] (snapshot, error) in
            if let error = error {
                self?.showAlert(message: "Error fetching events: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else { return }
            self?.eventsListView.events = documents.map { doc in
                return EventModel(documentId: doc.documentID, dictionary: doc.data())
            }
            DispatchQueue.main.async {
                self?.eventsListView.tableView.reloadData()
            }
        }
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

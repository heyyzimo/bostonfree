//
//  EventDetailsViewController.swift
//  BostonFree
//
//  Created by user267597 on 12/3/24.
//
import UIKit

class EventDetailsViewController: UIViewController {
    
    let eventDetailsView = EventDetailsView()
    let event: EventModel
    
    init(event: EventModel) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = eventDetailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Event Details"
        eventDetailsView.configure(with: event)
        setupMapButtonAction()
    }
    
    func setupMapButtonAction() {
        eventDetailsView.mapButton.addTarget(self, action: #selector(handleMapButton), for: .touchUpInside)
    }
    
    @objc func handleMapButton() {
        let mapVC = MapViewController()
        mapVC.selectedEvent = event 
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



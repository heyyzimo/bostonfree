////  MapViewController.swift//  BostonFree////  Created by user267597 on 12/4/24.//import UIKitimport MapKitimport FirebaseFirestoreimport CoreLocationclass MapViewController: UIViewController {        let mapView = MKMapView()    let tableView = UITableView()    let locationManager = CLLocationManager()    let db = Firestore.firestore()        var userLocation: CLLocation?    var events: [EventModel] = []    var sortedEvents: [EventModel] = []    var selectedEvent: EventModel?        let detailsView = UIView()    let detailsLabel = UILabel()    let backButton = UIButton(type: .system)        override func viewDidLoad() {        super.viewDidLoad()        self.title = "Nearby Events"        view.backgroundColor = .white        setupLayout()        setupLocationManager()        setupTableView()        setupDetailsView()        fetchEvents()                detailsView.isHidden = true        tableView.isHidden = false    }        func setupLayout() {        mapView.translatesAutoresizingMaskIntoConstraints = false        tableView.translatesAutoresizingMaskIntoConstraints = false        detailsView.translatesAutoresizingMaskIntoConstraints = false        detailsLabel.translatesAutoresizingMaskIntoConstraints = false        backButton.translatesAutoresizingMaskIntoConstraints = false                view.addSubview(mapView)        view.addSubview(tableView)        view.addSubview(detailsView)        detailsView.addSubview(detailsLabel)        detailsView.addSubview(backButton)                NSLayoutConstraint.activate([            // First half            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),            mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),                        // Second half            tableView.topAnchor.constraint(equalTo: mapView.bottomAnchor),            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),                        detailsView.topAnchor.constraint(equalTo: mapView.bottomAnchor),            detailsView.leftAnchor.constraint(equalTo: view.leftAnchor),            detailsView.rightAnchor.constraint(equalTo: view.rightAnchor),            detailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),            detailsLabel.topAnchor.constraint(equalTo: detailsView.topAnchor, constant: 60),            detailsLabel.leftAnchor.constraint(equalTo: detailsView.leftAnchor, constant: 16),            detailsLabel.rightAnchor.constraint(equalTo: detailsView.rightAnchor, constant: -16),            detailsLabel.bottomAnchor.constraint(lessThanOrEqualTo: detailsView.bottomAnchor, constant: -16),            backButton.topAnchor.constraint(equalTo: detailsView.topAnchor, constant: 16),            backButton.leftAnchor.constraint(equalTo: detailsView.leftAnchor, constant: 16),            backButton.widthAnchor.constraint(equalToConstant: 60),            backButton.heightAnchor.constraint(equalToConstant: 30)        ])    }        func setupTableView() {        tableView.delegate = self        tableView.dataSource = self        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "EventCell")        tableView.rowHeight = 150        tableView.separatorStyle = .none    }        func setupDetailsView() {        detailsView.backgroundColor = UIColor.systemGray6        detailsLabel.numberOfLines = 0        detailsLabel.font = UIFont.systemFont(ofSize: 16)        detailsView.isHidden = true                backButton.setTitle("Back", for: .normal)        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)    }        @objc func handleBackButton() {        detailsView.isHidden = true        tableView.isHidden = false    }        func setupLocationManager() {        locationManager.delegate = self        locationManager.desiredAccuracy = kCLLocationAccuracyBest                checkLocationAuthorization()    }        func checkLocationAuthorization() {        switch locationManager.authorizationStatus {        case .authorizedWhenInUse, .authorizedAlways:            mapView.showsUserLocation = true            locationManager.startUpdatingLocation()        case .denied, .restricted:            showAlert(message: "Location access is needed to display nearby events.")        case .notDetermined:            locationManager.requestWhenInUseAuthorization()        @unknown default:            break        }    }        func fetchEvents() {        db.collection("events").addSnapshotListener { [weak self] (snapshot, error) in            if let error = error {                self?.showAlert(message: "Error fetching events: \(error.localizedDescription)")                return            }            guard let documents = snapshot?.documents else { return }            self?.events = documents.map { doc in                return EventModel(documentId: doc.documentID, dictionary: doc.data())            }            self?.sortEventsByDistance()            self?.addAnnotations()            self?.tableView.reloadData()                        if let selected = self?.selectedEvent {                self?.selectEvent(selected)            }        }    }        func sortEventsByDistance() {        guard let userLocation = userLocation else {            sortedEvents = events            return        }        sortedEvents = events.sorted { (event1, event2) -> Bool in            let location1 = CLLocation(latitude: event1.latitude, longitude: event1.longitude)            let location2 = CLLocation(latitude: event2.latitude, longitude: event2.longitude)            return location1.distance(from: userLocation) < location2.distance(from: userLocation)        }    }        func addAnnotations() {        mapView.removeAnnotations(mapView.annotations.filter { !($0 is MKUserLocation) })        for event in sortedEvents {            let annotation = MKPointAnnotation()            annotation.title = event.name            annotation.subtitle = event.location            annotation.coordinate = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)            mapView.addAnnotation(annotation)        }    }        func showAlert(message: String) {        let alert = UIAlertController(title: "Notice",                                      message: message,                                      preferredStyle: .alert)        alert.addAction(UIAlertAction(title: "OK",                                      style: .default,                                      handler: nil))        present(alert, animated: true, completion: nil)    }        func selectEvent(_ event: EventModel) {        let coordinate = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)        let region = MKCoordinateRegion(center: coordinate,                                        latitudinalMeters: 1000,                                        longitudinalMeters: 1000)        mapView.setRegion(region, animated: true)                if let annotation = mapView.annotations.first(where: { ($0.title ?? "") == event.name }) {            mapView.selectAnnotation(annotation, animated: true)        }                displayDetails(for: event)                tableView.isHidden = true        detailsView.isHidden = false    }        func displayDetails(for event: EventModel) {        let descriptionText = event.description ?? "No Description"        let websiteText = event.website ?? "N/A"        let detailsText = """        \(event.name)        Location: \(event.location)        Description:        \(descriptionText)        Website: \(websiteText)        """        let attributedText = NSMutableAttributedString(string: detailsText)        let boldKeywords = ["Location:", "Description:", "Website:"]        attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 0, length: detailsText.utf16.count))        for keyword in boldKeywords {            if let range = detailsText.range(of: keyword) {                let nsRange = NSRange(range, in: detailsText)                attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 18), range: nsRange)            }        }        if let nameRange = detailsText.range(of: event.name) {            let nsRange = NSRange(nameRange, in: detailsText)            attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 20), range: nsRange)        }        detailsLabel.attributedText = attributedText    }        override func viewWillAppear(_ animated: Bool) {        super.viewWillAppear(animated)        if let selected = selectedEvent {            selectEvent(selected)        } else {            detailsView.isHidden = true            tableView.isHidden = false        }    }}extension MapViewController: CLLocationManagerDelegate {    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {        checkLocationAuthorization()    }        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {        guard let latestLocation = locations.last else { return }        userLocation = latestLocation        let region = MKCoordinateRegion(center: latestLocation.coordinate,                                        latitudinalMeters: 1000,                                        longitudinalMeters: 1000)        mapView.setRegion(region, animated: true)        sortEventsByDistance()        addAnnotations()        tableView.reloadData()        locationManager.stopUpdatingLocation()                if let selected = selectedEvent {            selectEvent(selected)        }    }        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {        showAlert(message: "Failed to get your location: \(error.localizedDescription)")    }}extension MapViewController: UITableViewDataSource, UITableViewDelegate {    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {         return sortedEvents.count    }         func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventTableViewCell else {            return UITableViewCell()        }        let event = sortedEvents[indexPath.row]        let location = CLLocation(latitude: event.latitude, longitude: event.longitude)        let distanceInMeters = userLocation?.distance(from: location) ?? 0        let distanceString = String(format: "%.1f km", distanceInMeters / 1000)        cell.configure(with: event)        cell.distanceLabel.text = "\(distanceString) away"        return cell    }        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {        return 150    }        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        let selectedEvent = sortedEvents[indexPath.row]        selectEvent(selectedEvent)        tableView.deselectRow(at: indexPath, animated: true)    }}
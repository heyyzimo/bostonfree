//
//  EventModel.swift
//  BostonFree
//
//  Created by user267597 on 12/3/24.
//
import Foundation
import FirebaseFirestore

struct EventModel {
    let eventId: String
    let name: String
    let location: String
    let latitude: Double
    let longitude: Double
    let imageUrl: String
    let description: String?
    let website: String?
    let createdAt: Date
    let startTime: Date
    let endTime: Date

    init(documentId: String, dictionary: [String: Any]) {
        self.eventId = documentId
        self.name = dictionary["name"] as? String ?? ""
        self.location = dictionary["location"] as? String ?? ""
        self.latitude = dictionary["latitude"] as? Double ?? 0.0
        self.longitude = dictionary["longitude"] as? Double ?? 0.0
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.description = dictionary["description"] as? String
        self.website = dictionary["website"] as? String

        if let timestamp = dictionary["createdAt"] as? Timestamp {
            self.createdAt = timestamp.dateValue()
        } else {
            self.createdAt = Date()
        }
        if let startTimestamp = dictionary["startTime"] as? Timestamp {
            self.startTime = startTimestamp.dateValue()
        } else {
            self.startTime = Date()
        }

        if let endTimestamp = dictionary["endTime"] as? Timestamp {
            self.endTime = endTimestamp.dateValue()
        } else {
            self.endTime = Date().addingTimeInterval(3600)
        }
    }
}

//
//  EventModel.swift
//  BostonFree
//
//  Created by user267597 on 12/3/24.
//
import Foundation
import FirebaseCore

struct EventModel {
    let eventId: String
    let name: String
    let location: String
    let imageUrl: String
    let description: String?
    let website: String?
    let createdAt: Date
    
    init(documentId: String, dictionary: [String: Any]) {
        self.eventId = documentId
        self.name = dictionary["name"] as? String ?? ""
        self.location = dictionary["location"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.description = dictionary["description"] as? String
        self.website = dictionary["website"] as? String
        if let timestamp = dictionary["createdAt"] as? Timestamp {
            self.createdAt = timestamp.dateValue()
        } else {
            self.createdAt = Date()
        }
    }
}
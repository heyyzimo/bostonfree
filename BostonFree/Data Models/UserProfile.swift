//
//  UserProfile.swift
//  BostonFree
//
//  Created by Zimo Liu on 12/6/24.
//

struct UserProfile {
    var name: String?
    var city: String?
    var hobby: String?
    var pronoun: String?
    var phoneNumber: String?
    var selfIntroduction: String?
    
    init(data: [String: Any]) {
        self.name = data["name"] as? String
        self.city = data["city"] as? String
        self.hobby = data["hobby"] as? String
        self.pronoun = data["pronoun"] as? String
        self.phoneNumber = data["phoneNumber"] as? String
        self.selfIntroduction = data["selfIntroduction"] as? String
    }
}

//
//  UserModel.swift
//  ChatAppiOS
//
//  Created by Vasu Sinojia on 16/05/24.
//

import Foundation

struct UserModel: Codable {
    var userId: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
    var isActive: Bool?
    var isOnline: Bool?
    var image: String?
    var lastSeen: Int?

    // Optionally, you can add an initializer if you want to initialize a UserModel manually
    init(userId: String? = nil, firstName: String? = nil, lastName: String? = nil, email: String? = nil, password: String? = nil, isActive: Bool? = true, isOnline: Bool? = true, image: String? = "", lastSeen: Int? = 0) {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.isActive = isActive
        self.isOnline = isOnline
        self.image = image
        self.lastSeen = lastSeen
    }
}

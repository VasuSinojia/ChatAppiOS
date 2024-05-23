//
//  MyManager.swift
//  ChatAppiOS
//
//  Created by Vasu-Macbook-Pro  on 23/05/24.
//

import Foundation

class MyManager {
    
    static var user: UserModel = UserModel()
    
    static func getUserData() -> UserModel {
        return user
    }
    
    static func setUserData(userModel: UserModel) {
        user = userModel
    }
}

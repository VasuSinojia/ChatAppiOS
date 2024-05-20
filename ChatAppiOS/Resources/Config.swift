//
//  Config.swift
//  ChatAppiOS
//
//  Created by Vasu-MacMini-M1 on 24/07/23.
//

import Foundation
import UIKit

class Config {
    static func showAlert(with error: String, vc: UIViewController) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            
        }
        alertController.addAction(okAction)
        vc.present(alertController, animated: true)
        
    }
}

class Constants {
    
    static let sharedInstance = Constants()
    
    let isLoggedIn = "isLoggedIn"
    let KEY_COLLECTION_USER = "users"
    let KEY_COLLECTION_CONVERSATIONS = "conversations"
    let KEY_NAME = "name"
    let KEY_EMAIL = "email"
    let KEY_PASSWORD = "password"
    let KEY_PREFERANCE_NAME = "chatPref"
    let KEY_IS_SIGN_IN = "isSignIn"
    let KEY_USER_ID = "userId"
    let KEY_IMAGE = "image"
}

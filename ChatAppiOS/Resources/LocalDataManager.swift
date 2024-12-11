//
//  LocalDataManager.swift
//  ChatAppiOS
//
//  Created by Vasu-Macbook-Pro  on 28/05/24.
//

import Foundation

class LocalDataManager {
    static public func setIsLoggedIn()  {
        UserDefaults.standard.set(true, forKey: Constants.sharedInstance.ISLOGGEDIN)
    }
    
    static public func getIsLoggedIn() -> Bool {
        let isLoggedInValue = UserDefaults.standard.bool(forKey: Constants.sharedInstance.ISLOGGEDIN)
        return isLoggedInValue
    }
}

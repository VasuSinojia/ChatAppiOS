//
//  NavigationManager.swift
//  ChatAppiOS
//
//  Created by Vasu-MacMini-M1 on 11/07/23.
//

import Foundation
import UIKit

class NavigationManager {
    
    static let sharedInstance = NavigationManager()
    
    public func changeRootNavController(storyboard: String, viewController: String) {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: viewController) as UIViewController
        UIApplication.shared.keyWindow?.rootViewController = vc
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
}

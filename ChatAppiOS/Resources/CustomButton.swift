//
//  CustomButton.swift
//  ChatAppiOS
//
//  Created by Vasu-MacMini-M1 on 05/07/23.
//

import Foundation
import UIKit
import GoogleSignIn

@IBDesignable
class CustomButton : UIButton {
    @IBInspectable var cornerRadius : CGFloat = 10.0 {
        didSet {
            setUpLayout()
        }
    }
    
    private func setUpLayout() {
        self.layer.cornerRadius = self.cornerRadius
    }
    
}

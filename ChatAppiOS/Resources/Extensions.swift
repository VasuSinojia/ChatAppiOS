//
//  Extensions.swift
//  ChatAppiOS
//
//  Created by Vasu-MacMini-M1 on 04/07/23.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var borderWidth: CGFloat {
        get  {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            layer.borderColor = UIColor.white.cgColor
        }
    }
    @IBInspectable var borderRadius: CGFloat {
        get  {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.borderColor = UIColor.white.cgColor
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get  {
            return UIColor(cgColor: layer.borderColor ?? UIColor.white.cgColor)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var isCircular: Bool {
        get {
            return true
        }
        set {
            layer.borderWidth = 1
            layer.masksToBounds = false
            layer.borderColor = UIColor.black.cgColor
            layer.cornerRadius = self.frame.height / 2
            clipsToBounds = true
        }
    }
    
    public var width : CGFloat {
        return self.frame.size.width
    }
    public var height : CGFloat {
        return self.frame.size.height
    }
    public var top : CGFloat {
        return self.frame.origin.y
    }
    public var bottom : CGFloat {
        return self.frame.size.height + self.frame.origin.y
    }
    public var left : CGFloat {
        return self.frame.origin.x
    }
    public var right : CGFloat {
        return self.frame.size.width + self.frame.origin.x
    }
}

extension UIImageView {
    func makeRounded() {
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}

extension UIButton {
    
}

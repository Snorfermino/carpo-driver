//
//  ConstraintExtension.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/15/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    func isConstraintOfView(view: UIView) -> Bool {
        if firstItem as? UIView == view || secondItem as? UIView == view {
            return true
        }
        return false
    }
    
    func isTopConstraint() -> Bool {
        if firstAttribute == .top && secondAttribute == .top { return true }
        return false
    }
    
    func isBotConstraint() -> Bool {
        if firstAttribute == .bottom && secondAttribute == .bottom { return true }
        return false
    }
    
    
    func isLeadConstraint() -> Bool {
        if firstAttribute == .leading && secondAttribute == .leading { return true }
        return false
    }
    
    func isTrailConstraint() -> Bool {
        if firstAttribute == .trailing && secondAttribute == .trailing { return true }
        return false
    }
    
    func isVerticalConstraint() -> Bool {
        if (firstAttribute == .top && secondAttribute == .bottom) ||
            (firstAttribute == .bottom && secondAttribute == .top) {
            return true
        }
        return false
    }
    
    func isHorizonConstraint() -> Bool {
        if (firstAttribute == .leading && secondAttribute == .trailing) ||
            (firstAttribute == .trailing && secondAttribute == .leading) {
            return true
        }
        return false
    }
    
    func isRationWidthHeight() -> Bool {
        if (firstAttribute == .width && secondAttribute == .height) ||
            (firstAttribute == .height && secondAttribute == .width) {
            return true
        }
        return false
    }
    
    func isWidthConstraint() -> Bool {
        if (firstAttribute == .width  && firstItem as! NSObject == self) ||
            (secondAttribute == .width && secondItem as! NSObject == self) {
            
            return true
        }
        return false
    }
    
    func isHeightConstraint() -> Bool {
        if (firstAttribute == .height  && firstItem as! NSObject == self) ||
            (secondAttribute == .height && secondItem as! NSObject == self) {
            
            return true
        }
        return false
    }
    
    func isCenterX() -> Bool {
        if (firstAttribute == .centerX && secondAttribute == .centerX) {
            return true
        }
        return false
    }
    
    func isCenterY() -> Bool {
        if (firstAttribute == .centerY && secondAttribute == .centerY) {
            return true
        }
        return false
    }
}

extension NSLayoutConstraint {
    @IBInspectable var rationWidth: Bool {
        get { return false }
        set (scale) {
            if scale {
                let screenWidth = UIScreen.main.bounds.size.width
                let defaultWidth = Config.shareInstance.defaultWidth
                
                constant = constant * screenWidth / defaultWidth
            }
        }
    }
    
    @IBInspectable var rationHeight: Bool {
        get { return false }
        set (scale) {
            if scale {
                let screenHeight = UIScreen.main.bounds.size.height
                let defaultHeight = Config.shareInstance.defaultHeight
                
                constant = constant * screenHeight / defaultHeight
            }
        }
    }
}

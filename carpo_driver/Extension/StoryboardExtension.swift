//
//  StoryboardExtension.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/13/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//
import UIKit
import Foundation
extension UIStoryboard {
    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    func viewController<T: UIViewController>(_ viewControllerType: T.Type) -> T {
        return self.instantiateViewController(withIdentifier: String.className(viewControllerType)) as! T
    }
}

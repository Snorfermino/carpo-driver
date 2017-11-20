//
//  StringExtension.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/13/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import Foundation

extension String {
    
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        let index = self.index(startIndex, offsetBy: from)
        return String(self[index...endIndex])
    }
    
    var length: Int {
        return self.characters.count
    }
}


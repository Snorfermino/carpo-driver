//
//  DateExtension.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/21/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import Foundation
extension Date {
    func format(_ format: String? = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from:self)
        return dateString
    }
    
}

//
//  CGDriverMarker.swift
//  Rider
//
//  Created by Đinh Anh Huy on 11/23/16.
//  Copyright © 2016 Đinh Anh Huy. All rights reserved.
//

import UIKit
class CGDriverMarker: CGMarker {
    
    convenience init(map: CGMapView, image: UIImage) {
        self.init()
        
        self.map = map
          icon = UIImage(data: UIImagePNGRepresentation(image)!, scale: 2)

        groundAnchor = CGPoint(x: 0.5, y: 0.5)
    }
    
    
    
    
    func changeSize(size : CGFloat) {
        icon = icon?.resizeImage(newWidth: size)
    }
    func scaleSize(image: UIImage, size : CGFloat) {
        icon = UIImage(data: UIImagePNGRepresentation(image)!, scale: CGFloat(size))
    }
    
}


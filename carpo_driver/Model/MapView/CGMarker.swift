//
//  CGMarker.swift
//  CGMapView
//
//  Created by Đinh Anh Huy on 10/25/16.
//  Copyright © 2016 Đinh Anh Huy. All rights reserved.
//

import UIKit
import GoogleMaps
import Pulsator

public class CGMarker: GMSMarker {
    static var rotateTime: TimeInterval = 0.5/90 //rotate 90 degree in 0.5s
    var locationInfos = [CGLocation]()
    public var startTransform: CATransform3D!
    var id: String?

    var markerView: UIView?
    lazy var pulsator = Pulsator()
    let numPulse = 7
    let radiusPulse: CGFloat = 40
    let durationPulse: TimeInterval = 7
    let markerBaseDegree: CGFloat = -90

    var titleLabel: UILabel?

    override init() {
        super.init()

    }

    convenience init(map: CGMapView, image: UIImage) {
        self.init()

        self.map = map
        icon = image

        groundAnchor = CGPoint(x: 0.5, y: 0.5)
    }

    //    let circle = GMSCircle()
    public func updateLocation(location: CGLocation,
                               updateRotation: Bool = false,
                               useAnimation: Bool = true) {

        print("location-\(location.toJSON())")

        if locationInfos.count == 0 {
            locationInfos.append(location)
            locationInfos.append(location)
            startTransform = layer.transform
        } else {
            locationInfos[0] = locationInfos[1].copyValue
            locationInfos[1] = location.copyValue
        }
        let currentTime = Int(locationInfos.last!.timeStamp)
        let lastTime = Int(locationInfos.first!.timeStamp)

        let moveDuration: Double = Double(currentTime - lastTime)

        print("\(moveDuration) = \(currentTime) - \(lastTime)")


        if useAnimation && map != nil {
            print("moveDuration \(moveDuration)")

            CATransaction.begin()
            CATransaction.setAnimationDuration(moveDuration)
            self.position = location.clLocation
            CATransaction.commit()
        } else {
            position = location.clLocation
        }
        if updateRotation { self.updateRotation() }
    }

    public func updateRotation() {

        let lastLocation = locationInfos.last!
        let firstLocation = locationInfos.first!

        if firstLocation == lastLocation { return }

        let deltaX = lastLocation.longitude - firstLocation.longitude
        let deltaY = lastLocation.latitude - firstLocation.latitude
        let v1 = CGVector(dx: 0, dy: 1)
        let v2 = CGVector(dx: deltaX, dy: deltaY)
        let angle = (atan2(v1.dy, v1.dx) - atan2(v2.dy, v2.dx)).radiansToDegrees + markerBaseDegree
        print("angle \(angle)")

        let rotateDuration = CGMarker.rotateTime * 90

        CATransaction.begin()
        CATransaction.setAnimationDuration(rotateDuration)
        rotation = CLLocationDegrees(angle)
        CATransaction.commit()
    }

    func addPulsatorWith(image: UIImage,
                         pulseColor: UIColor = UIColor(hex: "73CDFD")) {
        self.icon = nil

        markerView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))

        let pinImage = UIImageView()
        pinImage.translatesAutoresizingMaskIntoConstraints = false
        pinImage.contentMode = .scaleAspectFit
        pinImage.image = image

        markerView?.addSubview(pinImage)
        markerView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:
            "H:|-0-[pin]-0-|", options: [], metrics: nil, views: ["pin": pinImage]))
        markerView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:
            "V:[pin(45)]", options: [], metrics: nil, views: ["pin": pinImage]))
        markerView?.addConstraint(NSLayoutConstraint(item: pinImage,
                                                     attribute: .bottom,
                                                     relatedBy: .equal,
                                                     toItem: markerView,
                                                     attribute: .centerY,
                                                     multiplier: 1,
                                                     constant: 0))

        titleLabel = UILabel()
        titleLabel?.numberOfLines = 2
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont(name: "Helvetica Bold", size: 14)
        titleLabel!.translatesAutoresizingMaskIntoConstraints = false
        pinImage.addSubview(titleLabel!)
        _ = titleLabel?.addConstraintCenterXToView(view: pinImage, commonParrentView: pinImage)
        _ = titleLabel?.addConstraintCenterYToView(view: pinImage, commonParrentView: pinImage)

        self.iconView = markerView
        groundAnchor = CGPoint(x: 0.5, y: 0.5)

        pulsator.numPulse = self.numPulse
        pulsator.radius = self.radiusPulse
        pulsator.animationDuration = self.durationPulse

        pulsator.backgroundColor = pulseColor.cgColor
        pulsator.position = markerView!.layer.position
    }

    func addPinIcon(image: UIImage) {
        self.icon = nil

        markerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

        let pinImage = UIImageView()
        pinImage.translatesAutoresizingMaskIntoConstraints = false
        pinImage.contentMode = .scaleAspectFit
        pinImage.image = image

        markerView?.addSubview(pinImage)
        markerView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:
            "H:|-0-[pin]-0-|", options: [], metrics: nil, views: ["pin": pinImage]))
        markerView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat:
            "V:[pin(45)]", options: [], metrics: nil, views: ["pin": pinImage]))
        markerView?.addConstraint(NSLayoutConstraint(item: pinImage,
                                                     attribute: .bottom,
                                                     relatedBy: .equal,
                                                     toItem: markerView,
                                                     attribute: .bottom,
                                                     multiplier: 1,
                                                     constant: 0))

        titleLabel = UILabel()
        titleLabel?.numberOfLines = 2
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont(name: "Helvetica Bold", size: 14)
        titleLabel!.translatesAutoresizingMaskIntoConstraints = false
        pinImage.addSubview(titleLabel!)
        _ = titleLabel?.addConstraintCenterXToView(view: pinImage, commonParrentView: pinImage)
        _ = titleLabel?.addConstraintCenterYToView(view: pinImage, commonParrentView: pinImage)

        self.iconView = markerView
        groundAnchor = CGPoint(x: 0.5, y: 1.0)
    }

    func refeshPulsator() {
        pulsator.removeFromSuperlayer()
        pulsator.radius = self.radiusPulse
        iconView?.layer.insertSublayer(pulsator, at: 0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if !self.pulsator.isPulsating {
                self.pulsator.start()
            }
        }
    }

    func updateTitle(text: String, unit: String) {
        if text.characters.count == 0 {
            titleLabel?.attributedText = nil
        } else {
            let titleString = "\(text)\n\(unit)"
            var mutableString = NSMutableAttributedString()
            mutableString = NSMutableAttributedString(string: titleString,
                                                      attributes: [NSAttributedStringKey.font:UIFont(name: "Helvetica Bold", size: 14)!])
            mutableString.addAttribute(NSAttributedStringKey.font,
                                       value: UIFont(name: "Helvetica Bold", size: 7)!,
                                       range: NSRange(location:titleString.characters.count - unit.characters.count, length: unit.characters.count))
            titleLabel?.attributedText = mutableString
        }
    }
}

extension CGMarker {
    func showPulsator(withParentFrame frame: CGRect,
                      color: UIColor = UIColor(hex: "2292E8")) {
        let pulsatorView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.width))

        self.iconView = pulsatorView
        self.icon = nil
        self.groundAnchor = CGPoint(x: 0.5, y: 0.5)

        let pulsator = Pulsator()
        pulsator.numPulse = 4
        pulsator.animationDuration = 7
        pulsator.radius = frame.width / 2
        pulsator.backgroundColor = color.cgColor

        pulsatorView.layer.addSublayer(pulsator)
        pulsator.position = pulsatorView.layer.position
        pulsator.start()
    }

    func showBigPulsator(frame: CGRect) {
        pulsator.removeFromSuperlayer()
        pulsator.radius = (frame.width / 2) - 20
        iconView?.layer.addSublayer(pulsator)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if !self.pulsator.isPulsating {
                self.pulsator.start()
            }
        }
    }
}

extension CGFloat {
    var degreesToRadians: CGFloat { return self * .pi / 180 }
    var radiansToDegrees: CGFloat { return self * 180 / .pi }
}

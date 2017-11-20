//
//  UIViewExtension.swift
//  carpo_driver
//
//  Created by Tien Dat on 11/15/17.
//  Copyright © 2017 Tien Dat. All rights reserved.
//

import UIKit

extension UIView {
    //MARK: Layer
    func makeRoundedConner(radius: CGFloat = 10) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func copyView() -> UIView {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! UIView
    }
}

//MARK: Indicator
extension UIView {
    func showIndicator(indicatorStyle: UIActivityIndicatorViewStyle, blockColor: UIColor, alpha: CGFloat) {
        OperationQueue.main.addOperation {
            
            for currentView in self.subviews {
                if currentView.tag == 9999 {
                    return
                }
            }
            
            let viewBlock = UIView()
            viewBlock.tag = 9999
            viewBlock.backgroundColor = blockColor
            viewBlock.alpha = alpha
            
            viewBlock.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(viewBlock)
            _ = viewBlock.addConstraintFillInView(view: self, commenParrentView: self)
            
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: indicatorStyle)
            
            indicator.frame = CGRect(
                x: self.frame.width/2-25,
                y: self.frame.height/2-25,
                width: 50,
                height: 50)
            
            viewBlock.addSubview(indicator)
            
            
            indicator.startAnimating()
        }
    }
    
    func showIndicator() {
        OperationQueue.main.addOperation {
            
            for currentView in self.subviews {
                if currentView.tag == 9999 {
                    return
                }
            }
            
            let viewBlock = UIView()
            viewBlock.tag = 9999
            viewBlock.backgroundColor = UIColor.black
            viewBlock.alpha = 0.3
            
            viewBlock.layer.cornerRadius = self.layer.cornerRadius
            
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
            
            viewBlock.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(viewBlock)
            _ = viewBlock.addConstraintFillInView(view: self, commenParrentView: self)
            
            indicator.translatesAutoresizingMaskIntoConstraints = false
            viewBlock.addSubview(indicator)
            _ = indicator.addConstraintCenterXToView(view: self, commonParrentView: self)
            _ = indicator.addConstraintCenterYToView(view: self, commonParrentView: self)
            
            indicator.startAnimating()
        }
    }
    
    func showIndicator(frame: CGRect, blackStyle: Bool = false) {
        let viewBlock = UIView()
        viewBlock.tag = 9999
        viewBlock.backgroundColor = UIColor.white
        viewBlock.frame = frame
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        
        indicator.frame = CGRect(
            x: self.frame.width/2-25,
            y: self.frame.height/2-25,
            width: 50,
            height: 50)
        
        viewBlock.addSubview(indicator)
        self.addSubview(viewBlock)
        
        indicator.startAnimating()
    }
    
    func hideIndicator() {
        
        let indicatorView = self.viewWithTag(9999)
        indicatorView?.removeFromSuperview()
        
        for currentView in self.subviews {
            if currentView.tag == 9999 {
                let _view = currentView
                OperationQueue.main.addOperation {
                    _view.removeFromSuperview()
                }
            }
        }
    }
}

//MARK: Animation
extension UIView {
    func moveToFrameWithAnimation(newFrame: CGRect, delay: TimeInterval, time: TimeInterval) {
        
        UIView.animate(withDuration: time, delay: delay, options: .curveEaseOut, animations: {
            self.frame = newFrame
        }, completion:nil)
    }
    
    func fadeOut(time: TimeInterval, delay: TimeInterval = 0) {
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: time, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: {
            (finished: Bool) -> Void in
            if finished == true {
                self.isHidden = true
            }
        })
    }
    
    func fadeIn(time: TimeInterval, delay: TimeInterval = 0) {
        
        self.isUserInteractionEnabled = true
        self.alpha = 0
        self.isHidden = false
        
        UIView.animate(withDuration: time, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: {
            (finished: Bool) -> Void in
            if finished == true {
                
            }
        })
    }
}

//MARK: Add constraint
extension UIView {
    
    /// Auto canh le trai
    ///
    /// - Parameters:
    ///   - view: view nao can add
    ///   - commonParrentView: day la view cha chua view
    ///   - margin: left mac dinh = 0
    ///   - relatedBy: view con cach lien quan
    /// - Returns: return contrain
    func leadingMarginToView(view: UIView,
                             commonParrentView: UIView,
                             margin: CGFloat = 0,
                             relatedBy: NSLayoutRelation = .equal) -> NSLayoutConstraint  {
        let constraint = NSLayoutConstraint(
            item: self, attribute: .leading, relatedBy: relatedBy,
            toItem: view, attribute: .leading, multiplier: 1, constant: margin)
        
        commonParrentView.addConstraint(constraint)
        
        return constraint
    }
    
    func trailingMarginToView(view: UIView,
                              commonParrentView: UIView,
                              margin: CGFloat = 0,
                              relatedBy: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        
        let constraint = NSLayoutConstraint(
            item: self, attribute: .trailing, relatedBy: relatedBy,
            toItem: view, attribute: .trailing, multiplier: 1, constant: margin)
        
        commonParrentView.addConstraint(constraint)
        return constraint
    }
    
    func addConstraintTopToBot(view: UIView,
                               commonParrentView: UIView,
                               margin: CGFloat = 0,
                               relatedBy: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        
        let constraint = NSLayoutConstraint(
            item: self, attribute: .top, relatedBy: relatedBy,
            toItem: view, attribute: .bottom, multiplier: 1, constant: margin)
        
        commonParrentView.addConstraint(constraint)
        return constraint
    }
    
    func addConstraintBotToTop(view: UIView,
                               commonParrentView: UIView,
                               margin: CGFloat = 0,
                               relatedBy: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        
        let constraint = NSLayoutConstraint(
            item: self, attribute: .bottom, relatedBy: relatedBy,
            toItem: view, attribute: .top, multiplier: 1, constant: margin)
        
        commonParrentView.addConstraint(constraint)
        return constraint
    }
    
    func addConstraintBotMarginToView(view: UIView,
                                      commonParrentView: UIView,
                                      margin: CGFloat = 0,
                                      relatedBy: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        
        let constraint = NSLayoutConstraint(
            item: self, attribute: .bottom, relatedBy: relatedBy,
            toItem: view, attribute: .bottom, multiplier: 1, constant: margin)
        
        commonParrentView.addConstraint(constraint)
        return constraint
    }
    
    func addConstraintTopMarginToView(view: UIView,
                                      commonParrentView: UIView,
                                      margin: CGFloat = 0,
                                      relatedBy: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        
        let constraint = NSLayoutConstraint(
            item: self, attribute: .top, relatedBy: relatedBy,
            toItem: view, attribute: .top, multiplier: 1, constant: margin)
        
        commonParrentView.addConstraint(constraint)
        return constraint
    }
    
    
    func addConstraintWidth(parrentView: UIView, width: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint (item: self,
                                             attribute: NSLayoutAttribute.width,
                                             relatedBy: NSLayoutRelation.equal,
                                             toItem: nil,
                                             attribute: NSLayoutAttribute.notAnAttribute,
                                             multiplier: 1,
                                             constant: width)
        parrentView.addConstraint(constraint)
        return constraint
    }
    
    func addConstraintHeight(parrentView: UIView, height: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint (item: self,
                                             attribute: NSLayoutAttribute.height,
                                             relatedBy: NSLayoutRelation.equal,
                                             toItem: nil,
                                             attribute: NSLayoutAttribute.notAnAttribute,
                                             multiplier: 1,
                                             constant: height)
        parrentView.addConstraint(constraint)
        return constraint
    }
    
    func addConstraintLeftToRight(view: UIView,
                                  commonParrentView: UIView,
                                  margin: CGFloat = 0,
                                  relatedBy: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        
        let constraint = NSLayoutConstraint (item: self,
                                             attribute: NSLayoutAttribute.left,
                                             relatedBy: relatedBy,
                                             toItem: view,
                                             attribute: NSLayoutAttribute.right,
                                             multiplier: 1,
                                             constant: margin)
        commonParrentView.addConstraint(constraint)
        return constraint
    }
    
    func addConstraintRightToLeft(view: UIView,
                                  commonParrentView: UIView,
                                  margin: CGFloat = 0,
                                  relatedBy: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        
        let constraint = NSLayoutConstraint (item: self,
                                             attribute: NSLayoutAttribute.right,
                                             relatedBy: relatedBy,
                                             toItem: view,
                                             attribute: NSLayoutAttribute.left,
                                             multiplier: 1,
                                             constant: margin)
        commonParrentView.addConstraint(constraint)
        return constraint
    }
    
    func addConstraintCenterYToView(view: UIView,
                                    commonParrentView: UIView,
                                    margin: CGFloat = 0,
                                    relatedBy: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        
        let constraint = NSLayoutConstraint (item: self,
                                             attribute: NSLayoutAttribute.centerY,
                                             relatedBy: relatedBy,
                                             toItem: view,
                                             attribute: NSLayoutAttribute.centerY,
                                             multiplier: 1,
                                             constant: 0) //hardcode
        commonParrentView.addConstraint(constraint)
        return constraint
    }
    
    func addConstraintCenterXToView(view: UIView,
                                    commonParrentView: UIView,
                                    margin: CGFloat = 0,
                                    relatedBy: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        
        let constraint = NSLayoutConstraint (item: self,
                                             attribute: NSLayoutAttribute.centerX,
                                             relatedBy: relatedBy,
                                             toItem: view,
                                             attribute: NSLayoutAttribute.centerX,
                                             multiplier: 1,
                                             constant: margin)    //hardcode
        commonParrentView.addConstraint(constraint)
        return constraint
    }
    
    func addConstraintEqualHeightToView(view: UIView,
                                        commonParrentView: UIView,
                                        margin: CGFloat = 0,
                                        relatedBy: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        
        let constraint = NSLayoutConstraint (item: self,
                                             attribute: NSLayoutAttribute.height,
                                             relatedBy: relatedBy,
                                             toItem: view,
                                             attribute: NSLayoutAttribute.height,
                                             multiplier: 1,
                                             constant: margin)    //hardcode
        
        commonParrentView.addConstraint(constraint)
        return constraint
    }
    
    func addConstraintEqualWidthToView(view: UIView,
                                       commonParrentView: UIView,
                                       margin: CGFloat = 0,
                                       relatedBy: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        
        let constraint = NSLayoutConstraint (item: self,
                                             attribute: NSLayoutAttribute.width,
                                             relatedBy: relatedBy,
                                             toItem: view,
                                             attribute: NSLayoutAttribute.width,
                                             multiplier: 1,
                                             constant: margin)    //hardcode
        
        commonParrentView.addConstraint(constraint)
        return constraint
    }
    
    func addConstraintRationHeightToWidth(_ ration: CGFloat,
                                          margin: CGFloat = 0,
                                          relatedBy: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        
        let constraint = NSLayoutConstraint (item: self,
                                             attribute: NSLayoutAttribute.height,
                                             relatedBy: relatedBy,
                                             toItem: self,
                                             attribute: NSLayoutAttribute.width,
                                             multiplier: ration,
                                             constant: margin)
        self.addConstraint(constraint)
        return constraint
    }
    
    func addConstraintFillInView(view: UIView,
                                 commenParrentView: UIView,
                                 margins: [CGFloat]? = nil) ->
        (top: NSLayoutConstraint, bot: NSLayoutConstraint,
        lead: NSLayoutConstraint, trail: NSLayoutConstraint) {
            
            var mutableMargins = margins
            if mutableMargins == nil { mutableMargins = [0, 0, 0, 0] }
            
            let top = addConstraintTopMarginToView(view: view,
                                                   commonParrentView: commenParrentView,
                                                   margin: mutableMargins![0])
            let trail = trailingMarginToView(view: view,
                                             commonParrentView: commenParrentView,
                                             margin: mutableMargins![1])
            let bot = addConstraintBotMarginToView(view: view,
                                                   commonParrentView: commenParrentView,
                                                   margin: mutableMargins![2])
            let lead = leadingMarginToView(view: view,
                                           commonParrentView: commenParrentView,
                                           margin: mutableMargins![3])
            return (top, bot, lead, trail)
    }
}

//MARK: Get constraint from superview
extension UIView {
    func constraintTop() -> NSLayoutConstraint? {
        guard let parrentView = superview else { return nil }
        for constraint in parrentView.constraints {
            guard constraint.isConstraintOfView(view: self) else { continue }
            guard constraint.isTopConstraint() else { continue }
            return constraint
        }
        return nil
    }
    
    func constraintBot() -> NSLayoutConstraint? {
        guard let parrentView = superview else { return nil }
        for constraint in parrentView.constraints {
            guard constraint.isConstraintOfView(view: self) else { continue }
            guard constraint.isBotConstraint() else { continue }
            return constraint
        }
        return nil
    }
    
    func constraintLead() -> NSLayoutConstraint? {
        guard let parrentView = superview else { return nil }
        for constraint in parrentView.constraints {
            guard constraint.isConstraintOfView(view: self) else { continue }
            guard constraint.isLeadConstraint() else { continue }
            return constraint
        }
        return nil
    }
    
    func constraintTrail() -> NSLayoutConstraint? {
        guard let parrentView = superview else { return nil }
        for constraint in parrentView.constraints {
            guard constraint.isConstraintOfView(view: self) else { continue }
            guard constraint.isTrailConstraint() else { continue }
            return constraint
        }
        return nil
    }
    
    func constraintHorizon() -> NSLayoutConstraint? {
        guard let parrentView = superview else { return nil }
        for constraint in parrentView.constraints {
            guard constraint.isConstraintOfView(view: self) else { continue }
            guard constraint.isHorizonConstraint() else { continue }
            return constraint
        }
        return nil
    }
    
    func constraintVertical() -> NSLayoutConstraint? {
        guard let parrentView = superview else { return nil }
        for constraint in parrentView.constraints {
            guard constraint.isConstraintOfView(view: self) else { continue }
            guard constraint.isVerticalConstraint() else { continue }
            return constraint
        }
        return nil
    }
    
    func constraintRationHeightWidth() -> NSLayoutConstraint? {
        for constraint in constraints {
            guard constraint.isConstraintOfView(view: self) else { continue }
            guard constraint.isRationWidthHeight() else { continue }
            return constraint
        }
        return nil
    }
    
    func constraintCenterX() -> NSLayoutConstraint? {
        for constraint in constraints {
            guard constraint.isConstraintOfView(view: self) else { continue }
            guard constraint.isCenterX() else { continue }
            return constraint
        }
        return nil
    }
    
    func constraintCenterY() -> NSLayoutConstraint? {
        for constraint in constraints {
            guard constraint.isConstraintOfView(view: self) else { continue }
            guard constraint.isCenterY() else { continue }
            return constraint
        }
        return nil
    }
    
    func constraintWidth() -> NSLayoutConstraint? {
        for constraint in constraints {
            guard constraint.isConstraintOfView(view: self) else { continue }
            guard constraint.isWidthConstraint() else { continue }
            return constraint
        }
        return nil
    }
    
    func constraintHeight() -> NSLayoutConstraint? {
        for constraint in constraints {
            guard constraint.isConstraintOfView(view: self) else { continue }
            guard constraint.isHeightConstraint() else { continue }
            return constraint
        }
        return nil
    }
}

//Resize many layout
extension UIView {
    @IBInspectable var tineColor: UIColor {
        set {
            
        }
        get {
            return UIColor()
        }
    }
}
extension UIView {
    func addBlurEffect(index : Int, tag: Int){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.95
        blurEffectView.frame = self.bounds
        blurEffectView.tag = tag
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        
        self.insertSubview(blurEffectView, at: index)
        
    }
}
extension UIView {
    func addBorder(_ edges: UIRectEdge, colour: UIColor = UIColor.white, thickness: CGFloat = 1) -> [UIView] {
        
        var borders = [UIView]()
        
        func border() -> UIView {
            let border = UIView(frame: CGRect.zero)
            border.backgroundColor = colour
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }
        
        if edges.contains(.top) || edges.contains(.all) {
            let top = border()
            addSubview(top)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top(==thickness)]",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["top": top]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[top]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["top": top]))
            borders.append(top)
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            let left = border()
            addSubview(left)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[left(==thickness)]",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["left": left]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[left]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["left": left]))
            borders.append(left)
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            let right = border()
            addSubview(right)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(0)-|",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["right": right]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[right]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["right": right]))
            borders.append(right)
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            let bottom = border()
            addSubview(bottom)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(0)-|",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["bottom": bottom]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[bottom]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["bottom": bottom]))
            borders.append(bottom)
        }
        
        return borders
    }
}
extension UIView{
    func getLabelsInView(view: UIView) -> [UILabel] {
        var results = [UILabel]()
        for subview in view.subviews as [UIView] {
            if let labelView = subview as? UILabel {
                results += [labelView]
            } else {
                results += getLabelsInView(view: subview)
            }
        }
        return results
    }
}
extension UIView {
    func addClearGradient(){
        //        backgroundColor = UIColor.clear
        
        //        let gradient = CAGradientLayer()
        //
        //        gradient.frame = self.frame
        //        gradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor]
        //        gradient.locations = [0.0, 0.15, 0.25, 0.75, 0.85, 1.0]
        //        layer.mask = gradient
        //
        //        backgroundColor = UIColor.clear
        
        let mask = CAGradientLayer()
        mask.startPoint = CGPoint(x: 0.5, y: 1)
        mask.endPoint = CGPoint(x:0.5, y:0.5)
        let whiteColor = UIColor.white
        mask.colors = [whiteColor.withAlphaComponent(0.0).cgColor,whiteColor.withAlphaComponent(1.0),whiteColor.withAlphaComponent(1.0).cgColor]
        mask.locations = [NSNumber(value: 0.0),NSNumber(value: 0.2),NSNumber(value: 1.0)]
        mask.frame = bounds
        layer.mask = mask
        
    }
    
    func addGradientWithColor(color: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor.clear.cgColor, color.cgColor]
        
        self.layer.insertSublayer(gradient, at: 0)
        //        layer.mask = gradient
    }
    
    
    func clearBackground(){
        isOpaque = false
        backgroundColor = UIColor.clear
    }
    
    func cropAsCircleWithBorder(borderColor : UIColor, strokeWidth: CGFloat)
    {
        var radius = min(self.bounds.width, self.bounds.height)
        var drawingRect : CGRect = self.bounds
        drawingRect.size.width = radius
        drawingRect.origin.x = (self.bounds.size.width - radius) / 2
        drawingRect.size.height = radius
        drawingRect.origin.y = (self.bounds.size.height - radius) / 2
        
        radius /= 2
        
        var path = UIBezierPath(roundedRect: drawingRect.insetBy(dx: strokeWidth/2, dy: strokeWidth/2), cornerRadius: radius)
        let border = CAShapeLayer()
        border.fillColor = UIColor.clear.cgColor
        border.path = path.cgPath
        border.strokeColor = borderColor.cgColor
        border.lineWidth = strokeWidth
        self.layer.addSublayer(border)
        
        path = UIBezierPath(roundedRect: drawingRect, cornerRadius: radius)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}


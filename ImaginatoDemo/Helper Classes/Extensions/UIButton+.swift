//
//  UIButton+.swift
//  alamofireCodble
//
//  Created by Darshan Gajera on 12/07/18.
//  Copyright © 2018 Darshan Gajera. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 0.70
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = .greatestFiniteMagnitude
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        layer.add(pulse, forKey: "pulse")
    }

    
//    open override var isEnabled: Bool{
//        didSet {
//            alpha = isEnabled ? 1.0 : 0.5
//        }
//    }
    @IBInspectable
    var setScalable: Bool {
        set{
            var fontValue = self.titleLabel?.font.pointSize
            if Display.typeIsLike == .iphone5 {
                fontValue = fontValue! - 3
            } else if Display.typeIsLike == .iphone6 || Display.typeIsLike == .iphoneX {
                fontValue = fontValue! + 1
            } else if Display.typeIsLike == .iphone6plus || Display.typeIsLike == .iphoneXSMax {
                fontValue = fontValue! + 2
            }
            self.titleLabel?.font =  UIFont(name: (self.titleLabel?.font.fontName)!, size: CGFloat(fontValue!))!
        }
        get{
            return true
        }
    }
    
    @IBInspectable
    var setUnderLineText: Bool {
        set{
            let fontValue = (self.titleLabel?.font.pointSize)!
            let yourAttributes : [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontValue),
                NSAttributedString.Key.foregroundColor : self.titleLabel?.textColor ?? UIColor.white,
                NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
            let attributeString = NSMutableAttributedString(string: (self.titleLabel?.text)!,
                                                            attributes: yourAttributes)
            self.setAttributedTitle(attributeString, for: .normal)

        }
        get {
            return true
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        let intrinsicContentSize = super.intrinsicContentSize
        
        let adjustedWidth = intrinsicContentSize.width + titleEdgeInsets.left + titleEdgeInsets.right
        let adjustedHeight = intrinsicContentSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom
        return CGSize(width: adjustedWidth, height: adjustedHeight)
    }
    
    func alignImageRight() {
        if UIApplication.shared.userInterfaceLayoutDirection == .leftToRight {
            semanticContentAttribute = .forceLeftToRight
        }
        else {
            semanticContentAttribute = .forceLeftToRight
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

//For particular button
class MyButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
}

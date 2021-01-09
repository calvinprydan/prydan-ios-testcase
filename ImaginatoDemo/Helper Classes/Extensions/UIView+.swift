//
//  UIView+.swift
//  FullKit
//
//  Created by Darshan Gajera on 21/06/18.
//  Copyright © 2018 Darshan Gajera. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
// swiftlint:disable all
@IBDesignable extension UIView {
    

    @IBInspectable
    var viewCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = newValue > 0
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            
            let color = UIColor(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowOpacity = 0.4
            layer.shadowRadius = newValue
        }
    }
    
    func setGradientColor(isHorizontal: Bool) {
        var updatedFrame = self.bounds
        updatedFrame.size.height += self.frame.origin.y
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: [UIColor.hexStringToUIColor(hex: "000000"), UIColor.hexStringToUIColor(hex: "002946"), UIColor.hexStringToUIColor(hex: "003966"),UIColor.hexStringToUIColor(hex: "00427D")])
        

        
        if isHorizontal {
            
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        }
        self.backgroundColor = UIColor(patternImage: gradientLayer.createGradientImage()!)
    }
    
    func adjustConstraints(to view: UIView, attributes: (top: CGFloat, trailing: CGFloat, leading: CGFloat, bottom: CGFloat) = (0, 0, 0, 0)) -> [NSLayoutConstraint] {
        return [
            NSLayoutConstraint(
                item: self, attribute: .top, relatedBy: .equal,
                toItem: view, attribute: .top, multiplier: 1.0,
                constant: attributes.top
            ),
            NSLayoutConstraint(
                item: self, attribute: .trailing, relatedBy: .equal,
                toItem: view, attribute: .trailing, multiplier: 1.0,
                constant: attributes.trailing
            ),
            NSLayoutConstraint(
                item: self, attribute: .leading, relatedBy: .equal,
                toItem: view, attribute: .leading, multiplier: 1.0,
                constant: attributes.leading
            ),
            NSLayoutConstraint(
                item: self, attribute: .bottom, relatedBy: .equal,
                toItem: view, attribute: .bottom, multiplier: 1.0,
                constant: attributes.bottom
            )
        ]
    }
    
    func applyGlow(apply: Bool, color: UIColor) {
        self.layer.shadowColor = apply ? color.cgColor : UIColor.white.withAlphaComponent(0.0).cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = apply ? 0.4 : 0.0
        self.layer.shadowRadius = apply ? 10.0 : 0.0
        self.layer.masksToBounds = false
    }
    
    func screenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func addAndFitSubview() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self)
        let views = ["view": self]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: views))
    }
    
    func setViewBorderBottom(_ view: UIView, withWidth width: CGFloat, atDistanceFromBottom bottonY: CGFloat, andColor color: UIColor, clipToBounds: Bool) {
        view.layoutIfNeeded()
        let bottomBorder: CALayer = CALayer.init()
        /*
         UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0.0f, view.frame.size.height-bottonY, view.frame.size.width, width)];
         bottomBorder.backgroundColor = color;
         [view addSubview:bottomBorder];
         */
        bottomBorder.frame = CGRect(x: 0.0, y: view.frame.size.height-bottonY, width: view.frame.size.width, height: width)
        bottomBorder.backgroundColor = color.cgColor
        view.layer.addSublayer(bottomBorder)
        view.clipsToBounds = clipToBounds
    }
    
    func addDashedLineBorder() {
        
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        gradient.colors = UIColor.AppGredient()
        
        let path : UIBezierPath = UIBezierPath(roundedRect: gradient.frame, cornerRadius: 8)
        let shape = CAShapeLayer()
        shape.lineWidth = 2
        shape.path = path.cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        self.layer.addSublayer(gradient)
    }
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.7
        layer.masksToBounds = false
    }
    
    
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func clearConstraints() {
        for subview in self.subviews {
            subview.clearConstraints()
        }
        self.removeConstraints(self.constraints)
    }
    
    func asImage() -> UIImage {
           if #available(iOS 10.0, *) {
               let renderer = UIGraphicsImageRenderer(bounds: bounds)
               return renderer.image { rendererContext in
                   layer.render(in: rendererContext.cgContext)
               }
           } else {
               UIGraphicsBeginImageContext(self.frame.size)
               self.layer.render(in:UIGraphicsGetCurrentContext()!)
               let image = UIGraphicsGetImageFromCurrentImageContext()
               UIGraphicsEndImageContext()
               return UIImage(cgImage: image!.cgImage!)
           }
       }
}

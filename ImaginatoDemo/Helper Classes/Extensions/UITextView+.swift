//
//  UITextView+.swift
//  FullKit
//
//  Created by Darshan Gajera on 21/06/18.
//  Copyright © 2018 Darshan Gajera. All rights reserved.
//

import Foundation
import UIKit


extension UITextView {
    @objc public var substituteFontName : String {
        get {
            return self.font?.fontName ?? "";
        }
        set {
            let fontNameToTest = self.font?.fontName.lowercased() ?? "";
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }
    
    @IBInspectable
    var setScalable: Bool {
        set{
            var fontValue = self.font?.pointSize
            if Display.typeIsLike == .iphone5 {
                fontValue = fontValue!
            } else if Display.typeIsLike == .iphone6 || Display.typeIsLike == .iphoneX {
                fontValue = fontValue! + 1
            } else if Display.typeIsLike == .iphone6plus {
                fontValue = fontValue! + 2
            }
            self.font =  UIFont(name: (self.font?.fontName)!, size: CGFloat(fontValue!))!
        }
        get{
            return true
        }
    }
}

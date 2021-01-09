//
//  UIColor+.swift
//  FullKit
//
//  Created by Darshan Gajera on 21/06/18.
//  Copyright © 2018 Darshan Gajera. All rights reserved.
//

// swiftlint:disable all
import Foundation
import UIKit

extension UIColor {
    
    class func AppGredient() -> [UIColor] {
        var colors = [UIColor]()
        colors.append(UIColor(red: 249/255.0, green: 0/255.0, blue: 94/255.0, alpha: 1.0))
        colors.append(UIColor(red: 240/255.0, green: 106/255.0, blue: 68/255.0, alpha: 1.0))
        return colors
    }
    
    class func bgColor() -> UIColor {
        return self.hexStringToUIColor(hex: "282828")
    }
    
    class func pinkFontColor() -> UIColor {
        return self.hexStringToUIColor(hex: "F36194")
    }
    
    class func ButtonYellow() -> UIColor {
        return self.hexStringToUIColor(hex: "fdae5f")
    }
    
    class func ButtonPink() -> UIColor {
        return self.hexStringToUIColor(hex: "F36194")
    }
    
    class func ButtonSaffron() -> UIColor {
        return self.hexStringToUIColor(hex: "FF9F02")
    }
    
    class func AppColor() -> UIColor {
        return UIColor.hexStringToUIColor(hex: "59CEA7")
    }
    
    class func AppSecondaryColor() -> UIColor {
        return UIColor.hexStringToUIColor(hex: "59CEA7")
    }
    
    class func AppTextColor() -> UIColor {
        return UIColor.hexStringToUIColor(hex: "ffffff")
    }
    
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

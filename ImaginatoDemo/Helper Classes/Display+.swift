//
//  Display+.swift
//  FullKit
//
//  Created by Darshan Gajera on 21/06/18.
//  Copyright © 2018 Darshan Gajera. All rights reserved.
//

import Foundation
import UIKit

//swiftlint:disable all
public enum DisplayType {
    case unknown
    case iphone4
    case iphone5
    case iphone6
    case iphone6plus
    case iphoneX
    case iphoneXSMax
}

public final class Display {
    class var width:CGFloat { return UIScreen.main.bounds.size.width }
    class var height:CGFloat { return UIScreen.main.bounds.size.height }
    class var maxLength:CGFloat { return max(width, height) }
    class var minLength:CGFloat { return min(width, height) }
    class var zoomed:Bool { return UIScreen.main.nativeScale >= UIScreen.main.scale }
    class var retina:Bool { return UIScreen.main.scale >= 2.0 }
    class var phone:Bool { return UIDevice.current.userInterfaceIdiom == .phone }
    class var pad:Bool { return UIDevice.current.userInterfaceIdiom == .pad }
    class var carplay:Bool { return UIDevice.current.userInterfaceIdiom == .carPlay }
    class var tv:Bool { return UIDevice.current.userInterfaceIdiom == .tv }
    class var typeIsLike:DisplayType {
        if phone && maxLength < 568 {
            return .iphone4
        }
        else if phone && maxLength == 568 {
            return .iphone5
        }
        else if phone && maxLength == 667 {
            return .iphone6
        }
        else if phone && maxLength == 736 {
            return .iphone6plus
        }
        else if phone && maxLength == 812 {
            return .iphoneX
        }
        else if phone && maxLength == 896 {
            return .iphoneXSMax 
        }
        return .unknown
    }
}

public extension UIDevice {
    
    static var modelCode: String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var systemInfo = utsname()
        uname(&systemInfo)
        return withUnsafeMutablePointer(to: &systemInfo.machine) {
            ptr in String(cString: UnsafeRawPointer(ptr).assumingMemoryBound(to: CChar.self))
        }
    }
    
    static var model: DeviceModel {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafeMutablePointer(to: &systemInfo.machine) {
            ptr in String(cString: UnsafeRawPointer(ptr).assumingMemoryBound(to: CChar.self))
        }
        
        if modelCode == "i386" || modelCode == "x86_64" {
            if let simulatorModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"], let model = DeviceModel.Model(modelCode: simulatorModelCode) {
                return DeviceModel.simulator(model)
            } else if let simulatorModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                return DeviceModel.unrecognizedSimulator(simulatorModelCode)
            } else {
                return DeviceModel.unrecognized(modelCode)
            }
        } else if let model = DeviceModel.Model(modelCode: modelCode) {
            return DeviceModel.real(model)
        } else {
            return DeviceModel.unrecognized(modelCode)
        }
    }
    
    static var modelType: DeviceModel.Model? {
        return UIDevice.model.model
    }
    
    static func isDevice(ofType model: DeviceModel.Model) -> Bool {
        return UIDevice.modelType == model
    }
}


public enum DeviceModel {
    case simulator(Model)
    case unrecognizedSimulator(String)
    case real(Model)
    case unrecognized(String)
    
    public enum Model: String {
        case iPod1            = "iPod 1"
        case iPod2            = "iPod 2"
        case iPod3            = "iPod 3"
        case iPod4            = "iPod 4"
        case iPod5            = "iPod 5"
        case iPad2            = "iPad 2"
        case iPad3            = "iPad 3"
        case iPad4            = "iPad 4"
        case iPhone4          = "iPhone 4"
        case iPhone4S         = "iPhone 4S"
        case iPhone5          = "iPhone 5"
        case iPhone5S         = "iPhone 5S"
        case iPhone5C         = "iPhone 5C"
        case iPadMini1        = "iPad Mini 1"
        case iPadMini2        = "iPad Mini 2"
        case iPadMini3        = "iPad Mini 3"
        case iPadAir1         = "iPad Air 1"
        case iPadAir2         = "iPad Air 2"
        case iPadPro9_7       = "iPad Pro 9.7\""
        case iPadPro9_7_cell  = "iPad Pro 9.7\" cellular"
        case iPadPro10_5      = "iPad Pro 10.5\""
        case iPadPro10_5_cell = "iPad Pro 10.5\" cellular"
        case iPadPro12_9      = "iPad Pro 12.9\""
        case iPadPro12_9_cell = "iPad Pro 12.9\" cellular"
        case iPhone6          = "iPhone 6"
        case iPhone6plus      = "iPhone 6 Plus"
        case iPhone6S         = "iPhone 6S"
        case iPhone6Splus     = "iPhone 6S Plus"
        case iPhoneSE         = "iPhone SE"
        case iPhone7          = "iPhone 7"
        case iPhone7plus      = "iPhone 7 Plus"
        case iPhone8          = "iPhone 8"
        case iPhone8plus      = "iPhone 8 Plus"
        case iPhoneX          = "iPhone X"
        
        init?(modelCode: String) {
            switch modelCode {
            case "iPod1,1":    self = .iPod1
            case "iPod2,1":    self = .iPod2
            case "iPod3,1":    self = .iPod3
            case "iPod4,1":    self = .iPod4
            case "iPod5,1":    self = .iPod5
            case "iPad2,1":    self = .iPad2
            case "iPad2,2":    self = .iPad2
            case "iPad2,3":    self = .iPad2
            case "iPad2,4":    self = .iPad2
            case "iPad2,5":    self = .iPadMini1
            case "iPad2,6":    self = .iPadMini1
            case "iPad2,7":    self = .iPadMini1
            case "iPhone3,1":  self = .iPhone4
            case "iPhone3,2":  self = .iPhone4
            case "iPhone3,3":  self = .iPhone4
            case "iPhone4,1":  self = .iPhone4S
            case "iPhone5,1":  self = .iPhone5
            case "iPhone5,2":  self = .iPhone5
            case "iPhone5,3":  self = .iPhone5C
            case "iPhone5,4":  self = .iPhone5C
            case "iPad3,1":    self = .iPad3
            case "iPad3,2":    self = .iPad3
            case "iPad3,3":    self = .iPad3
            case "iPad3,4":    self = .iPad4
            case "iPad3,5":    self = .iPad4
            case "iPad3,6":    self = .iPad4
            case "iPhone6,1":  self = .iPhone5S
            case "iPhone6,2":  self = .iPhone5S
            case "iPad4,1":    self = .iPadAir1
            case "iPad4,2":    self = .iPadAir2
            case "iPad4,4":    self = .iPadMini2
            case "iPad4,5":    self = .iPadMini2
            case "iPad4,6":    self = .iPadMini2
            case "iPad4,7":    self = .iPadMini3
            case "iPad4,8":    self = .iPadMini3
            case "iPad4,9":    self = .iPadMini3
            case "iPad6,3":    self = .iPadPro9_7
            case "iPad6,11":   self = .iPadPro9_7
            case "iPad6,4":    self = .iPadPro9_7_cell
            case "iPad6,12":   self = .iPadPro9_7_cell
            case "iPad6,7":    self = .iPadPro12_9
            case "iPad6,8":    self = .iPadPro12_9_cell
            case "iPad7,3":    self = .iPadPro10_5
            case "iPad7,4":    self = .iPadPro10_5_cell
            case "iPhone7,1":  self = .iPhone6plus
            case "iPhone7,2":  self = .iPhone6
            case "iPhone8,1":  self = .iPhone6S
            case "iPhone8,2":  self = .iPhone6Splus
            case "iPhone8,4":  self = .iPhoneSE
            case "iPhone9,1":  self = .iPhone7
            case "iPhone9,2":  self = .iPhone7plus
            case "iPhone9,3":  self = .iPhone7
            case "iPhone9,4":  self = .iPhone7plus
            case "iPhone10,1": self = .iPhone8
            case "iPhone10,2": self = .iPhone8plus
            case "iPhone10,3": self = .iPhoneX
            case "iPhone10,6": self = .iPhoneX
            default:           return nil
            }
        }
    }
    
    public var name: String {
        switch self {
        case .simulator(let model):         return "Simulator[\(model.rawValue)]"
        case .unrecognizedSimulator(let s): return "UnrecognizedSimulator[\(s)]"
        case .real(let model):              return model.rawValue
        case .unrecognized(let s):          return "Unrecognized[\(s)]"
        }
    }
    
    public var model: DeviceModel.Model? {
        switch self {
        case .simulator(let model):         return model
        case .real(let model):              return model
        case .unrecognizedSimulator(_):     return nil
        case .unrecognized(_):              return nil
        }
    }
    
    func getAppUniqueId() -> String {
        let uniqueId: UUID = UIDevice.current.identifierForVendor! as UUID
        return uniqueId.uuidString
    }
}



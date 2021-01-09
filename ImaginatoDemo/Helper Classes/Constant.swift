//
//  Constant.swift
//  Whislte
//
//  Created by Darshan Gajera on 5/14/18.
//  Copyright © 2020. All rights reserved.
//
import UIKit
struct GlobalConstants {
    static let APPNAME = "Imaginato Demo"
    
}

enum Storyboard: String {
    case main    = "Main"
    func storyboard() -> UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}

enum Color: String {
    case AppColorCode  = "0091EA"
    func color() -> UIColor {
        return UIColor.hexStringToUIColor(hex: self.rawValue)
    }
}

enum Identifier: String {
    // Main Storyboard
    
    case Login = "LoginVC"
}

struct ErrorMesssages {
    static let wrong = "Something went wrong...!"
    static let EmptyEmail = "Please enter email address."
    static let ValidEmail = "Please enter valid email address."
    static let EmptyPassword = "Please enter password."
    static let ValidPassword = "Please enter valid password."
}

struct SuccessMessages {
    static let DiamondWin = "Congratulations you win diamond"
}

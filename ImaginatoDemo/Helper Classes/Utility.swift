//
//  Utility.swift
//  alamofireCodble
//
//  Created by Darshan Gajera on 07/07/18.
//  Copyright © 2018 Darshan Gajera. All rights reserved.
//

//import MJSnackBar
//import SHSnackBarView
import Foundation
import UIKit
import MBProgressHUD

enum snackBarType {
    case positive
    case negative
}

class ErrorReporting {
    static func showMessage(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        let appTopView = UIApplication.shared.topViewController()
        appTopView?.present(alert, animated: true, completion: nil)
    }
}

class LoadingView {
   static func startLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            var keyWindow : UIWindow? = nil
                  #if swift(>=5.1)
                  if #available(iOS 13, *) {
                    keyWindow = UIApplication.shared.connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .flatMap { $0.windows }
                    .first(where: { $0.isKeyWindow })
                  } else {
                      keyWindow = UIApplication.shared.keyWindow
                  }
                  #else
                  keyWindow = UIApplication.shared.keyWindow
                  #endif
            let view: UIView = (keyWindow?.subviews.first)!
            MBProgressHUD.showAdded(to: view, animated: true)
        }
    }
    
   static func stopLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            var keyWindow : UIWindow? = nil
            #if swift(>=5.1)
            if #available(iOS 13, *) {
                keyWindow = UIApplication.shared.connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .flatMap { $0.windows }
                    .first(where: { $0.isKeyWindow })
            } else {
                keyWindow = UIApplication.shared.keyWindow
            }
            #else
            keyWindow = UIApplication.shared.keyWindow
            #endif
            
            let view: UIView = (keyWindow?.subviews.first)!
            MBProgressHUD.hide(for: view, animated: true)
            
        }
    }
}


class JsonString {
    static func convert(json: Any, prettyPrinted: Bool = false) -> String {
        var options: JSONSerialization.WritingOptions = []
        if prettyPrinted {
          options = JSONSerialization.WritingOptions.prettyPrinted
        }

        do {
          let data = try JSONSerialization.data(withJSONObject: json, options: options)
          if let string = String(data: data, encoding: String.Encoding.utf8) {
            return string
          }
        } catch {
          print(error)
        }
        return ""
    }
    
    static func convertToDictionary(text: String) -> [String: Any]? {
             if let data = text.data(using: .utf8) {
                 do {
                     return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                 } catch {
                     print(error.localizedDescription)
                 }
             }
             return nil
         }
}

class SnackBar {
    static func show(strMessage: String, type: snackBarType) {
        let snackbarView = snackBar()
        var keyWindow : UIWindow? = nil
         #if swift(>=5.1)
         if #available(iOS 13, *) {
             keyWindow = UIApplication.shared.connectedScenes
                 .compactMap { $0 as? UIWindowScene }
                 .flatMap { $0.windows }
                 .first(where: { $0.isKeyWindow })
         } else {
             keyWindow = UIApplication.shared.keyWindow
         }
         #else
         keyWindow = UIApplication.shared.keyWindow
         #endif
        let v: UIView = (keyWindow?.subviews.last)!
        var color: UIColor = UIColor()
        if type == .positive {
            color = .hexStringToUIColor(hex: "#003400")
        } else {
            color = .hexStringToUIColor(hex: "#b30000")
        }
        snackbarView.showSnackBar(view: v, bgColor: color, text: strMessage, textColor: UIColor.white , interval: 2)
    }
}


extension NSDictionary {
    func dataReturn(isParseDirect: Bool?) -> Data? {
        do {
            if isParseDirect ?? false {
                
                let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
                
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                return data!
            } else {
                let jsonData = try JSONSerialization.data(withJSONObject: self.value(forKey: "data") ?? "" as Any as Any, options: .prettyPrinted)
                let reqJSONStr = String(data: jsonData, encoding: .utf8)
                let data = reqJSONStr?.data(using: .utf8)
                return data!
            }
        } catch let err {
            print("Err", err)
            return nil
        }
    }
    
    
    
}


extension String {
    
    func isVideo() -> Bool {
        var isFlag = false
        let arrExtension = [".mp4", ".3gp", ".avi", ".mkv", ".mpeg4", ".mpv", ".mov"]
        for singleExtension in arrExtension {
            if self.contains(singleExtension.uppercased()) || self.contains(singleExtension.lowercased()) {
                isFlag = true
            }
        }
        
        return isFlag
    }
    
    var isValidContact: Bool {
        let phoneNumberRegex = "^[6-9]\\d{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = phoneTest.evaluate(with: self)
        return isValidPhone
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        let passRegEx = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{7,}"
        let passTest = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        return passTest.evaluate(with: self)
    }
    
    func toDayMonth() -> String {
        let dateD: Date = Date(fromString: self, format: DateFormatType.isoDateTimeMilliSec)!
        return dateD.toString(format: DateFormatType.dateMonth)
    }
    
    func toDayMonthYearTime() -> String {
        let dateD: Date = Date(fromString: self, format: DateFormatType.isoDateTimeMilliSec)!
        return dateD.toString(format: DateFormatType.dateMonthYearTime)
    }
    
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
    
    var isNumeric: Bool {
            guard self.count > 0 else { return false }
            let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
            return Set(self).isSubset(of: nums)
    }
    
    func removeSpecialChars() -> String {
        struct Constants {
            static let validChars = Set("1234567890")
        }
        return String(self.filter { Constants.validChars.contains($0) })
    }
}



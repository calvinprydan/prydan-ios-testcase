//
//  Appdelegate+.swift
//  alamofireCodble
//
//  Created by Darshan Gajera on 13/07/18.
//  Copyright © 2018 Darshan Gajera. All rights reserved.
//

import Foundation
import UIKit

import UserNotifications
extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
    public func topViewController(_ base: UIViewController? = nil) -> UIViewController? {
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
        
        let base = base ?? keyWindow?.rootViewController
        if let top = (base as? UINavigationController)?.topViewController {
            return topViewController(top)
        }
        if let selected = (base as? UITabBarController)?.selectedViewController {
            return topViewController(selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
    
    var statusBarBackgroundColor: UIColor? {
        get {
            return (UIApplication.shared.value(forKey: "statusBar") as? UIView)?.backgroundColor
        } set {
            (UIApplication.shared.value(forKey: "statusBar") as? UIView)?.backgroundColor = newValue
            }
        }
}

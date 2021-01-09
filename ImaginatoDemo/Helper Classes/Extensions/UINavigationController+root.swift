//
//  UINavigationController+root.swift
//  HandyMan
//
//  Created by Darshan Gajera on 31/12/18.
//  Copyright © 2018 Darshan Gajera. All rights reserved.
//

import UIKit

extension UINavigationController {
   func initRootViewController(vc: UIViewController, duration: CFTimeInterval = 0.3) {
        self.viewControllers.removeAll()
        self.pushViewController(vc, animated: false)
        self.popToRootViewController(animated: false)
    }
}


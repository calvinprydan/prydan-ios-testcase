//
//  UIVIewController+.swift
//  FullKit
//
//  Created by Darshan Gajera on 21/06/18.
//  Copyright © 2018 Darshan Gajera. All rights reserved.
//

import Foundation
import UIKit
//import FAPanels
// swiftlint:disable all
typealias okButton = (_ left : UIButton) -> Void
typealias cancelButton = (_ right : UIButton) -> Void

extension UIViewController {
    
    func presentAlertWithTitle(presentStyle: UIAlertController.Style ,title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        var strTitle: String?
        if title != "" {
            strTitle = title
        }
        var strMessage: String?
        if message != "" {
            strMessage = message
        }
        let alertController = UIAlertController(title: strTitle, message: strMessage, preferredStyle: presentStyle)
        for (index, option) in options.enumerated() {
            if option == "Cancel" {
                alertController.addAction(UIAlertAction.init(title: option, style: .destructive, handler: { (action) in
                    completion(index)
                }))
            } else {
                alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                    completion(index)
                }))
            }
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func updateCurvedNavigationBarBackgroundColor(color: UIColor) {
        
        // Get layer if exist
        guard let layer = curvedLayer() else {
            return
        }
        
        layer.fillColor = color.cgColor
    }
    
    // Private functions
    
    private func curvedLayer() -> CAShapeLayer? {
        // Find our layer and return it, if not found return nil
        if let existingLayer = view.layer.sublayers?.filter({$0.name == "curved_nav_bar"}), existingLayer.count > 0 {
            if let existingLayerSubLayers = existingLayer[0].sublayers, let pathLayer = existingLayerSubLayers[0] as? CAShapeLayer {
                return pathLayer
            }
        }
        return nil
    }
    
    
//    func sideMenuOpen(flag: Bool) {
//        let appDelegate = UIApplication.shared.delegate  as! AppDelegate
//        let rootVC = appDelegate.window!.rootViewController as! FAPanelController
//        rootVC.configs.canLeftSwipe = flag
//    }
    
    


}
public extension UIResponder {

    private struct Static {
        static weak var responder: UIResponder?
    }

    static func currentFirst() -> UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        return Static.responder
    }

    @objc private func _trap() {
        Static.responder = self
    }
}

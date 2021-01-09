//
//  Gradient.+.swift
//  Recorder
//
//  Created by Darshan Gajera on 27/07/18.
//  Copyright © 2018 Darshan Gajera. All rights reserved.
//

import Foundation
import UIKit

extension CAGradientLayer {

    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 0, y: 1)
    }

    func createGradientImage() -> UIImage? {
        var image: UIImage?
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
}

extension UINavigationBar {
        func setGradientBackground(colors: [UIColor], isHorizontal: Bool) {
            var updatedFrame = bounds
            updatedFrame.size.height += self.frame.origin.y
            let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
            if isHorizontal {
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            }
            setBackgroundImage(gradientLayer.createGradientImage(), for: UIBarMetrics.default)
        }
}

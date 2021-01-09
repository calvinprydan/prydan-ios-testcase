//
//  InputBar.swift
//  Paperless housie
//
//  Created by Darshan on 05/05/20.
//  Copyright © 2020 Darshan. All rights reserved.
//

import UIKit
@objc protocol InputBarDelegate: UIToolbarDelegate {
    func inputbarDidPressRightButton(inputBar: InputBar)
    func inputbarDidChangeHeight(new_height: CGFloat)
    func inputbarDidBecomeFirstResponder(inputBar: InputBar)
}

class InputBar: UIToolbar {
    var dele: InputBarDelegate?
    var placeholder: String?
}

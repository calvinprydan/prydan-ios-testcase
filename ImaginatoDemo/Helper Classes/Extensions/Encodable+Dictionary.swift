//
//  Encodable+Dictionary.swift
//  HandyMan
//
//  Created by Darshan Gajera on 26/12/18.
//  Copyright © 2018 Darshan Gajera. All rights reserved.
//

import UIKit

extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
}


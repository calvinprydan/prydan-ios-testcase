//
//  UserInfo+CoreDataProperties.swift
//  ImaginatoDemo
//
//  Created by iMac on 08/01/21.
//
//

import Foundation
import CoreData


@objc(UserInfo)
public class UserInfo: NSManagedObject {

}

extension UserInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfo> {
        return NSFetchRequest<UserInfo>(entityName: "UserInfo")
    }

    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var created_at: Date?
    @NSManaged public var userId: String?
    @NSManaged public var userName: String?
    

}

//
//  Message.swift
//  Pixy
//
//  Created by Liza on 08/04/2025.
//

import Foundation
import CoreData

@objc(Message)
public class Message: NSManagedObject {
    @NSManaged public var text: String?
    @NSManaged public var created: Date?
}

//
//  Message+CoreDataProperties.swift
//  Pixy
//
//  Created by Liza on 11/04/2025.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var created: Date?
    @NSManaged public var text: String?
    @NSManaged public var authorEmail: String?
    @NSManaged public var receiverEmail: String?

}

extension Message : Identifiable {

}

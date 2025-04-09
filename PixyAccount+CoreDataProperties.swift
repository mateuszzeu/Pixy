//
//  PixyAccount+CoreDataProperties.swift
//  Pixy
//
//  Created by Liza on 09/04/2025.
//
//

import Foundation
import CoreData


extension PixyAccount {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PixyAccount> {
        return NSFetchRequest<PixyAccount>(entityName: "PixyAccount")
    }

    @NSManaged public var created: Date?
    @NSManaged public var email: String?
    @NSManaged public var id: UUID?
    @NSManaged public var password: String?

}

extension PixyAccount : Identifiable {

}

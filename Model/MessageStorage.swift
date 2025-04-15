//
//  MessageStorage.swift
//  Pixy
//
//  Created by Liza on 08/04/2025.
//

import CoreData
import UIKit

struct MessageStorage {
    static let shared = MessageStorage()
    
    private let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "PixyDataModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error.localizedDescription)")
            }
        }
    }

    func saveMessage(text: String) {
        let context = container.viewContext
        let message = Message(context: context)
        message.text = text
        message.created = Date()

        do {
            try context.save()
        } catch {
            assertionFailure("Failed to save message: \(error.localizedDescription)")
        }
    }

    func fetchLastMessage() -> Message? {
        let context = container.viewContext
        let request = Message.fetchRequest() as! NSFetchRequest<Message>
        
        request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
        request.fetchLimit = 1

        do {
            return try context.fetch(request).first
        } catch {
            return nil
        }
    }
}

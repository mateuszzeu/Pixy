//
//  WidgetMessageService.swift
//  Pixy
//
//  Created by Liza on 24/04/2025.
//

import CoreData
import WidgetKit

struct WidgetMessageService {
    
    static func fetchLastMessage() -> MessageEntry {
        guard let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.xzeu.pixy") else {
            return MessageEntry(date: Date(), message: "No AppGroup URL", author: "", sentAt: Date())
        }
        
        let storeURL = appGroupURL.appendingPathComponent("PixyDataModel.sqlite")
        
        if !FileManager.default.fileExists(atPath: storeURL.path) {
            return MessageEntry(date: Date(), message: "Base file missing", author: "", sentAt: Date())
        }
        
        let description = NSPersistentStoreDescription(url: storeURL)
        let container = NSPersistentContainer(name: "PixyDataModel")
        container.persistentStoreDescriptions = [description]
        
        var entry = MessageEntry(date: Date(), message: "No message", author: "", sentAt: Date())
        let semaphore = DispatchSemaphore(value: 0)
        
        container.loadPersistentStores { _, error in
            if error == nil {
                let context = container.viewContext
                let request: NSFetchRequest<Message> = Message.fetchRequest()
                
                let currentEmail = UserDefaults(suiteName: "group.com.xzeu.pixy")?.string(forKey: "loggedInEmail") ?? ""
                request.predicate = NSPredicate(format: "receiverEmail == %@", currentEmail)
                request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
                request.fetchLimit = 1
                
                if let message = try? context.fetch(request).first {
                    entry = MessageEntry(
                        date: Date(),
                        message: message.text ?? "No message",
                        author: message.authorEmail ?? "Unknown",
                        sentAt: message.created ?? Date()
                    )
                }
            }
            semaphore.signal()
        }
        
        semaphore.wait()
        return entry
    }
}

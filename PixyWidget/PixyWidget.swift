//
//  PixyWidget.swift
//  PixyWidget
//
//  Created by Liza on 11/04/2025.
//

import WidgetKit
import SwiftUI
import CoreData

struct SimpleEntry: TimelineEntry {
    let date: Date
    let message: String
    let author: String
    let sentAt: Date
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), message: "Loading...", author: "", sentAt: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let (text, author, date) = loadLatestMessage()
        completion(SimpleEntry(date: Date(), message: text, author: author, sentAt: date))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let (text, author, date) = loadLatestMessage()
        let entry = SimpleEntry(date: Date(), message: text, author: author, sentAt: date)
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

    func loadLatestMessage() -> (String, String, Date) {
        guard let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.xzeu.pixy") else {
            return ("No AppGroup URL", "", Date())
        }

        let storeURL = appGroupURL.appendingPathComponent("PixyDataModel.sqlite")
        if !FileManager.default.fileExists(atPath: storeURL.path) {
            return ("Base file missing", "", Date())
        }

        let description = NSPersistentStoreDescription(url: storeURL)
        let container = NSPersistentContainer(name: "PixyDataModel")
        container.persistentStoreDescriptions = [description]

        var result: (String, String, Date) = ("No message", "", Date())
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
                    let text = message.text ?? "No message"
                    let author = message.authorEmail ?? "Unknown"
                    let date = message.created ?? Date()
                    result = (text, author, date)
                }
            }
            semaphore.signal()
        }

        semaphore.wait()
        return result
    }
}

struct PixyWidgetEntryView: View {
    var entry: SimpleEntry

    var body: some View {
        VStack() {
            
            Spacer()
            
            Text(entry.message)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .minimumScaleFactor(0.8)
            
            Spacer()

            VStack {
                Text("From: \(entry.author)")
                    .font(.system(size: 11, weight: .regular, design: .rounded))
                    .foregroundColor(.secondary)
                    

                Text(entry.sentAt.formatted(.dateTime.weekday(.abbreviated).hour().minute()))
                    .font(.system(size: 10))
                    .foregroundColor(.gray.opacity(0.5))
            }
        }
        .padding()
        .containerBackground(.ultraThinMaterial, for: .widget)
    }
}

struct PixyWidget: Widget {
    let kind: String = "PixyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PixyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Pixy Widget")
        .description("Displays a message from the other person.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    PixyWidget()
} timeline: {
    SimpleEntry(date: .now, message: "Kot", author: "kamila@icloud.com", sentAt: .now)
}

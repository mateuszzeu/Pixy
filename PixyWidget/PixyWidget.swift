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
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), message: "Loading...")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), message: loadLatestMessage())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let entry = SimpleEntry(date: Date(), message: loadLatestMessage())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

    func loadLatestMessage() -> String {
        guard let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.xzeu.pixy") else {
            return "No AppGroup URL"
        }

        let storeURL = appGroupURL.appendingPathComponent("PixyDataModel.sqlite")
        if !FileManager.default.fileExists(atPath: storeURL.path) {
            return "Base file missing"
        }

        let description = NSPersistentStoreDescription(url: storeURL)
        let container = NSPersistentContainer(name: "PixyDataModel")
        container.persistentStoreDescriptions = [description]

        var result = "No message"
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
                    result = message.text ?? "No message"
                } else {
                    result = "No message"
                }
            } else {
                result = "No loading error"
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
        VStack {
            Spacer()
            Text(entry.message)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(4)
                .minimumScaleFactor(0.8)
                .padding()
            Spacer()
        }
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
    SimpleEntry(date: .now, message: "🧡")
}

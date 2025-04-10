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
        SimpleEntry(date: Date(), message: "Ładowanie...")
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
            return "Brak AppGroup URL"
        }

        let storeURL = appGroupURL.appendingPathComponent("PixyDataModel.sqlite")
        if !FileManager.default.fileExists(atPath: storeURL.path) {
            return "Brak pliku bazy"
        }

        let description = NSPersistentStoreDescription(url: storeURL)
        let container = NSPersistentContainer(name: "PixyDataModel")
        container.persistentStoreDescriptions = [description]

        var result = "Brak wiadomości"
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
                    result = message.text ?? "Brak treści"
                } else {
                    result = "Brak wiadomości"
                }
            } else {
                result = "Błąd ładowania bazy"
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
        ZStack {
            Color(red: 0.68, green: 0.79, blue: 0.90)
            Text(entry.message)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

struct PixyWidget: Widget {
    let kind: String = "PixyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PixyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Pixy Widget")
        .description("Wyświetla wiadomość od drugiej osoby.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    PixyWidget()
} timeline: {
    SimpleEntry(date: .now, message: "🧡")
}

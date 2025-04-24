//
//  PixyWidget.swift
//  PixyWidget
//
//  Created by Liza on 11/04/2025.
//

import WidgetKit
import SwiftUI

struct PixyWidget: Widget {
    let kind: String = "PixyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PixyWidgetProvider()) { entry in
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
    MessageEntry(date: .now, message: "Kot", author: "kamila@icloud.com", sentAt: .now)
}

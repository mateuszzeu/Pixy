//
//  PixyWidgetProvider.swift
//  Pixy
//
//  Created by Liza on 24/04/2025.
//

import WidgetKit

struct PixyWidgetProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> MessageEntry {
        MessageEntry(date: Date(), message: "Loading...", author: "", sentAt: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (MessageEntry) -> ()) {
        let entry = WidgetMessageService.fetchLastMessage()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MessageEntry>) -> ()) {
        let entry = WidgetMessageService.fetchLastMessage()
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

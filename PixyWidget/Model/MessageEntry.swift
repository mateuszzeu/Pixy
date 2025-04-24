//
//  MessageEntry.swift
//  Pixy
//
//  Created by Liza on 24/04/2025.
//

import WidgetKit

struct MessageEntry: TimelineEntry {
    let date: Date
    let message: String
    let author: String
    let sentAt: Date
}

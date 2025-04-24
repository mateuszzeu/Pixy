//
//  PixyWidgetEntryView.swift
//  Pixy
//
//  Created by Liza on 24/04/2025.
//
import WidgetKit
import SwiftUI

struct PixyWidgetEntryView: View {
    var entry: MessageEntry

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

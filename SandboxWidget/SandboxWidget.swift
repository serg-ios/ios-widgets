//
//  SandboxWidget.swift
//  SandboxWidget
//
//  Created by Sergio Rodríguez Rama on 23/4/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Entry: TimelineEntry {
    let date: Date
    let text: String
}

struct TimeProvider: TimelineProvider {

    func makePrediction(for date: Date) -> String {
        let positiveAnswers = ["It is certain", "It is decidedly so", "Without a doubt", "Yes definitely", "Most likely"]
        let uncertainAnswers = ["Reply hazy, try again", "Ask again later", "Better not tell you now", "Cannot predict now", "Concentrate and ask again"]
        let negativeAnswers = ["Don't count on it", "My reply is no", "My sources say no", "Outlook not so good", "Lol nope"]
        let allAnswers = positiveAnswers + uncertainAnswers + negativeAnswers
        let predictionNumber = Int(date.timeIntervalSince1970) % allAnswers.count
        return allAnswers[predictionNumber]
    }

    func placeholder(in context: Context) -> Entry {
        let date = Date()
        return Entry(date: date, text: makePrediction(for: date))
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        let date = Date()
        let model = Entry(date: date, text: makePrediction(for: date))
        completion(model)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries = [Entry]()
        var components = Calendar.current.dateComponents(
            [.era, .year, .month, .day, .hour, .minute, .second],
            from: Date()
        )
        components.second = 0
        let roundedDate = Calendar.current.date(from: components)!
        for second in 0..<60 {
            let entryDate = Calendar.current.date(byAdding: .second, value: second, to: roundedDate)!
            let model = Entry(date: entryDate, text: makePrediction(for: entryDate))
            entries.append(model)
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct WidgetView: View {
    let data: Entry
    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .inset(by: 5)
                .fill(Color.white.opacity(0.1))
            Text(data.text)
                .multilineTextAlignment(.center)
                .font(.headline)
                .padding()
        }
        .background(Color(white: 0.1))
        .foregroundColor(.white)
    }
}

@main
struct Config: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "com.serg-ios.WidgetsSandbox", provider: TimeProvider()) { data in
            WidgetView(data: data)
        }
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .description(Text("Magic Eight Ball"))
    }
}

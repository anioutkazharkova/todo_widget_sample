//
//  TodoAppWidget.swift
//  TodoAppWidget
//
//  Created by Anna Zharkova on 07.03.2024.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    @MainActor func placeholder(in context: Context) -> SimpleEntry {
        let items =  loadData().prefix(5).compactMap{$0}
        return SimpleEntry(date: Date(), data: items)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let items = await reloadItems().prefix(5).compactMap{$0}
        return SimpleEntry(date: Date(), data: items)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let entryDate = Date()
        let items = await reloadItems().prefix(5).compactMap{$0}
        let entry = SimpleEntry(date: entryDate, data: items)
        
        return Timeline(entries: [entry], policy: .after(.now.addingTimeInterval(20)))
    }
    
    @MainActor
    func loadData()->[TodoItem] {
        return TodoDataManager.shared.loadItems()
    }
    
    @MainActor
    func reloadItems() async -> [TodoItem] {
            let actor = SwiftDataModelActor(modelContainer: TodoDataManager.sharedModelContainer)
            return await actor.loadData()
    }
}


struct SimpleEntry: TimelineEntry {
    let date: Date
    let data: [TodoItem]
    //let configuration: ConfigurationAppIntent
    var uncompleted: Int {
        return data.filter{
            $0.isCompleted
        }.count
    }
    var total: Int {
        return data.count
    }
}


struct TodoAppWidget: Widget {
    let kind: String = "TodoAppWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            TodoAppWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    BackgroundView()
                }
        }.supportedFamilies([.systemSmall, .systemLarge])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

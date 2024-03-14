//
//  AppIntent.swift
//  TodoAppWidget
//
//  Created by Anna Zharkova on 08.03.2024.
//

import WidgetKit
import AppIntents

struct RefreshIntent: AppIntent {
    init() {}
    
    static var title: LocalizedStringResource = "Check todo action"
    static var description = IntentDescription("change checked state")
    
    
    func perform() async throws -> some IntentResult {
        await TodoDataManager.shared.loadItems()
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}

struct CheckTodoIntent: AppIntent {
    init() {}
    
    @Parameter(title: "Index")
    var index: Int
    
    init(index: Int) {
        self.index = index
    }
    
    static var title: LocalizedStringResource = "Check todo action"
    static var description = IntentDescription("change checked state")
    
    
    @MainActor
    func perform() async throws -> some IntentResult {
        await TodoDataManager.shared.updateItem(index: index)
        return .result()
    }
}

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String
}

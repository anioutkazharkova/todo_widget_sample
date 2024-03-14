//
//  TodoManager.swift
//  TodoAppOtus_6_03_24
//
//  Created by Anna Zharkova on 07.03.2024.
//

import Foundation
import Foundation
import SwiftData
import WidgetKit


protocol UpdateListener {
    func update()
    
    func reload()
}

class TodoDataManager {
    
    var listeners: [UpdateListener] = [UpdateListener]()
    
    static let shared = TodoDataManager()
    static var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TodoItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    static var sharedModelContext = ModelContext(sharedModelContainer)
    
    required init() {}
    
    @MainActor
    func addItem(name: String) {
        let newItem = TodoItem(task: name, startDate: Date())
        TodoDataManager.sharedModelContext.insert(newItem)
        listeners.forEach { listener in
            listener.reload()
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    @MainActor
    func loadItems(_ count: Int? = nil)->[TodoItem] {
        
       
        let items =  (try? TodoDataManager.sharedModelContext.fetch(FetchDescriptor<TodoItem>())) ?? []
       return items
    }
    
    @MainActor
    func deleteItem(offsets: IndexSet) {
        let items = loadItems()
        for index in offsets {
            TodoDataManager.sharedModelContext.delete(items[index])
        }
        listeners.forEach { listener in
            listener.update()
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    @MainActor
    func updateItem(index: Int) {
        let items = loadItems()
        let checked = items[index].isCompleted
        items[index].isCompleted = !checked
        listeners.forEach { listener in
            listener.update()
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    @MainActor
    func updateItem(item: TodoItem) {
        let items = loadItems()
        let checked = item.isCompleted
        listeners.forEach { listener in
            listener.update()
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
}

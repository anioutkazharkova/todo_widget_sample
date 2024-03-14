//
//  TodoAppApp.swift
//  TodoApp
//
//  Created by Anna Zharkova on 08.03.2024.
//

import SwiftUI
import SwiftData

@main
struct TodoAppApp: App {
    var sharedModelContainer: ModelContainer = TodoDataManager.sharedModelContainer

    var body: some Scene {
        WindowGroup {
            ListContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}

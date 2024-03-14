//
//  ListViewModel.swift
//  TodoApp
//
//  Created by Anna Zharkova on 14.03.2024.
//

import Foundation
import SwiftUI
import Observation

class ListViewModel : ObservableObject {
    @Published var items: [TodoItem] = [TodoItem]()
    

    @MainActor
    func loadItems(){
        Task.detached {
            let actor = SwiftDataModelActor(modelContainer: TodoDataManager.sharedModelContainer)
            await self.save(items: await actor.loadData())
        }
    }
    
    @MainActor
    func save(items: [TodoItem]) {
        self.items = items
    }
    
    
    @MainActor
    func reload() {
        self.items = TodoDataManager.shared.loadItems()
    }
    
}

//
//  ListView.swift
//  TodoAppOtus_6_03_24
//
//  Created by Anna Zharkova on 07.03.2024.
//

import SwiftUI
import SwiftData
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

/// Main list view for the app
struct ListContentView: View, UpdateListener {
    @Environment(\.scenePhase) private var phase
   //@Query var items: [TodoItem]
    @ObservedObject var model = ListViewModel()
    
    @MainActor func update() {
        model.loadItems()
    }
    
    @MainActor
    func reload() {
        model.reload()
    }
    
    init() {
        TodoDataManager.shared.listeners.append(self)
    }
    
    // MARK: - Main rendering function
    var body: some View {
        NavigationView {
            List {
                ForEach(model.items) { item in
                    Label(item.taskName , systemImage: "circle\(item.isCompleted ? ".fill" : "")")
                        .frame(maxWidth: .infinity, alignment: .leading).contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                item.isCompleted = !item.isCompleted
                                TodoDataManager.shared.updateItem(index: model.items.firstIndex(of: item) ?? 0)
                            }
                        }
                }.onDelete {index in
                    deleteItems(offsets: index)
                }
            }
            .navigationTitle("TODO")
            .navigationBarItems(trailing: Button(action: addItem, label: {
                Image(systemName: "plus")
            }))
        }.task({
            model.loadItems()
        }).onChange(of: phase) { oldValue, newValue in
            if oldValue == .background {
                model.loadItems()
            }
        }
    }

    
    /// Add a new item
    @MainActor
    private func addItem() {
        presentTextInputAlert(title: "Add Task", message: "Enter your task name") { name in
            withAnimation{ 
                TodoDataManager.shared.addItem(name: name)
            }
        }
    }

    @MainActor
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            TodoDataManager.shared.deleteItem(offsets: offsets)
        }
    }
}



// MARK: - Present UIAlertController with a text field
func presentTextInputAlert(title: String, message: String, completion: @escaping (_ text: String) -> Void) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addTextField()
    let submitAction = UIAlertAction(title: "Save", style: .default) { _ in
        if let text = alert.textFields?.first?.text, !text.isEmpty {
            completion(text)
        }
    }
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    alert.addAction(submitAction)
    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
}

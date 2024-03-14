//
//  SwiftModelDataActor.swift
//  TodoAppOtus_6_03_24
//
//  Created by Anna Zharkova on 08.03.2024.
//

import Foundation
import SwiftData


@ModelActor
actor SwiftDataModelActor {
    
    func loadData() -> [TodoItem] {
        let data = (try? modelExecutor.modelContext.fetch(FetchDescriptor<TodoItem>())) ?? [TodoItem]()
        return data
    }
}

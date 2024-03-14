//
//  TodoItem.swift
//  TodoAppOtus_6_03_24
//
//  Created by Anna Zharkova on 07.03.2024.
//

import Foundation
import UIKit
import SwiftUI
import SwiftData

/// A simple model to keep track of tasks

@Model
class TodoItem: Identifiable {
    var id: UUID
    var taskName: String
    var startDate: Date
    var isCompleted: Bool = false
    
    init(task: String, startDate: Date) {
        self.id = UUID()
        taskName = task
        self.startDate = startDate
    }
}



//
//  Item.swift
//  TodoAppOtus_6_03_24
//
//  Created by Anna Zharkova on 07.03.2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

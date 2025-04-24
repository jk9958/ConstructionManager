//
//  Item.swift
//  ConstructionManagerApp
//
//  Created by DakshinAJK on 24/04/2025.
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

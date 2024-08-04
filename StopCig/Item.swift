//
//  Item.swift
//  StopCig
//
//  Created by Hook on 24/07/2024.
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

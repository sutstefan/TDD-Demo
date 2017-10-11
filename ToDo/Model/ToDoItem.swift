//
//  ToDoItem.swift
//  ToDo
//
//  Created by Stefan Sut on 10/9/17.
//  Copyright © 2017 Stefan Sut. All rights reserved.
//

import Foundation

struct ToDoItem {
    
    let title: String
    let itemDescription: String?
    let timestamp: Double?
    let location: Location?
    
    init(title: String, itemDescription: String? = nil, timestamp: Double? = 0.0, location: Location? = nil) {
        self.title = title
        self.itemDescription = itemDescription
        self.timestamp = timestamp
        self.location = location
    }
    
}

extension ToDoItem: Equatable {
    
    static func ==(lhs: ToDoItem, rhs: ToDoItem) -> Bool {
        if lhs.location != rhs.location {
            return false
        }
        if lhs.timestamp != rhs.timestamp {
            return false
        }
        if lhs.itemDescription != rhs.itemDescription {
            return false 
        }
        if rhs.title != lhs.title {
            return false 
        }
        return true
    }
    
}


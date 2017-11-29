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
    
    init?(dict: [String: Any]) {
        guard let title = dict[titleKey] as? String else { return nil }
        
        self.title = title
        self.itemDescription = dict[itemDescriptionKey] as? String
        self.timestamp = dict[timestampKey] as? Double
        if let locationDict = dict[locationKey] as? [String: Any] {
            self.location = Location(dict: locationDict)
        } else {
            self.location = nil 
        }
    }
    
    var plistDict: [String: Any] {
        var dict = [String: Any]()
        
        dict[titleKey] = title
        if let itemDescription = itemDescription {
            dict[itemDescriptionKey] = itemDescription
        }
        if let timestamp = timestamp {
            dict[timestampKey] = timestamp
        }
        if let location = location {
            dict[locationKey] = location.plistDict
        }
        
        return dict
    }
    
    // MARK: Private
    
    private let titleKey = "titleKey"
    private let itemDescriptionKey = "itemDescriptionKey"
    private let timestampKey = "timeStampKey"
    private let locationKey = "locationKey"
    
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


//
//  Item.swift
//  ToDoPad
//
//  Created by Dominic Pepin on 2023-04-14.
//

import Foundation
import UniformTypeIdentifiers
import CoreTransferable

struct Item: Equatable, Codable {
    // MARK: Properties
    let id: String
    let title: String
    let category: String
    var isCompleted: Bool
    
    // MARK: Equatable
    
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }

    // MARK: Lifecycle 
    init(id: String = UUID().uuidString,
         title: String,
         category: String,
         isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.category = category
        self.isCompleted = isCompleted
    }
}

// MARK: Transferable
extension Item: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: Item.self, contentType: .appItem)
    }
}



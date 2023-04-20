//
//  ItemDragObject.swift
//  ToDoPad
//
//  Created by Dominic Pepin on 2023-04-15.
//

import Foundation
import os.log

/// Class that encapsulate an item so that it can be dragged and dropped.
final class ItemDragObject: NSObject, Codable {
    // MARK: Properties
    private (set) var item: Item
    
    // MARK: Lifecycle
    init(item: Item) {
        self.item = item
    }
}

// MARK: NSItemProviderWriting
extension ItemDragObject: NSItemProviderWriting {
    
    static let typeIdentifier = "com.dompepin.swiftuiexploration.item"
    
    static var writableTypeIdentifiersForItemProvider: [String] {
        [typeIdentifier]
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String,
                  forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        let encoder = JSONEncoder()
        //            encoder.outputFormatting = .prettyPrinted
        do {
            let encodedObject = try encoder.encode(self)
            completionHandler(encodedObject, nil)
        } catch {
            
            Logger.dragAndDrop.error("🔴 Error Encoding - '\(error)'")
            completionHandler(nil, error)
        }
        
        return nil
    }
}

// MARK: NSItemProviderReading
extension ItemDragObject: NSItemProviderReading {
    static var readableTypeIdentifiersForItemProvider: [String] {
        [typeIdentifier]
    }
    
    static func object(withItemProviderData data: Data,
                       typeIdentifier: String) throws -> ItemDragObject {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(ItemDragObject.self, from: data)
        } catch {
            Logger.dragAndDrop.error("🔴 Error Decoding - '\(error)'")
            throw error
        }
    }
}

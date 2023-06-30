//
//  Created by Dominic Pepin on 2023-04-15.
//

import Foundation
import os.log
import UniformTypeIdentifiers

/// Class that encapsulate an item so that it can be dragged and dropped.
final class ItemDragObject: NSObject, Codable {
    // MARK: Properties
    private (set) var item: DDItem
    
    // MARK: Lifecycle
    init(item: DDItem) {
        self.item = item
    }
}

// MARK: NSItemProviderWriting
extension ItemDragObject: NSItemProviderWriting {
    
    static let typeIdentifier = UTType.appItem.identifier
    
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
            
            Log.error("🔴 Error Encoding - '\(error)'", .dragAndDrop)
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
            Log.error("🔴 Error Decoding - '\(error)'", .dragAndDrop)
            throw error
        }
    }
}

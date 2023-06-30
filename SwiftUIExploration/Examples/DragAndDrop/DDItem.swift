//
//  Created by Dominic Pepin on 2023-04-14.
//

import Foundation
import UniformTypeIdentifiers
import CoreTransferable

struct DDItem: Equatable, Codable {
    // MARK: Properties
    let id: String
    let title: String
}

// MARK: Transferable
extension DDItem: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: DDItem.self, contentType: .appItem)
    }
}



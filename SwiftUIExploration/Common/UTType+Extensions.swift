//
//  UTType+Extensions.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2023-04-20.
//

import Foundation
import UniformTypeIdentifiers

extension UTType {
    static let appItem = UTType(exportedAs: "com.dompepin.swiftuiexploration.item") // Used with Transferable
    static let appItemDragObject = UTType(exportedAs: "com.dompepin.swiftuiexploration.itemdragobject") // Used with NSItemProvider
}

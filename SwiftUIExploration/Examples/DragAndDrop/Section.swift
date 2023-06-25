//
//  Section.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2023-06-25.
//

import Foundation
import UniformTypeIdentifiers
import CoreTransferable

// TODO: Rename to spacer
struct Section: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var items: [Item]
}

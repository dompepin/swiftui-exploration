//
//  Array+Extensions.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2023-04-20.
//

import Foundation

extension Array {
    // Returns the value at the given index if the index is in the bounds of the array.
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

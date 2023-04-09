//
//  Comparable+Extensions.swift
//  UICompass
//
//  Created by Dominic Pepin on 2023-04-03.
//

import Foundation

public extension Comparable {
    // Ensures that a value is between a lower and upper value.
    // If the value is outside the range, it is moved to the closest value.
    // Note: -1.clamp(between: 1, and: 2) is not the same as (-1).clamp(between: 1, and: 2)
    //       The first expression will clamp 1 and then make it negative.
    func clamp(between lower: Self, and upper: Self) -> Self {
        assert(lower < upper, "Descending ranges are not supported.")
        return max(lower, min(self, upper))
    }
}

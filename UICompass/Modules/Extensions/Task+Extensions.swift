//
//  Task+Extensions.swift
//  UICompass
//
//  Created by Dominic Pepin on 2023-04-06.
//

import Foundation

public extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}

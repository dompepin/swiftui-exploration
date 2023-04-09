//
//  Comparable_ExtensionsTests.swift
//  SwiftUIExplorationTests
//
//  Created by Dominic Pepin on 2023-04-06.
//

import XCTest

@testable import UICompass

final class Comparable_ExtensionsTests: XCTestCase {

    // MARK: Clamp()
    func testClamp() throws {
        XCTAssertEqual((-2).clamp(between: -1, and: 4), -1)
        XCTAssertEqual((-1).clamp(between: -1, and: 4), -1)
        XCTAssertEqual(0.clamp(between: -1, and: 4), 0)
        XCTAssertEqual(1.clamp(between: -1, and: 4), 1)
        XCTAssertEqual(2.clamp(between: -1, and: 4), 2)
        XCTAssertEqual(3.clamp(between: -1, and: 4), 3)
        XCTAssertEqual(4.clamp(between: -1, and: 4), 4)
        XCTAssertEqual(5.clamp(between: -1, and: 4), 4)
    }
}

//
//  Array_ExtensionsTests.swift
//  SwiftUIExplorationTests
//
//  Created by Dominic Pepin on 2023-04-20.
//

import XCTest

@testable import SwiftUIExploration

final class Array_ExtensionsTests: XCTestCase {

    func testSafeSubscript() {
        let fruits = ["apple", "banana", "cherry", "orange", "elderberry"]
        
        XCTAssertEqual(fruits[safe: -1], nil)
        XCTAssertEqual(fruits[safe: 0], "apple")
        XCTAssertEqual(fruits[safe: 1], "banana")
        XCTAssertEqual(fruits[safe: 2], "cherry")
        XCTAssertEqual(fruits[safe: 3], "orange")
        XCTAssertEqual(fruits[safe: 4], "elderberry")
        XCTAssertEqual(fruits[safe: 5], nil)
        XCTAssertEqual(fruits[safe: Int.max], nil)
    }
}

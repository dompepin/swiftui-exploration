//
//  ButtonStateColorTests.swift
//  SwiftUIExplorationTests
//
//  Created by Dominic Pepin on 2022-02-26.
//

import XCTest
import UICompass

@testable import UICompass

class ButtonStateColorTests: XCTestCase {

    // MARK: color()
    
    func test_color_AllPermutations() throws {
        let buttonStateColor = ButtonStateColor(normal: .red, pressed: .green, disabled: .gray)
        
        XCTAssertEqual(buttonStateColor.color(isEnabled: true, isPressed: true), .green)
        XCTAssertEqual(buttonStateColor.color(isEnabled: true, isPressed: false), .red)
        XCTAssertEqual(buttonStateColor.color(isEnabled: false, isPressed: true), .gray)
        XCTAssertEqual(buttonStateColor.color(isEnabled: false, isPressed: false), .gray)
    }
}

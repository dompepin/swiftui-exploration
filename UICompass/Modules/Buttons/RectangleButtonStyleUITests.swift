//
//  RectangleButtonStyleUITests.swift
//  UICompassTests
//
//  Created by Dominic Pepin on 2022-03-12.
//

import XCTest
import SnapshotTesting
import SwiftUI

@testable import UICompass

class RectangleButtonStyleUITests: XCTestCase {
    
    override func setUp() {
        // isRecording = true
    }
    
    override class func tearDown() {
        isRecording = false
    }
    
    func test_RectangleStyle() throws {
        let view: some View = rectangleButtonStylesExamples()
        let vc = UIHostingController(rootView: view)
        uiCompassAssertSnapshot(matching: vc, as: .image)
    }
}

private extension RectangleButtonStyleUITests {
    func rectangleButtonStylesExamples() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Button {} label: {
                Text("Test 1 - Fill - Enabled")
            }
            .buttonStyle(ButtonStyle.test1)
            Button {} label: {
                Text("Test 1 - Fill - Disabled")
            }
            .buttonStyle(ButtonStyle.test1)
            .disabled(true)
            Button {} label: {
                Text("Test 2 - Outline - Enabled")
            }
            .buttonStyle(ButtonStyle.test2)
            
            Button {} label: {
                Text("Test 2 - outline - Disabled")
            }
            .buttonStyle(ButtonStyle.test2)
            .disabled(true)
        }
        .padding()
        .background(Color.white)
    }
}

private enum ButtonStyle {
    static let test1 = RectangleButtonStyle(config: RectangleButtonConfig(foreground: .init(normal: .white, pressed: .green, disabled: .orange),
                                                                          background: .init(normal: .blue, pressed: .red, disabled: .gray),
                                                                          border: .init(normal: .red, pressed: .blue, disabled: .gray),
                                                                          borderWidth: 0,
                                                                          padding: EdgeInsets(top: 40, leading: 30, bottom: 20, trailing: 10),
                                                                          cornerRadius: 8))
    
    static let test2 = RectangleButtonStyle(config: RectangleButtonConfig(foreground: .init(normal: .blue, pressed: .green, disabled: .black),
                                                                          background: .init(normal: .white, pressed: .white, disabled: .white),
                                                                          border: .init(normal: .purple, pressed: .red, disabled: .gray),
                                                                          borderWidth: 2,
                                                                          padding: EdgeInsets(top: 10, leading: 20, bottom: 30, trailing: 40),
                                                                          cornerRadius: 4))
}



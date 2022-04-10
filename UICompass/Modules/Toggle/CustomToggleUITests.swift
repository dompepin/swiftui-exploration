//
//  CustomToggleUITests.swift
//  UICompassTests
//
//  Created by Dominic Pepin on 2022-04-10.
//

import XCTest
import SwiftUI

@testable import UICompass
import SnapshotTesting

// TODO: Figure out why the knob is not showing on the UI Tests
class CustomToggleUITests: XCTestCase {
    override func setUp() {
//        isRecording = true
    }
    
    override class func tearDown() {
        isRecording = false
    }
    
    func test_CustomToggle() {
        let view: some View = customToggleUITestsExampleView()
        let vc = UIHostingController(rootView: view)
        uiCompassAssertSnapshot(matching: vc, as: .image)
    }
}

private extension CustomToggleUITests {
    @ViewBuilder
    func customToggleUITestsExampleView() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Group {
                CustomToggle(isOn: .constant(true), config: .testToggle1)
                    .frame(width: 100, height: 44)
                CustomToggle(isOn: .constant(false), config: .testToggle1)
                    .frame(width: 100, height: 44)
            }
            
        }
        .padding()
        .background(Color.white)
    }
}

fileprivate extension CustomToggle.Configuration {
    static let testToggle1: CustomToggle.Configuration = .init(onKnob: { AnyView(Circle().fill(Color.orange)) },
                                                               offKnob: { AnyView(Circle().fill(Color.purple)) },
                                                               onBackground: { AnyView(Capsule().fill(Color.gray)) },
                                                               offBackground: { AnyView(Capsule().fill(Color.red)) },
                                                               borderWidth: 4)
}

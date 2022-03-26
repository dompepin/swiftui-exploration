//
//  View+ConerRadiusUITests.swift
//  UICompassTests
//
//  Created by Dominic Pepin on 2022-03-12.
//

import XCTest
import SnapshotTesting
import SwiftUI

@testable import UICompass

class View_ConerRadiusUITests: XCTestCase {
    override func setUp() {
        // isRecording = true
    }
    
    override class func tearDown() {
        isRecording = false
    }
    
    func test_CornerRadius() {
        let view: some View = cornerRadiusTestExamples()
        let vc = UIHostingController(rootView: view)
        uiCompassAssertSnapshot(matching: vc, as: .image)
    }
}

private extension View_ConerRadiusUITests {
    @ViewBuilder
    func cornerRadiusTestExamples() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // 1 Corner
            Group {
                rectangle(.red)
                    .cornerRadius(8, corners: [.topLeft])
                rectangle(.green)
                    .cornerRadius(8, corners: [.topRight] )
                rectangle(.blue)
                    .cornerRadius(8, corners: [.bottomLeft] )
                rectangle(.yellow)
                    .cornerRadius(8, corners: [.bottomRight] )
            }
            // 2 Corners
            Group {
                rectangle(.red)
                    .cornerRadius(8, corners: [.topLeft, .topRight] )
                rectangle(.green)
                    .cornerRadius(8, corners: [.bottomLeft, .bottomRight] )
                rectangle(.blue)
                    .cornerRadius(8, corners: [.topLeft, .bottomLeft] )
                rectangle(.yellow)
                    .cornerRadius(8, corners: [.topRight, .bottomRight] )
                rectangle(.purple)
                    .cornerRadius(8, corners: [.topLeft, .bottomRight] )
                rectangle(.orange)
                    .cornerRadius(8, corners: [.topRight, .bottomLeft] )
            }
            // 3 Corners
            Group {
                rectangle(.red)
                    .cornerRadius(8, corners: [.topLeft, .topRight, .bottomLeft] )
                rectangle(.green)
                    .cornerRadius(8, corners: [.topLeft, .topRight, .bottomRight] )
                rectangle(.blue)
                    .cornerRadius(8, corners: [.topLeft, .bottomLeft, .bottomRight] )
                rectangle(.yellow)
                    .cornerRadius(8, corners: [.topRight, .bottomLeft, .bottomRight] )
            }
            // All Corners
            Group {
                rectangle(.red)
                    .cornerRadius(8, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight] )
            }
        }
        .padding()
        .background(Color.white)
    }
    
    // MARK: Private
    
    private func rectangle(_ color: Color) -> some View {
        Rectangle()
            .foregroundColor(color)
            .frame(width: 60, height: 20)
    }
}

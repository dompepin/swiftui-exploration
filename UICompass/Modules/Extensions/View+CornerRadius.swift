//
//  RoundedRectangle.swift
//  UICompass
//
//  Created by Dominic Pepin on 2022-02-21.
//

import Foundation
import SwiftUI

public extension View {
    
    /// Clips the view specified corner, with the specified corner radius.
    /// - Parameters:
    ///   - cornerRadius: Corner radius
    ///   - corners: Corners to clip
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(CustomRoundedRectangle(cornerRadius: radius, corners: corners))
    }
}


// MARK: Private

///Rounded rectangle where you can define which corner are rounded
private struct CustomRoundedRectangle: Shape {

    // MARK: Properties
    
    var cornerRadius: CGFloat
    var corners: UIRectCorner

    // MARK: Lifecycle
    
    /// Initialize a rectangle with specific rounded corners
    /// - Parameters:
    ///   - cornerRadius: Corner radius
    ///   - corners: Corners to round
    init(cornerRadius: CGFloat, corners: UIRectCorner) {
        self.cornerRadius = cornerRadius
        self.corners = corners
    }
    
    // MARK: Shape
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        return Path(path.cgPath)
    }
}


//
//  ButtonStateColor.swift
//  UICompass
//
//  Created by Dominic Pepin on 2022-02-26.
//

import Foundation
import SwiftUI

/// Defines the color of a button through it's different states.
public struct ButtonStateColor {
    let normal: Color
    let pressed: Color
    let disabled: Color
    
    /// Returns the color of the button component based on the state
    ///
    /// - Parameters:
    ///   - isEnabled: Indicates if the button is enabled or not
    ///   - isPressed: Indicates if the button is pressed or not
    func color(isEnabled: Bool, isPressed: Bool) -> Color {
        if !isEnabled {
            return disabled
        }
        
        return isPressed ? pressed : normal
    }
    
    public init(normal: Color, pressed: Color, disabled: Color) {
        self.normal = normal
        self.pressed = pressed
        self.disabled = disabled
    }
}

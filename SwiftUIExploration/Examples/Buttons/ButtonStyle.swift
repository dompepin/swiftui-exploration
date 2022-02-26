//
//  PrimaryButtonStyle.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2022-02-26.
//

import SwiftUI
import UIKit
import UICompass

enum ButtonStyle {
    static let primary = RectangleButtonStyle(config: .primary)
    static let secondary = RectangleButtonStyle(config: .secondary)
}


extension RectangleButtonConfig {
    static let primary = RectangleButtonConfig(foreground: .init(normal: .textLight, pressed: .textLight, disabled: .textLight),
                                               background: .init(normal: .buttonPrimary, pressed: .buttonPrimary.lighter(), disabled: .disabled),
                                               border: .init(normal: .buttonPrimary, pressed: .buttonPrimary.lighter(), disabled: .disabled),
                                               borderWidth: 0,
                                               padding: EdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 8),
                                               cornerRadius: 8)
    
    static let secondary = RectangleButtonConfig(foreground: .init(normal: .buttonSecondary, pressed: .textLight, disabled: .disabled),
                                                 background: .init(normal: .clear, pressed: .buttonSecondary.lighter(), disabled: .clear),
                                                 border: .init(normal: .buttonSecondary, pressed: .buttonSecondary.lighter(), disabled: .disabled),
                                                 borderWidth: 2,
                                                 padding: EdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 8),
                                                 cornerRadius: 8)
}

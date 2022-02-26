//
//  RectangleButton.swift
//  UICompass
//
//  Created by Dominic Pepin on 2022-02-24.
//

import SwiftUI

/// Defines a rectangle button style
public struct RectangleButtonConfig {
    let foregroundColor: ButtonStateColor
    let backgroundColor: ButtonStateColor
    let borderColor: ButtonStateColor
    let borderWidth: CGFloat
    let padding: EdgeInsets
    let cornerRadius: CGFloat
    
    public init(foreground: ButtonStateColor,
                background: ButtonStateColor,
                border: ButtonStateColor,
                borderWidth: CGFloat,
                padding: EdgeInsets,
                cornerRadius: CGFloat) {
        self.foregroundColor = foreground
        self.backgroundColor = background
        self.borderColor = border
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.padding = padding
    }
}

// MARK: RectangleButtonStyle

public struct RectangleButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    private let config: RectangleButtonConfig
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(config.foregroundColor.color(isEnabled: isEnabled, isPressed: configuration.isPressed))
            .padding(config.padding)
            .background(
                RoundedRectangle(cornerRadius: config.cornerRadius, style: .continuous)
                    .strokeBorder(config.borderColor.color(isEnabled: isEnabled, isPressed: configuration.isPressed), lineWidth: config.borderWidth)
            )
            .background(
                RoundedRectangle(cornerRadius: config.cornerRadius, style: .continuous)
                    .fill(config.backgroundColor.color(isEnabled: isEnabled, isPressed: configuration.isPressed))
            )
    }
    
    public init(config: RectangleButtonConfig) {
        self.config = config
    }
}


// MARK: Preview

struct RectangleButtonStyle_Previews: PreviewProvider {
    static let exampleFilledButton = RectangleButtonConfig(foreground: .init(normal: .white, pressed: .white, disabled: .white),
                                                           background: .init(normal: .blue, pressed: .green, disabled: .gray),
                                                           border: .init(normal: .blue, pressed: .green, disabled: .gray),
                                                           borderWidth: 0,
                                                           padding: EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12),
                                                           cornerRadius: 8)
    
    static let exampleBorderedButton = RectangleButtonConfig(foreground: .init(normal: .blue, pressed: .white, disabled: .white),
                                                           background: .init(normal: .white, pressed: .green, disabled: .gray),
                                                           border: .init(normal: .blue, pressed: .green, disabled: .gray),
                                                           borderWidth: 2,
                                                           padding: EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12),
                                                           cornerRadius: 8)
    
    static var previews: some View {
        VStack {
            Button {
            } label: {
                Text("Filled Example")
            }
            .buttonStyle(RectangleButtonStyle(config: Self.exampleFilledButton))
            
            Button {
            } label: {
                Text("Outline Example")
            }
            .buttonStyle(RectangleButtonStyle(config: Self.exampleBorderedButton))
            Button {
            } label: {
                Text("Disabled Example")
            }
            .buttonStyle(RectangleButtonStyle(config: Self.exampleFilledButton))
            .disabled(true)
        }
    }
}

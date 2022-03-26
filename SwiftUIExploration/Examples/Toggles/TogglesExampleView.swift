//
//  TogglesExampleView.swift.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2022-03-19.
//

import SwiftUI
import UICompass

struct TogglesExampleView: View {
    @State private var isToggleOn: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Group {
                    EyebrowText("Apple Examples")
                    Toggle("Apple Default Toggle", isOn: $isToggleOn)
                    Toggle("Apple Default Toggle Variation", isOn: $isToggleOn)
                        .toggleStyle(SwitchToggleStyle(tint: .red))
                    Toggle("Apple Button Toggle", isOn: $isToggleOn)
                        .toggleStyle(ButtonToggleStyle())
                }
                Group {
                    EyebrowText("Custom Examples")
                        .padding(.top, 16)
                    HStack {
                        Text("Day/Night Toggle")
                        Spacer()
                        CustomToggle(isOn: $isToggleOn, config: .dayNight)
                            .frame(width: 100, height: 44)
                    }
                    HStack {
                        Text("Rounded Rectangle Toggle")
                        Spacer()
                        CustomToggle(isOn: $isToggleOn, config: .systemRoundedRectangle)
                            .frame(width: 60, height: 30)
                    }
                    HStack {
                        Text("Slider Toggle")
                        Spacer()
                        CustomToggle(isOn: $isToggleOn, config: .skinnySlider)
                            .frame(width: 100, height: 30)
                    }
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Toggles")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TogglesExampleView_Previews: PreviewProvider {
    static var previews: some View {
        TogglesExampleView()
    }
}

extension CustomToggle.Configuration {
    static let dayNight = CustomToggle.Configuration(
        onKnob: {
            AnyView(DayNightToggleKnob(.day))
        },
        offKnob: {
            AnyView(DayNightToggleKnob(.night))
        },
        onBackground: {
            AnyView(DayNightToggleBackground(.day))
        },
        offBackground: {
            AnyView(DayNightToggleBackground(.night))
        },
        borderWidth: 2)
    
    static let skinnySlider = CustomToggle.Configuration(
        onKnob: {
            AnyView(
                Circle()
                    .foregroundColor(.white)
                    .overlay(
                        Circle()
                            .strokeBorder(.green, style: .init(lineWidth: 4))
                            .overlay(
                                Circle()
                                    .strokeBorder(.white, style: .init(lineWidth: 1))
                            )
                    )
            )
        },
        offKnob: {
            AnyView(
                Circle()
                    .foregroundColor(.white)
                    .overlay(
                        Circle()
                            .strokeBorder(Color(UIColor.systemGray4), style: .init(lineWidth: 4))
                            .overlay(
                                Circle()
                                    .strokeBorder(.white, style: .init(lineWidth: 1))
                            )
                    )
            )
        },
        onBackground: {
            AnyView(VStack {
                Spacer()
                Capsule().foregroundColor(Color(UIColor.systemGray4))
                    .frame(height: 10)
                    .padding([.leading, .trailing], 8)
                Spacer()
            })
        },
        offBackground: nil,
        borderWidth: 0)
    
}

//
//  BottomSheet.swift
//  UICompas
//
//  Created by Dominic Pepin on 2022-02-14.
//

import SwiftUI

/// TODO: Add background dismissable shadow. that is optional.

/// Presents a custom view from the bottom of the screen.
public struct BottomSheet<Content>: View where Content: View {
    
    // MARK: Constants
    
    private let dismissibleViewColor: Color = .black
    private let dismissibleViewOpacity: CGFloat = 0.25
    
    // MARK: Properties
    
    @Binding private var isPresented: Bool
    @State private var sheetSize: CGSize = .zero
    private let content: () -> Content
    
    // MARK: Body
    
    public var body: some View {
        GeometryReader { geometry in
            VStack{
                Spacer()
                self.content()
                    .frame(width: geometry.size.width)
                    .getSize($sheetSize)
                    .offset(y: isPresented ? 0 : sheetSize.height + geometry.safeAreaInsets.bottom)
            }
        }
        
        .background(
            dismissibleViewColor
                .opacity(isPresented ? dismissibleViewOpacity : 0.0)
                .onTapGesture {
                    isPresented.toggle()
                }
                .ignoresSafeArea()
        )
        .animation(Animation.easeInOut(duration: 0.3),
                   value: isPresented)
    }
    
    // MARK: Lifecycle
    
    /// Presents a custom view from the bottom of the screen.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the bottom sheet that you create in the `content` closure.
    ///   - content: A closure returning the `View` to present.
    public init(isPresented: Binding<Bool>, content: @escaping () -> Content) {
        self._isPresented = isPresented
        self.content = content
    }
}

// MARK: Extension

public extension View {
    
    /// Add a bottom sheet to your view
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the bottom sheet that you create in the `content` closure.
    ///   - content: A closure returning the `View` to present.
    func customSheet<Content: View>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View {
        return ZStack {
            self
            BottomSheet(isPresented: isPresented, content: content)
        }
    }
}


// MARK: Preview

struct CustomSheet_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Button {} label: { Text("Tap Me") }
        }
        .customSheet(isPresented: .constant(true)) {
            VStack {
                HStack {
                    Spacer()
                    Button {} label: {
                        Image(systemName: "xmark")
                            .padding()
                    }
                }
                HStack{
                    Spacer()
                    Text("You Tapped Me")
                    Spacer()
                }
            }
            .frame(height: 100)
            .background(Color.green)
            
        }
    }
}

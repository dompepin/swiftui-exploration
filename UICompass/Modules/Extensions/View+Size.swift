//
//  View+SizeExtension.swift
//  UICompass
//
//  Created by Dominic Pepin on 2022-02-16.
//

import Foundation
import SwiftUI

public extension View {

    /// Gets the size of the view
    func getSize(_ size: Binding<CGSize>) -> some View {
        self.background {
            GeometryReader { geometry in
                Color
                    .clear
                    .assign(size: geometry.size, to: size )
            }}
    }
    
    // MARK: Private
    
    /// Assigns the given size to the given binding
    private func assign(size: CGSize, to boundSize: Binding<CGSize>) -> some View {
        DispatchQueue.main.async {
            boundSize.wrappedValue = size
        }
        return self
    }
}

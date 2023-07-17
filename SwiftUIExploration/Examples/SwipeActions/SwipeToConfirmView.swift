//
//  SwipeToConfirmView.swift
//  UICompass
//
//  Created by Dominic Pepin on 2023-07-05.
//

import SwiftUI
import UICompass

// MARK: View
struct SwipeToConfirmView: View {
    @Binding var viewSize: CGSize
    @Binding var isConfirmed: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: isConfirmed ? "x.circle.fill" : "checkmark.circle.fill")
                .font(.title3)
            Text("\(isConfirmed ? "Cancel" : "Confirm")") // Note: this will cause the view to have different width.
                .font(.caption)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 12)
        .getSize($viewSize)
    }
}

// MARK: Extension
public extension View {
    /// Adds swipe to delete to the current view
    func swipeToConfirm(viewId: String = UUID().uuidString,
                        _ isConfirmed: Binding<Bool>,
                        onConfirm: @escaping () -> Void) -> some View {
        
        return self.modifier(SwipeToActionViewModifier(viewId: viewId,
                                                       actionView: { viewSize in
            SwipeToConfirmView(viewSize: viewSize, isConfirmed: isConfirmed)
        },
                                                       actionConfig: .init(backgroundColor: .green,
                                                                           completionAnimation: .collapse),
                                                       action: onConfirm))
        
        
    }
}

// MARK: Preview
struct SwipeToConfirmView_Previews: PreviewProvider {
    @State static var viewSize: CGSize = .zero
    
    static var previews: some View {
        VStack(spacing: 16) {
            SwipeToConfirmView(viewSize: $viewSize, isConfirmed: .constant(true))
                .background(Color.green)
            SwipeToConfirmView(viewSize: $viewSize, isConfirmed: .constant(false))
                .background(Color.green)
        }
    }
}

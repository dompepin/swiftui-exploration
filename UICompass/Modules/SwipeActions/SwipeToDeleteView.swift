//
//  SwipeToDeleteView.swift
//  UICompass
//
//  Created by Dominic Pepin on 2023-07-05.
//

import SwiftUI

// MARK: View
struct SwipeToDeleteView: View {
    @Binding var viewSize: CGSize
    
    var body: some View {
        Image(systemName: "trash")
            .font(.title2)
            .foregroundColor(.white)
            .padding(.horizontal, 30)
            .getSize($viewSize)
    }
}

// MARK: Extension
public extension View {
    /// Adds swipe to delete to the current view
    func swipeToDelete(viewId: String = UUID().uuidString,
                       onDelete: @escaping () -> Void) -> some View {
        return self.modifier(SwipeToActionViewModifier(viewId: viewId,
                                                       actionView: SwipeToDeleteView.init,
                                                       actionConfig: .init(backgroundColor: .red,
                                                                           completionAnimation: .completeSwipe),
                                                       action: onDelete))
    }
}

// MARK: Preview
struct SwipeToDeleteView_Previews: PreviewProvider {
    @State static var viewSize: CGSize = .zero
    
    static var previews: some View {
        SwipeToDeleteView(viewSize: $viewSize)
            .background(Color.red)
    }
}

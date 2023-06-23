//
//  SwipeToDeleteViewModifier.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2023-06-21.
//

import SwiftUI

extension View {
    func swipeToDelete(viewId: String = UUID().uuidString, onDelete: @escaping () -> Void) -> some View {
        return self.modifier(SwipeToDeleteViewModifier(viewId: viewId, onDelete: onDelete))
    }
}

struct SwipeToDeleteViewModifier: ViewModifier {
    // MARK: Static
    private let backgroundColor: Color = .red
    private let viewId: String
    private let swipeToDeleteThresholdRatio: CGFloat = 0.5
        
    // MARK: Properties
    @State private var contentOffset: CGFloat = 0 // The parent view content offset as the user is dragging it
    @State private var lastOffset: CGFloat = 0 // Used when starting to drag from a visible state
    @State private var contentSize: CGSize = .zero // The size of the row being swiped
    @State private var deletionViewSize: CGSize = .zero // The size of the deletion view tap area
    @State private var isDeletionViewShown = false // Indicates if the deletion view is shown
    @State private var isDeleting: Bool = false // Indicates if the delete animation is running
    
    private var onDelete: () -> Void
    
    // Stores the id of the view that is currently swiped.
    // This is used to ensure that only one view is shown at any time.
    // Each row will listen to change and if it's not their id being stored, they will colapse
    @AppStorage("ViewSync.SwipeToDeleteViewId") var swipeToDeleteViewId: String = ""
        
    // MARK: Body
    func body(content: Content) -> some View {
        ZStack() {
            deletionView()
            contentView(content)
        }
        .onChange(of: swipeToDeleteViewId) { swipeToDeleteViewId in
            // reset the view if another view is swiped
            if swipeToDeleteViewId != viewId {
                resetView()
            }
        }
    }
    
    // MARK: Lifecycle
    
    init(viewId: String = UUID().uuidString, onDelete: @escaping () -> Void) {
        self.viewId = viewId
        self.onDelete = onDelete
    }
    
    // MARK: Private Views
    private func contentView(_ content: Content) -> some View {
        content
            .getSize($contentSize)
            .offset(x: contentOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if isDeleting {
                            return
                        }
                        swipeToDeleteViewId = viewId
                        contentOffset = calculateContentOffset(translationWidth: value.translation.width, dragStartingOffset: lastOffset)
                        isDeletionViewShown = contentOffset < -deletionViewSize.width
                        if contentOffset < -swipeToDeleteThreshold() {
                            deleteItem()
                        }
                    }
                    .onEnded { value in
                        if isDeleting {
                            return
                        }
                        if isDeletionViewShown {
                            withAnimation {
                                // Show the deletion view properly
                                contentOffset = -deletionViewSize.width
                            }
                        } else {
                            withAnimation {
                                // Hide the deletion view
                                contentOffset = 0
                            }
                        }
                        lastOffset = contentOffset
                    }
            )
    }
    
    private func deletionView() -> some View {
        ZStack {
            deletionViewBackground()
                .offset(x: contentSize.width + contentOffset)
            deletionViewForeground()
                .offset(x: max(contentSize.width + contentOffset, contentSize.width - deletionViewSize.width))
        }
        .frame(height: contentSize.height)
    }
    
    private func deletionViewForeground() -> some View {
        HStack {
            Image(systemName: "trash")
                .font(.title2)
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .getSize($deletionViewSize)
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            deleteItem()
        }
    }
    
    private func deletionViewBackground() -> some View {
        backgroundColor
    }

    // MARK: Private methods
    private func calculateContentOffset(translationWidth: CGFloat, dragStartingOffset: CGFloat) -> CGFloat {
        // If we swipe right, stop at the edge of the view
        if translationWidth + dragStartingOffset > 0 {
            return 0
        }
        // No limit to swiping left
        return translationWidth + dragStartingOffset
    }
    
    private func swipeToDeleteThreshold() -> CGFloat {
        let value = contentSize.width == 0 ? 240 : contentSize.width * swipeToDeleteThresholdRatio
        return value
    }
    
    private func deleteItem() {
        isDeleting = true
        withAnimation {
            contentOffset = -UIScreen.main.bounds.width
            onDelete()
        }
    }
    
    private func resetView() {
        withAnimation {
            contentOffset = 0
            lastOffset = 0
        }
    }
}

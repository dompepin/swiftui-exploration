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
    private let deletionViewWidth: CGFloat = 50
    private let minimumSwipeThreshold: CGFloat = 50
    private let swipeToDeleteThresholdRatio: CGFloat = 0.5
        
    // MARK: Properties
    @State private var contentOffset: CGFloat = 0
    @State private var contentSize: CGSize = .zero
    @State private var isDeletionViewShown = false
    @State private var lastOffset: CGFloat = 0 // Used when starting to drag from a visible state
    @State private var isDeleting: Bool = false
    
    private var onDelete: () -> Void
    
    // Used to ensure that only one view is shown at any time
    @AppStorage("ViewSync.SwipeToDeleteViewId") var swipeToDeleteViewId: String = ""
    
    
    // MARK: Body
    
    func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
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
                        print("View: '\(viewId)' -> lastOffset: \(lastOffset)")
                        swipeToDeleteViewId = viewId
                        contentOffset = calculateContentOffset(translationWidth: value.translation.width, dragStartingOffset: lastOffset)
                        isDeletionViewShown = contentOffset < -minimumSwipeThreshold
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
                                contentOffset = -deletionViewWidth
                            }
                        } else {
                            withAnimation {
                                contentOffset = 0
                            }
                        }
                        lastOffset = contentOffset
                    }
            )
    }
    
    private func deletionView() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image(systemName: "trash")
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: deletionViewWidth)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        deleteItem()
                    }
            }
            Spacer()
        }
        .background {
            Color.red
        }
        .frame(height: contentSize.height)
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
        print("Content Width \(value)")
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
        print("Resetting View: '\(viewId)'")
        withAnimation {
            contentOffset = 0
            lastOffset = 0
        }
    }
}

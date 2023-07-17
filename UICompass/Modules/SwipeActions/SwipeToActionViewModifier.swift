//
//  SwipeToActionViewModifier.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2023-06-21.
//

import SwiftUI


// MARK: Configuration
public struct SwipeToActionConfiguration {
    public enum CompletionAnimation {
        case collapse // When the user taps on the action, the view will collapse to its initial state
        case completeSwipe // When the user taps on the action, the view will complete the swipe action
    }
    
    private (set) var backgroundColor: Color
    private (set) var completionAnimation: CompletionAnimation
    
    public init(backgroundColor: Color, completionAnimation: CompletionAnimation) {
        self.backgroundColor = backgroundColor
        self.completionAnimation = completionAnimation
    }
}

// MARK: SwipeToActionViewModifier
public struct SwipeToActionViewModifier<T>: ViewModifier where T : View {
    // MARK: Static
    private let viewId: String
    private let swipeToDeleteThresholdRatio: CGFloat = 0.5
        
    // MARK: Properties
    @State private var contentOffset: CGFloat = 0 // The parent view content offset as the user is dragging it
    @State private var lastOffset: CGFloat = 0 // Used when starting to drag from a visible state
    @State private var contentSize: CGSize = .zero // The size of the row being swiped
    @State private var actionViewSize: CGSize = .zero // The size of the action view tap area
    @State private var isActionViewShown = false // Indicates if the action view is shown
    @State private var isPerformingAction: Bool = false // Indicates if the action animation is running
    
    private var action: () -> Void
    private var actionView: (_ viewSize: Binding<CGSize>) -> T
    private var actionConfig: SwipeToActionConfiguration
    
    // Stores the id of the view that is currently swiped.
    // This is used to ensure that only one view is shown at any time.
    // Each row will listen to changes and if it's NOT their id being stored, they will collapse
    @AppStorage("ViewSync.SwipeToActionViewId") var swipeToActionViewId: String = ""
        
    // MARK: Body
    public func body(content: Content) -> some View {
        ZStack() {
            contentActionView()
            contentView(content)
        }
        .onChange(of: swipeToActionViewId) { swipeToActionViewId in
            // reset the view if another view is swiped
            if swipeToActionViewId != viewId {
                resetView()
            }
        }
    }
    
    // MARK: Lifecycle
    
    public init(viewId: String = UUID().uuidString,
                actionView: @escaping (_ viewSize: Binding<CGSize>) -> T,
                actionConfig: SwipeToActionConfiguration,
                action: @escaping () -> Void) {
        self.viewId = viewId
        self.actionView = actionView
        self.actionConfig = actionConfig
        self.action = action
    }
    
    // MARK: Private Views
    private func contentView(_ content: Content) -> some View {
        content
            .getSize($contentSize)
            .offset(x: contentOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if isPerformingAction {
                            return
                        }
                        swipeToActionViewId = viewId
                        contentOffset = calculateContentOffset(translationWidth: value.translation.width, dragStartingOffset: lastOffset)
                        isActionViewShown = contentOffset < -actionViewSize.width
                        if contentOffset < -swipeToDeleteThreshold() &&
                            actionConfig.completionAnimation == .completeSwipe {
                            performAction()
                        }
                    }
                    .onEnded { value in
                        if isPerformingAction {
                            return
                        }
                        if isActionViewShown {
                            withAnimation {
                                // Show the action view properly
                                contentOffset = -actionViewSize.width
                            }
                        } else {
                            withAnimation {
                                // Hide the action view
                                contentOffset = 0
                            }
                        }
                        lastOffset = contentOffset
                    }
            )
    }
    
    private func contentActionView() -> some View {
        ZStack {
            actionViewBackground()
                .offset(x: contentSize.width + contentOffset)
            actionViewForeground()
                .offset(x: max(contentSize.width + contentOffset, contentSize.width - actionViewSize.width))
        }
        .frame(height: contentSize.height)
    }
    
    private func actionViewForeground() -> some View {
        HStack {
            actionView($actionViewSize)
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            performAction()
        }
    }
    
    private func actionViewBackground() -> some View {
        actionConfig.backgroundColor
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
    
    private func performAction() {
        isPerformingAction = true
        withAnimation {
            switch actionConfig.completionAnimation {
            case .completeSwipe:
                contentOffset = -UIScreen.main.bounds.width
            case .collapse:
                contentOffset = 0.0
            }
            action()
        }
        DispatchQueue.main.asyncAfter(deadline: .init(uptimeNanoseconds: 500)) {
            resetView()
        }
    }
    
    private func resetView() {
        withAnimation {
            contentOffset = 0
            lastOffset = 0
            isPerformingAction = false
        }
    }
}

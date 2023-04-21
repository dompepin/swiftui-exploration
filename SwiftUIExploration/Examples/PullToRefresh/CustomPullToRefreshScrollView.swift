//
//  CustomPullToRefreshScrollView.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2023-04-04.
//

import SwiftUI
import UICompass
import os.log

class CustomPullToRefreshScrollViewModel: NSObject, ObservableObject, UIGestureRecognizerDelegate {
    // MARK: Enums
    enum State {
        case idle
        case refreshing
        case refreshingDoneButStillPulling
    }

    // MARK: Properties
    @Published var state: State = .idle
    @Published var pullingProgress: CGFloat = 0 // The pulling progress before the PTR is triggered
    @Published var contentOffset: CGFloat = 0 // The main content offset triggered by us dragging the view or scrolling
    @Published var pullToRefreshViewVisibilityOffset: CGFloat = 0 // How much of the PTR View we want to show
    
    // MARK: Methods
    func reset() {
        state = .idle
        pullToRefreshViewVisibilityOffset = 0
        contentOffset = 0
        pullingProgress = 0
        Logger.pullToRefresh.debug("ViewModel reseted")
    }
}

/// This is a scroll view with a custom pull-to-refresh control embedded at the top (instead of using the default Apple version).
/// ToDo and Issues:
///  1) Create a `refreshable()` modifier that can be applied to a `ScrollView()`
///  2) See if we can pass the PTR View/Animation
///  3) This will not work with a `List()`
///  4) I did not find a way to detect when the finger is touching the scroll view or not. This has some side effects where you can trigger the PTR by flicking the view down.
struct CustomPullToRefreshScrollView<Content: View>: View {
    
    // MARK: Properties
    private let pullToRefreshUpperThreshold = 75.0
    private let pullToRefreshLowerThreshold = 1.0 // Sometime, the content offset reset to a really small values (1.4E-14) instead of 0. This prevent the UI from not resetting.
    private let scrollViewCoordinateSpace = "CustomPullToRefreshScrollView"
    private var content: Content
    private var onRefresh: () async-> ()
    @StateObject private var viewModel: CustomPullToRefreshScrollViewModel = .init()
    
    // MARK: Body
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                pullToRefreshView()
                    .frame(height: pullToRefreshUpperThreshold) // TODO: We should be able to calculate this
                    .offset(y: -viewModel.contentOffset)
                content
                    .offset(y: -pullToRefreshUpperThreshold + viewModel.pullToRefreshViewVisibilityOffset)
            }
            .readOffset(coordinateSpace: scrollViewCoordinateSpace) { offset in
                viewModel.contentOffset = offset
                //Logger.pullToRefresh.debug("Content Offset: \(Int(viewModel.contentOffset))")
                
                // If we are pulling but are still not refreshing
                if viewModel.state == .idle {
                    viewModel.pullToRefreshViewVisibilityOffset = offset
                    viewModel.pullingProgress = (offset / pullToRefreshUpperThreshold).clamp(between: 0, and: 1)
                    
                    if viewModel.pullingProgress >= 1 {
                        withAnimation {
                            viewModel.state = .refreshing
                        }
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
                }
                
                /// If the user was still holding the scroll view down when the refresh routine finished, once they let go,
                /// we need to reset the view.
                if viewModel.state == .refreshingDoneButStillPulling &&
                    viewModel.contentOffset < pullToRefreshLowerThreshold {
                    withAnimation {
                        viewModel.reset()
                    }
                }
            }
        }
        .coordinateSpace(name: scrollViewCoordinateSpace)
        .onChange(of: viewModel.state) { newValue in
            if newValue != .refreshing {
                return
            }
            Task {
                Logger.pullToRefresh.log("ℹ️ Started refreshing")
                await onRefresh()
                Logger.pullToRefresh.log("ℹ️ Done refreshing")
                if viewModel.contentOffset < pullToRefreshLowerThreshold {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        viewModel.reset()
                    }
                } else {
                    viewModel.state = .refreshingDoneButStillPulling
                }
            }
        }
    }
    
    // MARK: Lifecycle
    init(@ViewBuilder content: @escaping () -> Content,
         onRefresh: @escaping ()async->()) {
        self.content = content()
        self.onRefresh = onRefresh
    }
    
    // MARK: Private Views
    /// View that represents the pull-to-refresh current state
    @ViewBuilder
    func pullToRefreshView() -> some View {
        switch viewModel.state {
        case .refreshing, .refreshingDoneButStillPulling:
            PulsingActivityIndicator(config: .example_three_shapes)
                .padding(.all)
        case .idle:
            ProgressView(value: viewModel.pullingProgress, total: 1)
                .progressViewStyle(DoughnutProgressStyle())
                .opacity(viewModel.pullingProgress * 2)
                .padding(.all)
        }
    }
}

// MARK: Private Helpers
private extension View {
    /// Returns the offset of the view within a given scrollView
    func readOffset(coordinateSpace: String, offset: @escaping (CGFloat)->())-> some View {
        self.background {
            GeometryReader { geometry in
                Color.clear
                    .preference(key: OffsetPreferenceKey.self, value: geometry.frame(in: .named(coordinateSpace)).minY)
                    .onPreferenceChange(OffsetPreferenceKey.self){ value in
                        offset(value)
                    }
            }
        }
    }
}

/// Preference Key used to capture the offset of the scroll view
private struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

/// Doughnut style progress bar
private struct DoughnutProgressStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
            Circle()
                .trim(from: 0, to: configuration.fractionCompleted ?? 0)
                .stroke(.blue, style: StrokeStyle(lineWidth: 4.0, lineCap: .round))
                .rotationEffect(.degrees(-90))
    }
}

// MARK: Preview
struct CustomRefreshView_Previews: PreviewProvider {
    static var previews: some View {
        CustomPullToRefreshScrollView() {
            LazyVStack(spacing:8) {
                ForEach(1..<100) { row in
                    ExampleTitleRow("Row \(row)")
                        .padding(.horizontal, 16)
                }
            }
        } onRefresh: {
            try? await Task.sleep(seconds: 3)
        }
    }
}

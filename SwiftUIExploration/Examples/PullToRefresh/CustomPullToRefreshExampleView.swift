//
//  CustomPullToRefreshExampleView.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2022-06-24.
//

import SwiftUI

/// Example demostrating the use of a custom pull-to-refresh control.
struct CustomPullToRefreshExampleView: View {
    var body: some View {
        
        CustomPullToRefreshScrollView() {
            LazyVStack(spacing:8) {
                ForEach(1..<100) { row in
                    PullToRefreshExampleRow("Row \(row)")
                        .padding(.horizontal, 16)
                }
            }
            .background(.background)
            .padding(.top, 32)
        } onRefresh: {
            try? await Task.sleep(seconds: 3)
        }
        .navigationTitle("Custom Pull-To-Refresh")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CustomPullToRefreshExampleView_Previews: PreviewProvider {
    static var previews: some View {
        CustomPullToRefreshExampleView()
    }
}



//
//  PullToRefresh.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2022-04-17.
//

import SwiftUI
import Combine
import UICompass

/// Example demostrating the use of a Apples default pull-to-refresh control.
struct ApplePullToRefreshExampleView: View {
    var body: some View {
        ScrollView() {
            LazyVStack(spacing:8) {
                ForEach(1..<100) { row in
                    ExampleTitleRow("Row \(row)")
                        .padding(.horizontal, 16)
                }
            }
            .background(.background)
            .padding(.top, 32)
        }
        .navigationTitle("Apple Pull-To-Refresh")
        .navigationBarTitleDisplayMode(.inline)
        .refreshable {
            try? await Task.sleep(seconds: 3)
        }
    }
}

struct PullToRefreshExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ApplePullToRefreshExampleView()
    }
}

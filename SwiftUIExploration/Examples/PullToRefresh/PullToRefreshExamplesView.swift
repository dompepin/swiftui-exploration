//
//  PullToRefreshExamplesView.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2023-04-21.
//

import SwiftUI

struct PullToRefreshExamplesView: View {
    
    // MARK: Body
    
    var body: some View {
        List {
            MenuItemViewLink("Apple pull-to-refresh") {
                ApplePullToRefreshExampleView()
            }
            MenuItemViewLink("Custom pull-to-refresh") {
                CustomPullToRefreshExampleView()
            }
        }
        .listStyle(.plain)
        .navigationTitle("Pull-to-refresh examples")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PullToRefreshExamplesView_Previews: PreviewProvider {
    static var previews: some View {
        PullToRefreshExamplesView()
    }
}

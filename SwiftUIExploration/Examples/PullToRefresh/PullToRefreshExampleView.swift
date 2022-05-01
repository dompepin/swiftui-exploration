//
//  PullToRefresh.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2022-04-17.
//

import SwiftUI
import Combine

struct PullToRefreshExampleView: View {
    var body: some View {
        List(1..<100) { row in
            Text("Row \(row)")
        }
        .navigationTitle("Pull-to-refresh")
        .navigationBarTitleDisplayMode(.inline)
        .refreshable {
            try? await Task.sleep(seconds: 3)
        }
    }
}

struct PullToRefreshExampleView_Previews: PreviewProvider {
    static var previews: some View {
        PullToRefreshExampleView()
    }
}

fileprivate extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}

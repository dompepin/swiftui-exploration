//
//  PulsingActivityIndicatorExampleView.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2022-02-12.
//

import SwiftUI

struct PulsingActivityIndicatorExampleView: View {
    var body: some View {
        VStack (alignment: .center, spacing: 24) {
            PulsingActivityIndicator(config: .example_three_shapes)
            PulsingActivityIndicator(config: .example_text)
            PulsingActivityIndicator(config: .example_one_view)
            PulsingActivityIndicator(config: .example_shimmer)
                .cornerRadius(20)
            PulsingActivityIndicator(config: .example_four_circles)
            PulsingActivityIndicator(config: .example_images)
        }
        .navigationTitle("Pulsing Activity Indicators")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PulsingActivityIndicatorExampleView_Previews: PreviewProvider {
    static var previews: some View {
        PulsingActivityIndicatorExampleView()
    }
}

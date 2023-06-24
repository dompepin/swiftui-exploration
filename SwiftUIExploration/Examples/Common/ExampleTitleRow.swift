//
//  ExampleRow.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2023-04-06.
//

import SwiftUI

/// Row use in some of the examples
struct ExampleTitleRow: View {
    
    // MARK: Properties
    
    private let text: String
    
    // MARK: Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Text(text)
                Spacer()
                Image(systemName: "arrow.right")
                    .foregroundColor(.white)
                    .padding(.all, 8)
                    .background(Circle())
                    .onTapGesture {
                        print("Item \(text) was tapped")
                    }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 4.0)
            .foregroundColor(.white)
            .shadow(color: .gray, radius: 8, x: 0, y: 8))
    }
    
    // MARK: Init
    
    init(_ text: String) {
        self.text = text
    }
}

struct PullToRefreshExampleRow_Previews: PreviewProvider {
    static var previews: some View {
        ExampleTitleRow("Hello World!")
    }
}

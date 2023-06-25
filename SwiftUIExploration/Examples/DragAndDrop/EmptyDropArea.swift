//
//  EmptyAreaDropArea.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2023-06-25.
//

import SwiftUI

struct EmptyDropArea: View {
    var text: String
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text(text)
                    .padding(10)
                Spacer()
            }
            Spacer()
        }
        .background(Color(.systemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
        )
        .padding(Constant.Padding.large16)
    }
    
    init(_ text: String = "You can drop that item here 😊") {
        self.text = text
    }
}
struct EmptyDropArea_Previews: PreviewProvider {
    static var previews: some View {
        EmptyDropArea()
    }
}

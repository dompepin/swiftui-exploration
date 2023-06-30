//
//  SectionHeader.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2023-06-25.
//

import SwiftUI

struct SectionHeader: View {
    // MARK: Properties
    let title: String
    
    // MARK: Body
    var body: some View {
            HStack {
                Text(title)
                    .font(.title)
                Spacer()
            }
            .padding(Constant.Padding.large16)
            .background(
                Color(UIColor.secondarySystemBackground)
                .cornerRadius(8, corners: .allCorners))
            .background(RoundedRectangle(cornerRadius: 4.0)
                .foregroundColor(.white)
                .shadow(color: .gray, radius: 8, x: 0, y: 8))
            .padding(.horizontal, Constant.Padding.Custom.outerEdge16)
            
        }
    
    // MARK: Lifecycle
    init(_ title: String) {
        self.title = title
    }
}

struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeader("Section Header")
    }
}

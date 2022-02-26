//
//  EyebrowText.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2022-02-26.
//

import SwiftUI

struct EyebrowText: View {
    
    let string: String
    
    var body: some View {
        Text("\(string.uppercased())")
            .fontWeight(.bold)
            .kerning(1)
    }
    
    init(_ string: String) {
        self.string = string
    }
}

struct EyebrowText_Previews: PreviewProvider {
    static var previews: some View {
        EyebrowText("Section header")
    }
}

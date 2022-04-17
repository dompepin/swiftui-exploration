//
//  DismissableBackground.swift
//  UICompass
//
//  Created by Dominic Pepin on 2022-04-10.
//

import SwiftUI

struct DismissableBackground: View {
    var body: some View {
        Color
            .red
            .onTapGesture {
                
                    
            }
            .background(
                dismissibleViewColor
                    .opacity(isPresented ? dismissibleViewOpacity : 0.0)
                    .onTapGesture {
                        isPresented.toggle()
                    }
                    .ignoresSafeArea()
            )
    }
}

struct DismissableBackground_Previews: PreviewProvider {
    static var previews: some View {
        DismissableBackground()
    }
}

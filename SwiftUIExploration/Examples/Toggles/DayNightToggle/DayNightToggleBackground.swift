//
//  DayNightToggleBackground.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2022-04-03.
//

import SwiftUI

struct DayNightToggleBackground: View {
    
    struct Configuration {
        private (set) var startColor: Color
        private (set) var endColor: Color
        
        init(startColor: Color, endColor: Color) {
            self.startColor = startColor
            self.endColor = endColor
        }
        
        static let day = Configuration(startColor: .dayColor1, endColor: .dayColor2)
        static let night = Configuration(startColor: .nightColor1, endColor: .nightColor2)
    }
    
    private var config: Configuration
    
    var body: some View {
        Capsule()
            .fill (
                LinearGradient(gradient: Gradient(colors: [config.startColor, config.endColor]), startPoint: .leading, endPoint: .trailing)
            )
    }
    
    init(_ config: Configuration) {
        self.config = config
    }
}

struct DayNightToggleBackground_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Spacer()
            VStack {
                DayNightToggleBackground(.day)
                    .frame(width: 100, height: 44)
                DayNightToggleBackground(.night)
                    .frame(width: 100, height: 44)
                Spacer()
            }
            Spacer()
            
        }
        .background(.gray)
    }
}

//
//  DayNightToggleKnob.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2022-04-03.
//

import SwiftUI

struct DayNightToggleKnob: View {
    
    struct Configuration {
        var image: Image
        var color: Color
        var padding: CGFloat
        
        init(image: Image, color: Color, padding: CGFloat) {
            self.image = image
            self.color = color
            self.padding = padding
        }
        
        static let day: Configuration = .init(image: Image(systemName: "sun.min.fill"),
                                              color: .dayColor1,
                                              padding: 8)
        static let night: Configuration = .init(image: Image(systemName: "moon.fill"),
                                                color: .nightColor1,
                                                padding: 12)
    }
    
    private var config: Configuration
    
    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .fill(
                    LinearGradient(gradient: Gradient(colors: [.gray, .white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )
            Circle()
                .strokeBorder(Color.white, lineWidth: 4)
                .foregroundColor(.white)
            config.image
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding(.all, config.padding)
                .foregroundColor(config.color)
        }
    }
    
    init(_ config: Configuration) {
        self.config = config
    }
    
}

struct DayNightKnob_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Spacer()
            VStack {
                DayNightToggleKnob(.day)
                    .frame(width: 44, height: 44)
                DayNightToggleKnob(.night)
                    .frame(width: 44, height: 44)
                Spacer()
            }
            Spacer()
            
        }
        .background(.gray)
    }
}

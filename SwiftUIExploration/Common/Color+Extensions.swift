//
//  Color+Extensions.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2022-02-26.
//

import SwiftUI

extension Color {
    
    public func lighter(by percentage: CGFloat = 20.0) -> Color {
        return self.adjust(by: abs(percentage) )
    }
    
    public func darker(by percentage: CGFloat = 20.0) -> Color {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> Color {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        if UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return Color(UIColor(red: min(red + percentage/100, 1.0),
                                 green: min(green + percentage/100, 1.0),
                                 blue: min(blue + percentage/100, 1.0),
                                 alpha: alpha))
        } else {
            return self
        }
    }
}

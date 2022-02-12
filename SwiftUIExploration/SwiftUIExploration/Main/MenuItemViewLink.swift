//
//  MenuItemView.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2022-02-12.
//

import SwiftUI

/// A NavigationLink that looks like a MenuItemView
struct MenuItemViewLink<Destination> : View where Destination : View {
    
    // MARK: Properties
    
    /// Menu item title
    private var title: String
    /// Navigation link destination
    private var destination: () -> Destination
    
    // MARK: Body
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(alignment: .leading, spacing: 0) {
                Text("\(self.title)")
                
            }
            .padding()
        }
    }
    
    // MARK: Lifecycle
    
    /// Creates a menu item that presents the destination view.
    /// - Parameters:
    ///   - title: Menu item title
    ///   - destination: The view to present when the menu item is activated
    public init(_ title: String, @ViewBuilder destination: @escaping () -> Destination) {
        self.title = title
        self.destination = destination
    }
}

// MARK: Preview

struct MenuItemViewLink_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemViewLink("Animations") {
            Text("Animations Detail")
        }
        .previewLayout(.fixed(width: 320, height: 60))
    }
}

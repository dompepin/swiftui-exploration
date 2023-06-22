//
//  SwipeToDeleteExampleView.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2023-06-20.
//

import SwiftUI

struct SwipeToDeleteExampleView: View {
    @State private var items = ["Item 1", "Item 2", "Item 3", "Item 4"]
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(items, id: \.self) { item in
                    ExampleTitleRow("Row 1")
                        .swipeToDelete {
                            items.removeAll { $0 == item }
                        }
                }
            }
        }
        .navigationTitle("Swipe to delete")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SwipeToDeleteExampleView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeToDeleteExampleView()
    }
}

//
//  SwipeToActionExampleView.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2023-06-20.
//

import SwiftUI

struct SwipeToActionExampleView: View {
    @State private var items = ["Swipe to delete Item 1", "Swipe to delete Item 2", "Swipe to delete Item 3", "Swipe to delete Item 4", "Swipe to delete Item 5"]
    @State private var swipeToConfirmText = "Swipe to confirm"
    @State private var isConfirmed = false
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(items, id: \.self) { item in
                    ExampleTitleRow(item)
                        .padding(.horizontal, Constant.Padding.Custom.outerEdge16)
                        .swipeToDelete {
                            items.removeAll { $0 == item }
                        }
                }
                ExampleTitleRow(swipeToConfirmText)
                    .padding(.horizontal, Constant.Padding.Custom.outerEdge16)
                    .swipeToConfirm($isConfirmed) {
                        isConfirmed.toggle()
                        print("Is Confirmed: \(isConfirmed)")
                    }
            }
        }
        .navigationTitle("Swipe to delete")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SwipeToDeleteExampleView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeToActionExampleView()
    }
}

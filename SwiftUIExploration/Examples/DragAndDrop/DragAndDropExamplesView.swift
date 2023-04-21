//
//  DragAndDropExamplesView.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2023-04-21.
//

import Foundation
import SwiftUI

struct DragAndDropExamplesView: View {
    
    // MARK: Body
    
    var body: some View {
        List {
            MenuItemViewLink("Between lists with NSItemProvider") {
                DragAndDropBetweenListsExampleView()
            }
            MenuItemViewLink("VStack with NSItemProvider") {
                DragAndDropItemProviderVStackExampleView()
            }
            MenuItemViewLink("Drag and drop with Transferable") {
                DragAndDropTransferableVStackExampleView()
            }
        }
        .listStyle(.plain)
        .navigationTitle("Drag and drop")
        .navigationBarTitleDisplayMode(.inline)
    }
}

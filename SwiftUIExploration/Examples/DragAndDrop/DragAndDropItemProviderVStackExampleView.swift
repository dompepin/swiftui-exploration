//
//  DragAndDropItemProviderVStackExampleView.swift
//  ToDoPad
//
//  Created by Dominic Pepin on 2023-04-16.
//

import SwiftUI
import os.log

/// This example explores dragging and dropping within a VStack using NSItemProvider.
struct DragAndDropItemProviderVStackExampleView: View {
    
    @State private var draggedItem: Item?
    
    @State var items1 = [
        Item(id: "1", title: "Item 1", category: "Must Do"),
        Item(id: "2", title: "Item 2", category: "Must Do"),
        Item(id: "3", title: "Item 3", category: "Must Do"),
        Item(id: "4", title: "Item 4", category: "Must Do"),
        Item(id: "5", title: "Item 5", category: "Must Do")
    ]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: Constant.Padding.RowSpacing.default) {
                ForEach(items1, id: \.self) { item in
                    ExampleTitleRow(item.title)
                        .onDrag {
                            draggedItem = item
                            return NSItemProvider(object: ItemDragObject(item: item))
                        }
                        .onDrop(of: [ItemDragObject.typeIdentifier],
                                delegate: DropItemDelegate(destinationItem: item, items: $items1, draggedItem: $draggedItem)
                        )
                }
                Spacer()
            }
            .padding(.top, Constant.Padding.Top.default)
            .padding(.bottom, Constant.Padding.Bottom.default)
            .padding(.horizontal, Constant.Padding.Horizontal.default)
        }
        .navigationTitle("Drag and Drop - VStack")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: DropItemDelegate

fileprivate struct DropItemDelegate: DropDelegate {
    
    // MARK: Properties
    let destinationItem: Item
    @Binding var items: [Item]
    @Binding var draggedItem: Item?
    
    // MARK: Lifecycle
    init(destinationItem: Item, items: Binding<[Item]>, draggedItem: Binding<Item?>) {
        self.destinationItem = destinationItem
        self._items = items
        self._draggedItem = draggedItem
    }
    
    // MARK: DropDelegate
    func validateDrop(info: DropInfo) -> Bool {
        return draggedItem != nil
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedItem,
              let fromIndex = items.firstIndex(of: draggedItem),
              let toIndex = items.firstIndex(of: destinationItem) else {
            return
        }
        
        if fromIndex != toIndex {
            withAnimation {
                self.items.move(fromOffsets: IndexSet(integer: fromIndex),
                                toOffset: (toIndex > fromIndex ? (toIndex + 1) : toIndex))
            }
        }
    }
    
    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }
}

// MARK: Private

struct DragAndDropPrototype2View_Previews: PreviewProvider {
    static var previews: some View {
        DragAndDropItemProviderVStackExampleView()
    }
}


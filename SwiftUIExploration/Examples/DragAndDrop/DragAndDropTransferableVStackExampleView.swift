//
//  DragAndDropTransferable.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2023-04-20.
//

import SwiftUI
import os.log
import UICompass

/// This example explores dragging and dropping within a VStack using the Transferable protocol.
struct DragAndDropTransferableVStackExampleView: View {
    
    // MARK: Properties
    @State var highlightedItem: Item? = nil
    @State var isInsertAnimationEnabled: Bool = false
    @State var items = [
        Item(id: "1", title: "Item 1", category: "Must Do"),
        Item(id: "2", title: "Item 2", category: "Must Do"),
        Item(id: "3", title: "Item 3", category: "Must Do"),
        Item(id: "4", title: "Item 4", category: "Must Do")
    ]
    
    // MARK: Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(items, id: \.self) { item in
                    VStack(spacing: 0){
                        ExampleTitleRow(item.title)
                            .scaleEffect(dropViewScaleEffect(item: item, highlightedItem: highlightedItem, isInsertAnimationEnabled: isInsertAnimationEnabled))
                        touchSpacer()
                            .frame(height: dropViewSpacing(item: item, highlightedItem: highlightedItem, isInsertAnimationEnabled: isInsertAnimationEnabled))
                    }
                    .draggable(item, preview: {
                        makeExampleTitleRowDraggableView(for: item)
                    })
                    .dropDestination(for: Item.self,
                                     action: { draggedItems, _ in dropAction(item, draggedItems) },
                                     isTargeted: { isInDropArea in isDropAreaTargeted(dropAreaItem: item, isInDropArea: isInDropArea) })
                }
                Spacer()
                insertAnimationView()
                    .padding(.vertical, 16)
            }
            .padding(.top, Constant.Padding.Top.default)
            .padding(.bottom, Constant.Padding.Bottom.default)
            .padding(.horizontal, Constant.Padding.Horizontal.default)
        }
        .navigationTitle("Drag and Drop - VStack Transferable")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: Private
    
    func makeExampleTitleRowDraggableView(for item: Item) -> some View {
        return ExampleTitleRow(item.title)
            .frame(width:250)
            .foregroundColor(.blue)
    }
    
    private func isDropAreaTargeted(dropAreaItem: Item, isInDropArea: Bool) {
        withAnimation(.linear(duration: 0.2)) {
            highlightedItem = isInDropArea ? dropAreaItem : nil
        }
    }
    
    func dropAction(_ dropAreaItem: Item, _ draggedItems: [Item]) -> Bool {
        Logger.default.info("ℹ️ Dropping item '\(draggedItems[safe: 0]?.title ?? "")' on item '\(dropAreaItem.title)'")
        
        if draggedItems.count > 1 {
            Logger.default.warning("🟠 Error: Dragging and dropping multiple items is not supported, only the first item will be dropped.")
        }
        
        guard let draggedItem = draggedItems[safe: 0],
              let fromIndex = items.firstIndex(of: draggedItem),
              let toIndex = items.firstIndex(of: dropAreaItem) else {
            return false
        }

        if fromIndex != toIndex {
            withAnimation {
                self.items.move(fromOffsets: IndexSet(integer: fromIndex),
                                toOffset: isInsertAnimationEnabled ? toIndex + 1 : (toIndex > fromIndex ? toIndex + 1 : toIndex))
            }
        }
        return true
    }

    /// Spacer or Color.clear does not allow dropping object. This allow to drop an item between 2 rows.
    func touchSpacer() -> some View {
        Color(red: 1, green: 1, blue: 1, opacity: 0.01)
    }
    
    func insertAnimationView() -> some View {
        VStack {
            HStack {
                Text("Insertion Animation")
                Spacer()
                CustomToggle(isOn: $isInsertAnimationEnabled, config: .systemRoundedRectangle)
                    .frame(width: 60, height: 30)
            }
            Text("The insertion animation attempts to replicate the 'List' insertion mode. However, there are some ui glitch with its implementation because the `isTargeted` method fails to supply the dragged item and restricts our options. ")
                .font(.caption)
        }
    }
    
    // Define the scale effect of a row based on the animation type and if the drop item is hovering over it or not.
    func dropViewScaleEffect(item: Item, highlightedItem: Item?, isInsertAnimationEnabled: Bool) -> CGFloat {
        if isInsertAnimationEnabled {
            return 1
        }
        return item == highlightedItem ? 1.05 : 1
    }
    
    // Define the row spacing based on the animation type and if the drop item is hovering over it or not.
    func dropViewSpacing(item: Item, highlightedItem: Item?, isInsertAnimationEnabled: Bool) -> CGFloat {
        if isInsertAnimationEnabled {
            return item == highlightedItem ? 50 : Constant.Padding.RowSpacing.default
        }
        return Constant.Padding.RowSpacing.default
    }
}

// MARK: Preview

struct DragAndDropTransferable_Previews: PreviewProvider {
    static var previews: some View {
        DragAndDropTransferableVStackExampleView()
    }
}

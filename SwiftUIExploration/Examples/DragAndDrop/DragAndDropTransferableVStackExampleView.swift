//
//  DragAndDropTransferableVStackExampleView.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2023-04-20.
//

import SwiftUI
import os.log
import UICompass

/// This example explores dragging and dropping within a VStack using the Transferable protocol.
/// Issues:
///  1) We do not know which item we are dragging. This makes it hard to implement any kind of logic

// TODO:
//1) Try to get an insert animation going on NSItemProvider example.... and try to see if we can do the highlight animation
//2) Implement Drag and Drop on NSItemProvider
//3) Implement Drag and Drop on Transferable

struct DragAndDropTransferableVStackExampleView: View {
    // MARK: Properties
    @State var highlightedItem: Item? = nil
    @State var highlightedEmptySection: Section? = nil
    // This is used because when dragging an item, we get an in followed by an out event.
    // This allow us to keep the dragged item highlighted.
    // There is still an issue if we drop the first item outside a drop area. In that case, nothing gets called and we cannot reset the flag.
    @State var draggedItem: Item? = nil
    @State var isInsertAnimationEnabled: Bool = false
    @ObservedObject private var viewModel: DragAndDropSectionViewModel = .init(sections: DragAndDropSectionViewModel.exampleSections)
    
    // MARK: Body
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.sections, id: \.id) { section in
                    sectionHeader(section)
                    if section.items.count > 0 {
                        ForEach(section.items, id: \.id) { item in
                            itemRow(item: item, section: section)
                        }
                    } else {
                        emptyDropArea(section: section)
                    }
                }
                Spacer()
                insertAnimationView()
                    .padding(.all, Constant.Padding.Custom.outerEdge16)
            }
            .padding(.top, Constant.Padding.Custom.topEdge16)
            .padding(.bottom, Constant.Padding.Custom.bottomEdge40)
        }
        .navigationTitle("Drag and Drop - VStack Transferable")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: Private views

    private func emptyDropArea(section: Section) -> some View {
        EmptyDropArea()
            .scaleEffect(section.id == highlightedEmptySection?.id ? 1.03 : 1)
            .dropDestination(for: Item.self,
                             action: { draggedItems, _ in emptyListDropAction(dropAreaSection: section, draggedItems: draggedItems) },
                             isTargeted: { isInDropArea in isEmptyListDropAreaTargeted(dropArea: section, isTargeted: isInDropArea) })
    }

    private func sectionHeader(_ section: Section) -> some View {
        SectionHeader(section.title)
            .padding(.vertical)
    }

    private func itemRow(item: Item, section: Section) -> some View {
        VStack(spacing: 0){
            ExampleTitleRow(item.title)
                .padding(.horizontal, Constant.Padding.Custom.outerEdge16)
                .swipeToDelete {
                    viewModel.delete(item: item)
                }
                .scaleEffect(dropViewScaleEffect(item: item, highlightedItem: highlightedItem, isInsertAnimationEnabled: isInsertAnimationEnabled))
            touchSpacer()
                .frame(height: dropViewSpacing(item: item, highlightedItem: highlightedItem, isInsertAnimationEnabled: isInsertAnimationEnabled))
        }
        .draggable(item, preview: {
            ExampleTitleRow(item.title)
                .dragPreview()
        })
        .dropDestination(for: Item.self,
                         action: { draggedItems, location in exampleTitleRowDropAction(dropAreaItem: item, draggedItems: draggedItems, location: location) },
                         isTargeted: { isInDropArea in isExampleTitleRowDropAreaTargeted(dropArea: item, isTargeted: isInDropArea) })
    }

    // MARK: Private methods
    private func isEmptyListDropAreaTargeted(dropArea dropAreaSection: Section, isTargeted: Bool) {
        withAnimation {
            highlightedEmptySection = isTargeted ? dropAreaSection : nil
        }
    }

    func emptyListDropAction(dropAreaSection: Section, draggedItems: [Item]) -> Bool {
        Log.info("Dropping item '\(draggedItems[safe: 0]?.title ?? "")' on empty section '\(dropAreaSection.title)'", .dragAndDrop)
        draggedItem = nil
        if draggedItems.count > 1 {
            Log.warning("🟠 Error: Dragging and dropping multiple items is not supported, only the first item will be dropped.")
        }

        guard let draggedItem = draggedItems[safe: 0] else {
            Log.warning("No items to drop.", .dragAndDrop) // TODO: Add category to all drag and drop logs
            return false
        }

        withAnimation {
            viewModel.drop(item: draggedItem, onto: dropAreaSection)
        }

        return true
    }

    private func isExampleTitleRowDropAreaTargeted(dropArea dropAreaItem: Item, isTargeted: Bool) {
        withAnimation(.linear(duration: 0.2)) {
            if isTargeted {
                highlightedItem = dropAreaItem
            } else if draggedItem == nil {
                // When you initiate the drag action, the row you are dragging will be targeted and this will allow us to
                // flag it as the dragged item. This is definitely a work around and I would probably not put this in production
                // code before making sure that if that behaviour change, it will not affect the overall logic.
                draggedItem = dropAreaItem
            } else {
                highlightedItem = nil
            }
        }
    }

    func exampleTitleRowDropAction(dropAreaItem: Item, draggedItems: [Item], location: CGPoint) -> Bool {
        Log.info("Dropping item '\(draggedItems[safe: 0]?.title ?? "")' on item '\(dropAreaItem.title)': (x:\(location.x), y:\(location.y)")
        draggedItem = nil
        highlightedItem = nil
        if draggedItems.count > 1 {
            Log.warning("Dragging and dropping multiple items is not supported, only the first item will be dropped.")
        }

        guard let draggedItem = draggedItems[safe: 0] else {
            Log.warning("No items to drop.", .dragAndDrop) // TODO: Add category to all drag and drop logs
            return false
        }

        withAnimation {
            viewModel.drop(item: draggedItem, onto: dropAreaItem)
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
            return item == highlightedItem ? 50 : Constant.Padding.Custom.rowSpacing8
        }
        return Constant.Padding.Custom.rowSpacing8
    }
}

// MARK: Preview

struct DragAndDropTransferableVStackExampleView_Previews: PreviewProvider {
    static var previews: some View {
        DragAndDropTransferableVStackExampleView()
    }
}

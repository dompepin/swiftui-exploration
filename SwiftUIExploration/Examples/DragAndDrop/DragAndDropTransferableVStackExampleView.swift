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
///  1) We do not know which item we are dragging. This makes it hard to implement any kind of logic. There is a workaround, but it's baking on the fact that the item that is getting dragged gets a in/out event originally.
///  2) We are not getting the position of the dragged item when hovering over destination item. This prevents us from inserting a drop area between 2 rows.
///  3) When dropping an item outside a drop area, we are not getting any events. This means we cannot reset all the flags.

struct DragAndDropTransferableVStackExampleView: View {
    // MARK: Properties
    @ObservedObject private var viewModel: DragAndDropSectionViewModel = .init(sections: DragAndDropSectionViewModel.exampleSections)
    @State private var isInsertAnimationEnabled: Bool = false
    
    // MARK: Body
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                insertAnimationView()
                    .padding(.all, Constant.Padding.Custom.outerEdge16)
                ForEach(viewModel.sections, id: \.id) { section in
                    sectionHeader(section)
                    if section.items.count > 0 {
                        ForEach(section.items, id: \.id) { item in
                            itemRow(item: item, section: section)
                                .tag(item.id)
                        }
                    } else {
                        emptyDropArea(section: section)
                    }
                }
            }
            .padding(.top, Constant.Padding.Custom.topEdge16)
            .padding(.bottom, Constant.Padding.Custom.bottomEdge40)
            .onAppear {
                viewModel.resetSections(DragAndDropSectionViewModel.exampleSections)
            }
        }
        .navigationTitle("Drag and Drop - VStack Transferable")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: Private views
    
    private func emptyDropArea(section: DDSection) -> some View {
        EmptyDropArea()
            .scaleEffect(section.id == viewModel.highlightedEmptySection?.id ? 1.03 : 1)
            .foregroundColor(section.id == viewModel.highlightedEmptySection?.id ? .blue : .black)
            .dropDestination(for: DDItem.self,
                             action: { draggedItems, _ in emptyListDropAction(dropAreaSection: section, draggedItems: draggedItems) },
                             isTargeted: { isInDropArea in isEmptyListDropAreaTargeted(dropArea: section, isTargeted: isInDropArea) })
    }
    
    private func sectionHeader(_ section: DDSection) -> some View {
        SectionHeader(section.title)
            .padding(.top, Constant.Padding.large16)
            .padding(.bottom, Constant.Padding.large16)
    }
    
    private func itemRow(item: DDItem, section: DDSection) -> some View {
        DDItemRow(item: item, section: section,
                  viewModel: viewModel,
                  rowDropArea: $viewModel.rowDropArea,
                  isInsertAnimationEnabled: isInsertAnimationEnabled)
        .draggable(item, preview: {
            ExampleTitleRow(item.title)
                .dragPreview()
        })
        .dropDestination(for: DDItem.self,
                         action: { draggedItems, location in exampleTitleRowDropAction(dropAreaItem: item, draggedItems: draggedItems, location: location) },
                         isTargeted: { isInDropArea in isExampleTitleRowDropAreaTargeted(dropArea: item, isTargeted: isInDropArea) })
    }

        
    @ViewBuilder
    private func rowDropArea(item: DDItem, dropLocation: RowDropLocation) -> some View {
        if let rowDropArea = viewModel.rowDropArea,
           rowDropArea.item.id == item.id,
           rowDropArea.dropLocation == dropLocation {
            Color.clear
                .frame(height: rowDropArea.height)
        }
    }
    
    func insertAnimationView() -> some View {
        VStack {
            HStack {
                Text("Insertion Animation (Not Working yet)")
                Spacer()
                CustomToggle(isOn: $isInsertAnimationEnabled, config: .systemRoundedRectangle)
                    .frame(width: 60, height: 30)
            }
            Text("The insertion animation cannot fully work because the 'dropDestination:isTargetted' callback does not give us the hover location and therefore we cannot determine if we are hovering at the top of bottom of the row.")
                .font(.caption)
        }
    }

    // Define the row spacing based on the animation type and if the drop item is hovering over it or not.
    func dropViewSpacing(item: DDItem, highlightedItem: DDItem?, isInsertAnimationEnabled: Bool) -> CGFloat {
        if isInsertAnimationEnabled {
            return item == highlightedItem ? 50 : Constant.Padding.Custom.rowSpacing8
        }
        return Constant.Padding.Custom.rowSpacing8
    }
    
    // MARK: Private methods
    private func isEmptyListDropAreaTargeted(dropArea dropAreaSection: DDSection, isTargeted: Bool) {
        withAnimation {
            if isTargeted {
                viewModel.onHover(emptySection: dropAreaSection)
            } else {
                viewModel.onHoverExited(emptySection: dropAreaSection)
            }
        }
    }

    func emptyListDropAction(dropAreaSection: DDSection, draggedItems: [DDItem]) -> Bool {
        Log.info("Dropping item '\(draggedItems[safe: 0]?.title ?? "")' on empty section '\(dropAreaSection.title)'", .dragAndDrop)
        if draggedItems.count > 1 {
            Log.warning("🟠 Error: Dragging and dropping multiple items is not supported, only the first item will be dropped.")
        }

        guard let draggedItem = draggedItems[safe: 0] else {
            Log.warning("No items to drop.", .dragAndDrop)
            viewModel.onAbort()
            return false
        }

        withAnimation {
            viewModel.onDrop(item: draggedItem, onto: dropAreaSection)
        }

        return true
    }

    private func isExampleTitleRowDropAreaTargeted(dropArea dropAreaItem: DDItem, isTargeted: Bool) {
        withAnimation(.linear(duration: 0.2)) {
            if isTargeted {
                viewModel.onHover(over: dropAreaItem, atLocation: .zero)
            } else if viewModel.draggedItem == nil {
                // When you initiate the drag action, the row you are dragging will be targeted and this will allow us to
                // flag it as the dragged item. This is definitely a work around and I would probably not put this in production
                // code before making sure that if that behaviour change, it will not affect the overall logic.
                viewModel.onDrag(item: dropAreaItem)
            } else {
                viewModel.onHoverExited(dropItem: dropAreaItem)
            }
        }
    }

    func exampleTitleRowDropAction(dropAreaItem: DDItem, draggedItems: [DDItem], location: CGPoint) -> Bool {
        if draggedItems.count > 1 {
            Log.warning("Dragging and dropping multiple items is not supported, only the first item will be dropped.")
        }

        guard let draggedItem = draggedItems[safe: 0] else {
            viewModel.onAbort()
            Log.warning("No items to drop.", .dragAndDrop)
            return false
        }

        withAnimation {
            viewModel.onDrop(item: draggedItem, onto: dropAreaItem, atLocation: location)
        }

        return true
    }
}

// MARK: Preview

struct DragAndDropTransferableVStackExampleView_Previews: PreviewProvider {
    static var previews: some View {
        DragAndDropTransferableVStackExampleView()
    }
}


fileprivate struct DDItemRow: View {
    var item: DDItem
    var section: DDSection
    var viewModel: DragAndDropSectionViewModel
    @Binding var rowDropArea: RowDropAreaViewState?
    
    var isInsertAnimationEnabled: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            if isInsertAnimationEnabled {
                rowDropArea(item: item, dropLocation: .top)
            }
            ExampleTitleRow(item.title)
                .scaleEffect(!isInsertAnimationEnabled && item.id == rowDropArea?.item.id && rowDropArea?.dropLocation != RowDropLocation.none ? 1.03: 1)
                .padding(.horizontal, Constant.Padding.Custom.outerEdge16)
                .swipeToDelete {
                    viewModel.delete(item: item)
                }
                .padding(.bottom, Constant.Padding.Custom.rowSpacing8)
                .getSize(viewModel.rowHeightBinding(for: item))
            if isInsertAnimationEnabled {
                rowDropArea(item: item, dropLocation: .bottom)
            }
        }
        .contentShape(Rectangle())
    }
    
    @ViewBuilder
    private func rowDropArea(item: DDItem, dropLocation: RowDropLocation) -> some View {
        if let rowDropArea,
           rowDropArea.item.id == item.id,
           rowDropArea.dropLocation == dropLocation {
            Color.clear
                .frame(height: rowDropArea.height)
        }
    }
}

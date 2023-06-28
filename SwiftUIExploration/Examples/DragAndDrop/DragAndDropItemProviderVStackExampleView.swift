//
//  Created by Dominic Pepin on 2023-04-16.
//

import SwiftUI
import os.log
import UICompass

/// This example explores dragging and dropping within a VStack using NSItemProvider.
struct DragAndDropItemProviderVStackExampleView: View {
    // MARK: Properties
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
                                .tag(item.id)
                        }
                    } else {
                        emptySectionDropArea(section: section)
                    }
                }
            }
            .padding(.top, Constant.Padding.Custom.topEdge16)
            .padding(.bottom, Constant.Padding.Custom.bottomEdge40)
            .onAppear {
                viewModel.resetSections(DragAndDropSectionViewModel.exampleSections)
            }
        }
        .navigationTitle("Drag and Drop - NSItemProvider VStack")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: Private Views
    
    private func emptySectionDropArea(section: DDSection) -> some View {
        EmptyDropArea()
            .scaleEffect(section.id == viewModel.highlightedEmptySection?.id ? 1.03 : 1)
            .foregroundColor(section.id == viewModel.highlightedEmptySection?.id ? .blue : .black)
            .contentShape(Rectangle())
            .onDrop(of: [ItemDragObject.typeIdentifier],
                    delegate: DropItemDelegate(ontoItem: nil,
                                               ontoSection: section,
                                               viewModel: viewModel)
            )
    }
    
    private func sectionHeader(_ section: DDSection) -> some View {
        SectionHeader(section.title)
            .padding(.top, Constant.Padding.large16)
            .padding(.bottom, Constant.Padding.large16)
    }

    private func itemRow(item: DDItem, section: DDSection) -> some View {
        VStack(spacing: 0) {
            rowDropArea(item: item, dropLocation: .top)
            ExampleTitleRow(item.title)
                .padding(.horizontal, Constant.Padding.Custom.outerEdge16)
                .swipeToDelete {
                    viewModel.delete(item: item)
                }
                .padding(.bottom, Constant.Padding.Custom.rowSpacing8)
            //.opacity(viewModel.draggedItem?.id == item.id ? 0.20: 1) // TODO: Investigate more as to why this is not working.
                .getSize(viewModel.rowHeightBinding(for: item))
                
            rowDropArea(item: item, dropLocation: .bottom)
        }
        .contentShape(Rectangle())
        .onDrag {
            viewModel.onDrag(item: item)
            return NSItemProvider(object: ItemDragObject(item: item))
        } preview: {
            ExampleTitleRow(item.title)
                .dragPreview()
        }
        .onDrop(of: [ItemDragObject.typeIdentifier],
                delegate: DropItemDelegate(ontoItem: item,
                                           ontoSection: nil,
                                           viewModel: viewModel)
        )
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
}

// MARK: DropItemDelegate

fileprivate struct DropItemDelegate: DropDelegate {
    
    // MARK: Properties
    private let viewModel: DragAndDropSectionViewModel
    private let destinationItem: DDItem?
    private let destinationSection: DDSection?
        
    // MARK: Lifecycle
    init(ontoItem destinationItem: DDItem?,
         ontoSection destinationSection: DDSection?,
         viewModel: DragAndDropSectionViewModel) {
        self.destinationItem = destinationItem
        self.destinationSection = destinationSection
        self.viewModel = viewModel
    }
    
    // MARK: DropDelegate
    func validateDrop(info: DropInfo) -> Bool {
        return viewModel.draggedItem != nil
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        withAnimation {
            if let destinationItem {
                viewModel.onHover(over: destinationItem, atLocation: info.location)
            } else if let destinationSection{
                viewModel.onHover(emptySection: destinationSection)
            }
        }
        return DropProposal(operation: .copy) // Adds the "+" next to the dragged cell
    }
    
    func dropEntered(info: DropInfo) {
    }
    
    func dropExited(info: DropInfo) {
        withAnimation {
            if let destinationItem {
                viewModel.onHoverExited(dropItem: destinationItem)
            }
            else if let destinationSection {
                viewModel.onHoverExited(emptySection: destinationSection)
            }
        }
    }
    
    // MARK: Private
    func performDrop(info: DropInfo) -> Bool {
        guard let draggedItem =  viewModel.draggedItem else {
            Log.warning("No item to drag and drop.", .dragAndDrop)
            return false
        }
        withAnimation {
            if let destinationItem {
                viewModel.onDrop(item: draggedItem,
                                 onto: destinationItem,
                                 atLocation: info.location)
            } else if let destinationSection {
                viewModel.onDrop(item: draggedItem, onto: destinationSection)
            } else {
                assertionFailure("Missing destination item or section")
                Log.warning("Missing destination item or section")
            }
            
        }
        viewModel.draggedItem = nil
        return true
    }
}

// MARK: Preview

struct DragAndDropItemProviderVStackExampleView_Previews: PreviewProvider {
    static var previews: some View {
        DragAndDropItemProviderVStackExampleView()
    }
}


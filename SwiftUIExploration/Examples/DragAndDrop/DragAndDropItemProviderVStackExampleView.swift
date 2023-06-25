//
//  DragAndDropItemProviderVStackExampleView.swift
//  ToDoPad
//
//  Created by Dominic Pepin on 2023-04-16.
//

import SwiftUI
import os.log
import UICompass

/// This example explores dragging and dropping within a VStack using NSItemProvider.
struct DragAndDropItemProviderVStackExampleView: View {
    // MARK: Properties
    @State private var draggedItem: Item?
    @ObservedObject private var viewModel: DragAndDropSectionViewModel = .init(sections: DragAndDropSectionViewModel.exampleSections)
    @State private var exampleRowSizes: [String:CGSize] = [:]
    
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
            }
            .padding(.top, Constant.Padding.Custom.topEdge16)
            .padding(.bottom, Constant.Padding.Custom.bottomEdge40)
        }
        .navigationTitle("Drag and Drop - NSItemProvider VStack")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: Private Views
    
    private func emptyDropArea(section: Section) -> some View {
        EmptyDropArea()
            .onDrop(of: [ItemDragObject.typeIdentifier],
                    delegate: DropItemDelegate(draggedItem: $draggedItem, ontoItem: nil, ontoSection: section, viewModel: viewModel, rowHeight: 0)
            )
    }
    
    private func sectionHeader(_ section: Section) -> some View {
        SectionHeader(section.title)
    }
    
    private func itemRow(item: Item, section: Section) -> some View {
        VStack(spacing: 0) {
            if item.id == viewModel.spacerLocation?.item.id,
               viewModel.spacerLocation?.dropLocation == .top {
            Color.red
                .frame(height: 50)
                .contentShape(Rectangle())
        }
                
        ExampleTitleRow(item.title)
            .getSize(binding(for: item.id))
            .padding(.horizontal, Constant.Padding.Custom.outerEdge16)
            .swipeToDelete {
                viewModel.delete(item: item)
            }
            
            if item.id == viewModel.spacerLocation?.item.id,
               viewModel.spacerLocation?.dropLocation == .bottom {
                Color.blue
                    .frame(height: 50)
                    .contentShape(Rectangle())
            }
            
            Color.purple
                .frame(height: 8)
            .contentShape(Rectangle())
            
        }
        .background(Color.green)
        .onDrag {
            draggedItem = item
            return NSItemProvider(object: ItemDragObject(item: item))
        } preview: {
            ExampleTitleRow(item.title)
                .dragPreview()
        }
        .onDrop(of: [ItemDragObject.typeIdentifier],
                delegate: DropItemDelegate(draggedItem: $draggedItem, ontoItem: item, ontoSection: nil, viewModel: viewModel, rowHeight: binding(for: item.id).height.wrappedValue)
        )
    }
    
    private func binding(for key: String) -> Binding<CGSize> {
            return .init(
                get: { self.exampleRowSizes[key, default: .zero] },
                set: { self.exampleRowSizes[key] = $0 })
        }}

// MARK: DropItemDelegate

fileprivate struct DropItemDelegate: DropDelegate {
    
    // MARK: Properties
    private let viewModel: DragAndDropSectionViewModel
    private let destinationItem: Item?
    private let destinationSection: Section?
    @Binding private var draggedItem: Item?
    private let rowHeight: CGFloat
    
    
    // MARK: Lifecycle
    init(draggedItem: Binding<Item?>,
         ontoItem destinationItem: Item?,
         ontoSection destinationSection: Section?,
         viewModel: DragAndDropSectionViewModel,
         rowHeight: CGFloat) {
        self.destinationItem = destinationItem
        self.destinationSection = destinationSection
        self.viewModel = viewModel
        self._draggedItem = draggedItem
        self.rowHeight = rowHeight
    }
    
    // MARK: DropDelegate
    func validateDrop(info: DropInfo) -> Bool {
        return draggedItem != nil
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        guard let destinationItem else {
            return DropProposal(operation: .cancel)
        }
        let dropLocation = calculateDropLocation(y: info.location.y, height: rowHeight)
        print ("Location \(dropLocation)")
        withAnimation {
            viewModel.addDropLocation(to: destinationItem, dropLocation: dropLocation)
        }
        
//        viewModel.highlightSection
        return DropProposal(operation: .copy) // Adds the "+" next to the dragged cell
    }
    
    func dropEntered(info: DropInfo) {
        
    }
    
    func performDrop(info: DropInfo) -> Bool {
//        Log.debugHighlighted("\(info.location.y) in \(rowHeight)")
        guard let localDraggedItem =  draggedItem else {
            Log.warning("No item to drop.", .dragAndDrop)
            return false
        }
        withAnimation {
            if let destinationItem {
                viewModel.drop(item: localDraggedItem,
                               onto: destinationItem,
                               dropLocation: calculateDropLocation(y: info.location.y, height: rowHeight))
            } else if let destinationSection {
                viewModel.drop(item: localDraggedItem, onto: destinationSection)
            } else {
                assertionFailure("Missing destination item or section")
                Log.warning("Missing destination item or section")
            }
            
        }
        draggedItem = nil
        return true
    }
    
    func dropExited(info: DropInfo) {
        guard let destinationItem else {
            return
        }
        withAnimation {
            viewModel.addDropLocation(to: destinationItem, dropLocation: .unknown)
        }
    }
    
    private func calculateDropLocation(y: CGFloat, height: CGFloat) -> RowDropLocation {
        let center = height / 2
        if y <= center {
            return .top
        } else {
            return .bottom
        }
    }
}

// MARK: Private

struct DragAndDropPrototype2View_Previews: PreviewProvider {
    static var previews: some View {
        DragAndDropItemProviderVStackExampleView()
    }
}


//
//  SectionViewModel.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2023-06-26.
//

import Foundation
import SwiftUI

enum RowDropLocation {
    case none
    case top
    case bottom
}

/// Defines where a space should be displayed when dragging and dropping an item
struct RowDropAreaViewState {
    let item: DDItem
    let dropLocation: RowDropLocation
    let height: CGFloat
    
    init(item: DDItem, dropLocation: RowDropLocation, height: CGFloat) {
        self.item = item
        self.dropLocation = dropLocation
        self.height = height
    }
}

// MARK: ViewModel

class DragAndDropSectionViewModel: ObservableObject {
    // MARK: Properties
    @Published private (set) var sections: [DDSection]
    @Published private (set) var rowDropArea: RowDropAreaViewState? // Defines the spacer that will be inserted before or after a row to simulate making space to drop the dragged item.
    @Published var draggedItem: DDItem?
    @Published var highlightedEmptySection: DDSection? = nil
    private var rowSizes: [String:CGSize] = [:]
    
    // MARK: Lifecycle
    init(sections: [DDSection]) {
        self.sections = sections
    }
    
    // MARK: Public
    
    // Returns a binding to the height of a row.
    // This is used to extract the height of each cells to calculate the drop position
    func rowHeightBinding(for item: DDItem?) -> Binding<CGSize> {
        return .init(
            get: {
                guard let item else {
                    return .zero
                }
                return self.rowSizes[item.id, default: .zero] },
            set: {
                if let item {
                    self.rowSizes[item.id] = $0 }
            }
        )
    }
    
    /// Gets called when the drag action is initiated
    func onDrag(item: DDItem) {
        draggedItem = item
    }
    
    /// Gets called when a dragged item hover over another item
    func onHover(over dropItem: DDItem, atLocation location: CGPoint) {
        let draggedItemHeight = rowHeightBinding(for: draggedItem).wrappedValue.height
        let hoverLocation = calculateRowDropLocation(y: location.y,
                                                     draggedRowHeight: draggedItemHeight,
                                                     destinationRowHeight: rowHeightBinding(for: dropItem).height.wrappedValue )
        rowDropArea = RowDropAreaViewState(item: dropItem,
                                           dropLocation: hoverLocation,
                                           height: draggedItemHeight)
    }
    
    /// Gets called when the dragged item is not over another item anymore
    func onHoverExited(dropItem: DDItem) {
        rowDropArea = RowDropAreaViewState(item: dropItem, dropLocation: .none, height: .zero)
    }
    
    /// Gets called when the dragged item hover over an empty section drop area
    func onHover(emptySection: DDSection) {
        highlightedEmptySection = emptySection
    }
    
    /// Gets called when the dragged item exits a empty section drop area
    func onHoverExited(emptySection: DDSection) {
        if highlightedEmptySection?.id == emptySection.id {
            highlightedEmptySection = nil
        }
    }
    
    /// Gets called when an item is dropped over another item
    func onDrop(item draggedItem: DDItem, onto dropItem: DDItem, atLocation location: CGPoint? = nil) {
        var dropLocation: RowDropLocation = .none
        if let location {
            dropLocation = calculateRowDropLocation(y: location.y,
                                                    draggedRowHeight: rowHeightBinding(for: draggedItem).height.wrappedValue,
                                                    destinationRowHeight: rowHeightBinding(for: dropItem).height.wrappedValue)
        }
        Log.debug("Dropping item '\(draggedItem.title)' on item '\(dropItem.title)' @ '\(dropLocation)'")
        
        resetEnvironment()
                
        guard let fromSection = Self.findSection(for: draggedItem, in: sections),
              let toSection = Self.findSection(for: dropItem, in: sections) else {
            Log.warning("Missing from or to sections", .dragAndDrop)
            return
        }
        
        sections = Self.makeSections(draggedItem: draggedItem,
                                     fromSection: fromSection,
                                     toItem: dropItem,
                                     toSection: toSection,
                                     dropLocation: dropLocation,
                                     sections: sections)
    }
    
    /// Gets called when an item is dropped over an empty section
    func onDrop(item draggedItem: DDItem, onto dropSection: DDSection) {
        Log.debug("Dropping item '\(draggedItem.title)' on section '\(dropSection.title)'")
        resetEnvironment()
        
        guard let fromSection = Self.findSection(for: draggedItem, in: sections) else {
            Log.warning("Missing from section", .dragAndDrop)
            return
        }
        sections = Self.makeSections(draggedItem: draggedItem,
                                     fromSection: fromSection,
                                     toItem: nil,
                                     toSection: dropSection,
                                     sections: sections)
    }
    
    func onAbort() {
        resetEnvironment()
    }
    
    /// Gets called when an item is deleted
    func delete(item: DDItem) {
        guard var newSection = Self.findSection(for: item, in: sections) else {
            return
        }
        newSection.items.removeAll { $0.id == item.id }
        guard let sectionIndex = sections.firstIndex(where: { $0.id == newSection.id }) else {
            return
        }
        sections[sectionIndex] = newSection
    }
    
    func resetSections(_ sections: [DDSection]) {
        resetEnvironment()
        self.sections = sections
    }
    
    // MARK: Private
    
    /// Calculates where an item should be inserted based on the position of the dragged item over the destination item.
    private func calculateRowDropLocation(y: CGFloat, draggedRowHeight: CGFloat, destinationRowHeight: CGFloat) -> RowDropLocation {
        var center: CGFloat = destinationRowHeight / 2
        if let rowDropArea,
           rowDropArea.dropLocation == .top {
            center = center + draggedRowHeight
        }
        if y <= center {
            return .top
        } else {
            return .bottom
        }
    }
    
    /// Returns the section where the given item is located
    static func findSection(for item: DDItem, in sections: [DDSection]) -> DDSection? {
        for section in sections {
            if (section.items.first { $0.id == item.id } != nil) {
                return section
            }
        }
        return nil
    }
    
    // Builds the list of sections that needs to be displayed
    static func makeSections(draggedItem: DDItem, fromSection: DDSection, toItem: DDItem?, toSection: DDSection, dropLocation: RowDropLocation = .none, sections: [DDSection]) -> [DDSection] {
        if draggedItem.id == toItem?.id {
            return sections
        }
        var resultSections: [DDSection] = []
        for section in sections {
            var newSection: DDSection  = section
            if newSection.id == fromSection.id {
                // Remove the dragged item
                newSection = DDSection(id: newSection.id,
                                     title: newSection.title,
                                     items: newSection.items.filter { $0.id != draggedItem.id }
                )
            }
            if newSection.id == toSection.id {
                // Add the dragged item
                var dropIndex = newSection.items.count
                if let toItem {
                    if let newIndex = newSection.items.firstIndex(where: { $0.id == toItem.id }) {
                        dropIndex = newIndex + (dropLocation == .bottom ? 1 : 0)
                    }
                }
                var newItems = newSection.items
                newItems.insert(draggedItem, at: dropIndex)
                
                newSection = DDSection(id: newSection.id,
                                     title: newSection.title,
                                     items: newItems
                )
            }
            resultSections.append(newSection)
        }
        return resultSections
    }
    
    private func resetEnvironment() {
        rowDropArea = nil
        highlightedEmptySection = nil
        draggedItem = nil
    }
}

// MARK: Preview
extension DragAndDropSectionViewModel {
    static var exampleSections: [DDSection] = [
        DDSection(title: "Numbers", items: [
            DDItem(id: "item1", title: "Item 1"),
            DDItem(id: "item2", title: "Item 2"),
            DDItem(id: "item3", title: "Item 3"),
            DDItem(id: "item4", title: "Item 4")
        ]),
        DDSection(title: "Empty", items: []),
        DDSection(title: "Emojis 😍", items: [
            DDItem(id: "Emo1", title: "Item 🤪"),
            DDItem(id: "Emo2", title: "Item 😂"),
            DDItem(id: "Emo3", title: "Item 😳"),
            DDItem(id: "Emo4", title: "Item 😉")
        ])
    ]
}

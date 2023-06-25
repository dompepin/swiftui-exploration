//
//  SectionViewModel.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2023-06-26.
//

import Foundation

enum RowDropLocation {
    case top
    case bottom
    case unknown
}


struct RowDropLocationViewState {
    let item: Item
    let dropLocation: RowDropLocation
    
    init(item: Item, dropLocation: RowDropLocation) {
        self.item = item
        self.dropLocation = dropLocation
    }
}

class DragAndDropSectionViewModel: ObservableObject {
    // MARK: Properties
    @Published private (set) var sections: [Section]
    @Published private (set) var spacerLocation: RowDropLocationViewState?
    
    // MARK: Lifecycle
    init(sections: [Section]) {
        self.sections = sections
    }
    
    // MARK: Public
    func addDropLocation(to dropItem: Item, dropLocation: RowDropLocation) {
        spacerLocation = RowDropLocationViewState(item: dropItem, dropLocation: dropLocation) // TODO: This should calculate the drop location
    }
    
    func delete(item: Item) {
        guard var newSection = Self.findSection(for: item, in: sections) else {
            return
        }
        newSection.items.removeAll { $0.id == item.id }
        guard let sectionIndex = sections.firstIndex(where: { $0.id == newSection.id }) else {
            return
        }
        sections[sectionIndex] = newSection
    }
    
    func drop(item draggedItem: Item, onto dropItem: Item, dropLocation: RowDropLocation = .unknown) {
        spacerLocation = nil
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
    
    func drop(item draggedItem: Item, onto dropSection: Section) {
        spacerLocation = nil
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
    
    // MARK: Private
    
    static func findSection(for item: Item, in sections: [Section]) -> Section? {
        for section in sections {
            if (section.items.first { $0.id == item.id } != nil) {
                return section
            }
        }
        return nil
    }
    
    static func makeSections(draggedItem: Item, fromSection: Section, toItem: Item?, toSection: Section, dropLocation: RowDropLocation = .unknown, sections: [Section]) -> [Section] {
        if draggedItem.id == toItem?.id {
            return sections
        }
        var resultSections: [Section] = []
        for section in sections {
            var newSection: Section  = section
            if newSection.id == fromSection.id {
                // Remove the dragged item
                newSection = Section(id: newSection.id,
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
                    Log.debugHighlighted("Insert item: '\(draggedItem.title) '\(dropLocation)' '\(toItem.title)' at '\(dropIndex)'")
                }
                var newItems = newSection.items
                newItems.insert(draggedItem, at: dropIndex)
                
                newSection = Section(id: newSection.id,
                                     title: newSection.title,
                                     items: newItems
                )
            }
            resultSections.append(newSection)
        }
        return resultSections
    }
}

extension DragAndDropSectionViewModel {
    static var exampleSections: [Section] = [
        Section(title: "Numbers", items: [
            Item(id: "1", title: "Item 1", category: "Must Do"),
            Item(id: "2", title: "Item 2", category: "Must Do"),
            Item(id: "3", title: "Item 3", category: "Must Do"),
            Item(id: "4", title: "Item 4", category: "Must Do")
        ]),
        Section(title: "Empty", items: []),
        Section(title: "Emojis 😍", items: [
            Item(id: "Emo1", title: "Item 🤪", category: "Not a Chance"),
            Item(id: "Emo2", title: "Item 😂", category: "Not a Chance"),
            Item(id: "Emo3", title: "Item 😳", category: "Not a Chance"),
            Item(id: "Emo4", title: "Item 😉", category: "Not a Chance")
        ])
    ]
}

//
//  Created by Dominic Pepin on 2023-04-16.
//

import SwiftUI
import os.log
import UniformTypeIdentifiers

/// This example looks at dragging and dropping custom objects between difference lists.
/// In order to do so, the Item structure has to be wrapped into a class (ItemDragObject) which has to conform to
///  `NSItemProviderWriting` and `NSItemProviderReading`
///  You also have to define the new object type identifier in your `info.plist`
struct DragAndDropBetweenListsExampleView: View {
    
    // MARK: Properties
    @State var items1 = [
        DDItem(id: "1", title: "Item 1"),
        DDItem(id: "2", title: "Item 2"),
        DDItem(id: "3", title: "Item 3"),
        DDItem(id: "4", title: "Item 4")
    ]
    @State var items2: [DDItem] = []
    @State var items3 = [
        DDItem(id: "Emo1", title: "Item 🤪"),
        DDItem(id: "Emo2", title: "Item 😂"),
        DDItem(id: "Emo3", title: "Item 😳"),
        DDItem(id: "Emo4", title: "Item 😉")
    ]
    
    // MARK: Body
    var body: some View {
        VStack(spacing: Constant.Padding.Custom.outerEdge16) {
            DropList(title: "List 1", items: $items1) { droppedItem, index in
                items1.insert(droppedItem, at: index)
                items2.removeAll { $0 == droppedItem }
                items3.removeAll { $0 == droppedItem }
            }
            DropList(title: "List 2", items: $items2)  { droppedItem, index in
                items1.removeAll { $0 == droppedItem }
                items2.insert(droppedItem, at: index)
                items3.removeAll { $0 == droppedItem }
            }
            DropList(title: "List 3", items: $items3)  { droppedItem, index in
                items1.removeAll { $0 == droppedItem }
                items2.removeAll { $0 == droppedItem }
                items3.insert(droppedItem, at: index)
            }
            Spacer()
        }
        .padding(.top, Constant.Padding.Custom.topEdge16)
        .padding(.bottom, Constant.Padding.Custom.bottomEdge40)
        .navigationBarItems(trailing: EditButton())
        .navigationTitle("Drag and Drop - List")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: DropList

fileprivate struct DropList: View {
    typealias DropAction = ((_ item: DDItem, _ index: Int) -> Void)
    
    // MARK: Properties
    private var title: String
    @Binding private var items: [DDItem]
    private let droppedAction: DropAction
    
    // MARK: Body
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.headline)
            if items.count > 0 {
                List {
                    ForEach(items, id: \.id) { item in
                        ExampleTitleRow(item.title)
                            .listRowSeparator(.hidden)
                        .onDrag {
                            NSItemProvider(object: ItemDragObject(item: item))
                        } preview: {
                            ExampleTitleRow(item.title)
                                .dragPreview()
                        }
                    }
                    .onMove(perform: moveItem)
                    .onInsert(of: [ItemDragObject.typeIdentifier, UTType.text.identifier], perform: dropItem)
                }
                .listStyle(.plain)
            } else {
                EmptyDropArea()
                    .onDrop(of: [ItemDragObject.typeIdentifier, UTType.text.identifier], isTargeted: nil, perform: dropItemInEmptyList)
            }
        }
    }

    // MARK: Lifecycle
    init(title: String, items: Binding<[DDItem]>, droppedAction: @escaping DropAction) {
        self.title = title
        self._items = items
        self.droppedAction = droppedAction
    }
    
    // MARK: Private
    
    private func executeDroppedAction(item: DDItem, index: Int) {
        DispatchQueue.main.async {
            droppedAction(item, index)
        }
    }
    
    func moveItem(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
    }

    func dropItem(at index: Int, _ itemProviders: [NSItemProvider]) {
        for itemProvider in itemProviders {
            if itemProvider.canLoadObject(ofClass: ItemDragObject.self) {
                // An Item was dropped
                _ = itemProvider.loadObject(ofClass: ItemDragObject.self) { itemDragObject, error in
                    if let error = error {
                        Log.error("Failed to load dropped object: '\(error)'")
                    } else if let itemDragObject = itemDragObject as? ItemDragObject {
                        executeDroppedAction(item: itemDragObject.item, index: index)
                    } else {
                        Log.warning("No item object was passed as part of the drop action.", .dragAndDrop)
                    }
                }
            }
            else if itemProvider.canLoadObject(ofClass: String.self) {
                // Some text was dropped (This can happen on a iPad in split view)
                _ = itemProvider.loadObject(ofClass: String.self) { string, error in
                    if let error = error {
                        Log.error("Failed to load dropped string: '\(error)'")
                    } else if let string {
                        executeDroppedAction(item: DDItem(id: UUID().uuidString, title: string), index: index)
                    } else {
                        Log.warning("No string was passed as part of the drop action.", .dragAndDrop)
                    }
                }
            }
            else {
                Log.warning("Drop type not supported", .dragAndDrop)
            }
        }
    }
    
    func dropItemInEmptyList(_ itemProviders: [NSItemProvider]) -> Bool {
        dropItem(at: 0, itemProviders)
        return true
    }
}

// MARK:  Preview

struct DragAndDropPrototype1View_Previews: PreviewProvider {
    static var previews: some View {
        DragAndDropBetweenListsExampleView()
    }
}

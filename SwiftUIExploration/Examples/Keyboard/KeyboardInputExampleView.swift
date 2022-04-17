//
//  KeyboardInputExampleView.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2022-04-10.
//

import SwiftUI

struct KeyboardInputExampleView: View {
    
    @State var name: String = ""
    @State var name2: String = ""
    private enum Field: Int, Hashable {
        case name, name2, nameInToolbar
    }
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack {
            Form {
                TextField("Name 1", text: $name)
                    .onChange(of: name) { newValue in
                        focusedField = .nameInToolbar
                    }
                    .focused($focusedField, equals: .name)
                TextField("Name 2", text: $name)
                    .focused($focusedField, equals: .name2)
            }
            Button("Click me please!") {
                focusedField = .name
            }
            .buttonStyle(ButtonStyle.primary)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack(alignment: .center, spacing: 8) {
                        TextField("Enter your name", text: $name)
                            .textFieldStyle(.roundedBorder)
                            .focused($focusedField, equals: .nameInToolbar)
                        if !name.isEmpty {
                            Button(
                                action: {
                                    name = ""
//                                    focusedField = .name
                                    focusedField = .name2
                                },
                                label: {
                                    Text("Close")
                                }
                            )
                        }
                    }
                }
            }
            Button("Close") {
                focusedField = .name2
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    focusedField = nil
                }
            }
        }
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),to: nil, from: nil, for: nil)
    }
}

struct KeyboardInputExampleView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardInputExampleView()
    }
}

//
//  BottomSheetExamples.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2022-02-14.
//

import SwiftUI
import UICompass

struct BottomSheetExampleView: View {
    
    // MARK: Properties
    
    @State private var isActionSheetPresented: Bool = false
    @State private var isCustomSheetPresented: Bool = false
    
    // MARK: Body
    
    var body: some View {
        ZStack {
            VStack (alignment: .center, spacing: 16) {
                Button("Apple Sheet") {
                    isActionSheetPresented.toggle()
                }
                Button("Custom Sheet") {
                    isCustomSheetPresented.toggle()
                }
            }
        }
        .customSheet(isPresented: $isCustomSheetPresented) {
             return DocumentPickerExampleView(isPresented: $isCustomSheetPresented)
        }
        .actionSheet(isPresented: $isActionSheetPresented) {
            return ActionSheet(title: Text("Select your attachment"),
                               buttons: [
                                .default(Text("Button 1")),
                                .default(Text("Button 2")),
                                .default(Text("Button 3")),
                                .cancel(Text("Cancel"))
                               ])
            
        }
    }
}

// MARK: Preview

struct BottomSheetExampleView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetExampleView()
    }
}

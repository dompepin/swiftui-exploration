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
        ScrollView {
            VStack (alignment: .leading, spacing: 16) {
                EyebrowText("Apple Examples")
                Button {
                    isActionSheetPresented.toggle()
                } label: {
                    Text("Action Sheet")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(ButtonStyle.primary)
                
                
                EyebrowText("Custom Examples")
                    .padding(.top, 16)
                Button {
                    isCustomSheetPresented.toggle()
                } label: {
                    Text("Bottom Sheet")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(ButtonStyle.primary)
                Spacer()
            }
            .padding()
        }
        .bottomSheet(isPresented: $isCustomSheetPresented, safeAreaColor: Color.white) {
            return DocumentPickerExampleView(isPresented: $isCustomSheetPresented)
        }
        .actionSheet(isPresented: $isActionSheetPresented) {
            return ActionSheet(title: Text("Select your attachment"),
                               buttons: [
                                .default(Text("Take a photo")),
                                .default(Text("Choose a document")),
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

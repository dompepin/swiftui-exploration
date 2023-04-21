//
//  ButtonsExampleView.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2022-02-21.
//

import SwiftUI
import UICompass

struct ButtonsExampleView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                EyebrowText("Filled button")
                Button {} label: {
                    Text("Enabled button")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(ButtonStyle.secondary)
                
                Button {} label: {
                    Text("Disabled button")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(ButtonStyle.primary)
                .disabled(true)
                
                EyebrowText("Outline button")
                    .padding(.top, 16)
                Button {} label: {
                    Text("Enabled button")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(ButtonStyle.secondary)
                
                Button {} label: {
                    Text("Disabled button")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(ButtonStyle.secondary)
                .disabled(true)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Buttons")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: Preview

struct ButtonsExamplesView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonsExampleView()
    }
}




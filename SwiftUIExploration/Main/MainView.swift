//
//  ContentView.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2022-02-12.
//

import SwiftUI

struct MainView: View {
    
    // MARK: Body
    
    var body: some View {
        NavigationView {
            List {
                MenuItemViewLink("Bottom sheets") {
                    BottomSheetExampleView()
                }
                MenuItemViewLink("Buttons") {
                    ButtonsExampleView()
                }
                MenuItemViewLink("Drag and drop") {
                    DragAndDropExamplesView()
                }
                MenuItemViewLink("Pull-to-refresh") {
                    PullToRefreshExamplesView()
                }
                MenuItemViewLink("Pulsing activity indicators") {
                    PulsingActivityIndicatorExampleView()
                }
                MenuItemViewLink("Toggles") {
                    TogglesExampleView()
                }
            }
            .listStyle(.plain)
            .navigationTitle("Examples")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: Preview

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

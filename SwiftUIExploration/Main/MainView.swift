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
                MenuItemViewLink("Bottom Sheets") {
                    BottomSheetExampleView()
                }
                MenuItemViewLink("Buttons") {
                    ButtonsExampleView()
                }
                MenuItemViewLink("Drag and Drop - List") {
                    DragAndDropBetweenListsExampleView()
                }
                MenuItemViewLink("Drag and Drop - VStack") {
                    DragAndDropVStackExampleView()
                }
                MenuItemViewLink("Pull-to-refresh - Apple") {
                    ApplePullToRefreshExampleView()
                }
                MenuItemViewLink("Pull-to-refresh - Custom") { // TODO: Move to sub view so I can have both pull to refresh independent.
                    CustomPullToRefreshExampleView()
                }
                MenuItemViewLink("Pulsing Activity Indicators") {
                    PulsingActivityIndicatorExampleView()
                }
                MenuItemViewLink("Toggles") {
                    TogglesExampleView()
                }
            }
            .listStyle(.plain)
            .navigationTitle("Examples")
            .navigationBarTitleDisplayMode(.large
            )
        }
    }
}

// MARK: Preview

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

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
                MenuItemViewLink("Pulsing Activity Indicators") {
                    PulsingActivityIndicatorExampleView()
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

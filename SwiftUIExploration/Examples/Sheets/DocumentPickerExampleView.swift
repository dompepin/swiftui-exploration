//
//  DocumentPickerExampleView.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2022-02-19.
//

import SwiftUI

struct DocumentPickerExampleView: View {
    
    // MARK: Properties
    
    @Binding private var isPresented: Bool
    
    // MARK: Body
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Button {
                    isPresented = false
                } label: {
                    Image(systemName: "xmark")
                        .padding()
                }
            }
            VStack(alignment: .leading, spacing: 0) {
                Text("Select your attachment")
                    .font(.title2)
                    .padding()
                rowButton("Take a photo", systemImage: "camera")
                rowButton("Choose a document", systemImage: "doc")
            }
        }
        .padding(.bottom, 8)
        .background(Color.white)
        .cornerRadius(16, corners: [.topLeft, .topRight])
        .shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: -10)
    }
    
    // MARK: Lifecycle
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    // MARK: Private Views
    
    func closeButton() -> some View {
        Button {
            isPresented = false
        } label: {
            Image(systemName: "xmark")
                .padding()
        }
        .buttonStyle(.plain)
    }
    
    func rowButton(_ title: String, systemImage: String) -> some View {
        VStack(alignment: .leading, spacing: 0){
            Divider()
                .padding(.leading, 16)
            Button {
                isPresented = false
            } label: {
                HStack (alignment: .center, spacing: 8) {
                    Image(systemName: systemImage)
                    Text(title)
                    Spacer()
                }
                .padding()
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: Preview

struct DocumentPicker_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            DocumentPickerExampleView(isPresented: .constant(false))
        }
        .background(Color.white)
        .previewLayout(.fixed(width: 400, height: 200))
    }
}

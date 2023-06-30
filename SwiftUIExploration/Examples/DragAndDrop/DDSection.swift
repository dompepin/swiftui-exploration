//
//  DDSection.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2023-06-30.
//

import Foundation

struct DDSection: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var items: [DDItem]
}

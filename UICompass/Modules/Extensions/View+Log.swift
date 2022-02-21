//
//  View+LogExtensions.swift
//  UICompass
//
//  Created by Dominic Pepin on 2022-02-19.
//

import Foundation
import SwiftUI

//TODO: Use os_log
public extension View {

    /// Logs a message to the console
    func log(_ message: String) -> some View {
        NSLog(message)
        return self
    }
}

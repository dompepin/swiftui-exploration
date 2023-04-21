//
//  Logger+extensions.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2023-04-18.
//

import Foundation
import os.log

public extension Logger {
    static let defaultSubSystem = "com.dompepin.swiftuiexploration"
    static let `default` = Logger(subsystem: defaultSubSystem, category: "default")
    static let dragAndDrop = Logger(subsystem: defaultSubSystem, category: "Drag and drop")
    static let pullToRefresh = Logger(subsystem: defaultSubSystem, category: "Pull-to-refresh")
}

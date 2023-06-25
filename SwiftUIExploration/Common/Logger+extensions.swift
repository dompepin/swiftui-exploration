//
//  Logger+extensions.swift
//  SwiftUIExploration
//
//  Created by Dominic Pepin on 2023-04-18.
//

import Foundation
import os.log

var Log: CustomLogger = CustomLogger()

public extension OSLog {
    static let subsystem = "dompepin.com.swiftuiexploration"
    
    static let `default` = OSLog(subsystem: subsystem, category: "Default")
    static let viewLifecycle = OSLog(subsystem: subsystem, category: "View Lifecycle")
    static let dragAndDrop = OSLog(subsystem: subsystem, category: "Drag and Drop")
    static let pullToRefresh = OSLog(subsystem: subsystem, category: "Pull-to-refresh")
}

enum LogLevel {
    case debug
    case debugHighlighted
    case info
    case warning
    case error
    case fatal
    
    var logPrefix: String {
        switch self {
        case .debug:
            return "⚙️ Debug - "
        case .debugHighlighted:
            return "🔴🟠🟢🔵🟣🟤 Debug - "
        case .info:
            return "ℹ️ Info - "
        case .warning:
            return "⚠️ Warning - "
        case .error:
            return "❌ Error - "
        case .fatal:
            return "❌❌❌ Fatal - "
        }
    }
    
    var osLogType: OSLogType {
        switch self {
        case .debug:
            return .debug
        case .debugHighlighted:
            return .debug
        case .info:
            return.info
        case .warning:
            return .error
        case .error:
            return .error
        case .fatal:
            return .fault
        }
    }
}

// Note: We are using os_log because there is currently no way to wrap Logger calls: https://stackoverflow.com/a/65623070/3391404
class CustomLogger {
    func debug(_ message: String, _ category: OSLog = .default) {
        #if DEBUG
        log(message, level: .debug, category: category)
        #endif
    }
    
    func debugHighlighted(_ message: String, _ category: OSLog = .default) {
        #if DEBUG
        log(message, level: .debugHighlighted, category: category)
        #endif
    }

    func info(_ message: String, _ category: OSLog = .default) {
        log(message, level: .info, category: category)
    }

    func warning(_ message: String, _ category: OSLog = .default) {
        log(message, level: .warning, category: category)
    }

    func error(_ message: String, _ category: OSLog = .default) {
        log(message, level: .error, category: category)
    }

    func fatal(_ message: String, _ category: OSLog = .default) {
        log(message, level: .fatal, category: category)
    }

    private func log(_ message: String, level: LogLevel, category: OSLog) {
        os_log("%{public}@", log: category, type: level.osLogType, "\(level.logPrefix)\(message)")
    }
}

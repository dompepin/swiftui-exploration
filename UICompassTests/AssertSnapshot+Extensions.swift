//
//  CustomAssertSnapshot.swift
//  UICompassTests
//
//  Created by Dominic Pepin on 2022-03-12.
//

import XCTest
import SnapshotTesting

/// Asserts that a given value matches a reference on disk.
///
///  Note: This was created because we cannot set the snapshotDirectory from the default assertSnapshot() method
///
/// - Parameters:
///   - value: A value to compare against a reference.
///   - snapshotting: A strategy for serializing, deserializing, and comparing values.
///   - name: An optional description of the snapshot.
///   - recording: Whether or not to record a new reference.
///   - timeout: The amount of time a snapshot must be generated in.
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - testName: The name of the test in which failure occurred. Defaults to the function name of the test case in which this function was called.
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
public func uiCompassAssertSnapshot<Value, Format>(
    matching value: @autoclosure () throws -> Value,
    as snapshotting: Snapshotting<Value, Format>,
    named name: String? = nil,
    record recording: Bool = false,
    timeout: TimeInterval = 5,
    file: StaticString = #file,
    testName: String = #function,
    line: UInt = #line) {
        
        let failure = verifySnapshot(
            matching: try value(),
            as: snapshotting,
            named: name,
            record: recording,
            snapshotDirectory: snapshotDirectory(file: file),
            timeout: timeout,
            file: file,
            testName: testName,
            line: line
        )
        guard let message = failure else { return }
        XCTFail(message, file: file, line: line)
    }


/// Create a snapshotDirectory based on the location of this file.
///
/// - Parameters:
///   - file: The test file that called the snapshot test. Will be used to create a sub directory where all the snapshots will be stored.
fileprivate func snapshotDirectory(file: StaticString) -> String? {
    let fileUrl = URL(fileURLWithPath: "\(file)", isDirectory: false)
    let fileName = fileUrl.deletingPathExtension().lastPathComponent
    
    return URL(string: #file)?
        .deletingLastPathComponent()
        .appendingPathComponent("__Snapshots__")
        .appendingPathComponent(fileName)
        .absoluteString
}

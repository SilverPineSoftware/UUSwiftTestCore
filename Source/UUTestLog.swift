//
//  UUTestLog.swift
//  UUSwiftTestCore
//
//  Created by Ryan DeVore on 12/22/24.
//

import Foundation

fileprivate let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
fileprivate var formatter: DateFormatter
{
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat
    formatter.timeZone = .current
    formatter.locale = .current
    formatter.calendar = Calendar(identifier: .gregorian)
    return formatter
}

public func UUTestLog(tag: String, message: String)
{
    let timestamp = formatter.string(from: Date())
    NSLog("\(timestamp) TEST \(tag) \(message)")
}

public func UUTestLog(_ message: String)
{
    UUTestLog(tag: "UUTestLog", message: message)
}

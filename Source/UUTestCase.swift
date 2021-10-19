//
//  UUTestCase.swift
//  UUSwiftTestCore
//
//  Created by Ryan DeVore on 10/19/21.
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

import XCTest
import UUSwiftCore

public extension XCTestCase
{
    func uuExpectationForMethod(
        function : NSString = #function,
        tag : NSString = "") -> XCTestExpectation
    {
        return expectation(description: "_\(function)_\(tag)_")
    }
    
    func uuWaitForExpectations(_ timeout: TimeInterval = 60)
    {
        waitForExpectations(timeout: timeout)
        { (err: Error?) in
            if (err != nil)
            {
                XCTFail("Failed waiting for expectation, error: \(err!)")
            }
        }
    }
    
    func uuLogBeginTest(function : NSString = #function)
    {
        UUDebugLog("\n\n******************** BEGIN TEST \(function) ********************\n\n")
    }
    
    func uuLogEndTest(function : NSString = #function)
    {
        UUDebugLog("\n\n******************** END TEST \(function) ********************\n\n")
    }
    
    func uuRandomWord(_ length: Int) -> String
    {
        let sb = NSMutableString()
        
        while (sb.length < length)
        {
            let b = UURandom.randomUInt8()
            if (b >= 65 && b <= 90) || (b >= 97 && b <= 122) // A-Z or a-z
            {
                let u = UnicodeScalar(b)
                let c = Character(u)
                sb.append(String(c))
            }
        }
        
        return sb as String
    }
    
    func uuRandomWords(_ maxNumberOfWords: Int, _ maxWordLength: Int) -> String
    {
        let sb = NSMutableString()
        
        let words = UURandom.randomUInt32(low: 0, high: UInt32(maxNumberOfWords))
        var i = 0
        while (i < words)
        {
            sb.append(uuRandomWord(maxWordLength))
            sb.append(" ")
            i = i + 1
        }
        
        return sb as String
    }
}

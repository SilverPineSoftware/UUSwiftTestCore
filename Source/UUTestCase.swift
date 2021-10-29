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

public extension XCTestCase
{
    func uuExpectationForMethod(
        function : String = #function,
        tag : String = "") -> XCTestExpectation
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
    
    func uuLogBeginTest(function: String = #function)
    {
        NSLog("\n\n******************** BEGIN TEST \(function) ********************\n\n")
    }
    
    func uuLogEndTest(function: String = #function)
    {
        NSLog("\n\n******************** END TEST \(function) ********************\n\n")
    }
}

// MARK: Random helpers from UUSwiftCore
public extension XCTestCase
{
    // NOTE - Some of these are copied from UURandom in UUSwiftCore.  We can't reference
    // UUSwiftCore because it creates circular dependencies in some cases.
    
    func uuRandomUInt32() -> UInt32
    {
        return arc4random()
    }
    
    func uuRandomUInt32(low: UInt32, high: UInt32) -> UInt32
    {
        var l = low
        var h = high
        if (low > high)
        {
            let tmp = l
            l = h
            h = tmp
        }
        
        let range = h - l + 1
        let rand = arc4random_uniform(range)
        return (l + rand)
    }
    
    func uuRandomBool() -> Bool
    {
        return uuRandomUInt32() % 2 == 0
    }
    
    func uuRandomBytes(length: Int) -> Data
    {
        guard let buffer = NSMutableData(length: length) else
        {
            return Data()
        }
        
        let result = SecRandomCopyBytes(kSecRandomDefault, length, buffer.mutableBytes)
        if (result != 0)
        {
            return Data()
        }
        
        return buffer as Data
    }
    
    func uuRandomUInt8() -> UInt8
    {
        return UInt8(uuRandomUInt32() & 0x000000FF)
    }
}

//MARK: Random Test data helpers
public extension XCTestCase
{
    func uuRandomWord(_ length: Int) -> String
    {
        let sb = NSMutableString()
        
        while (sb.length < length)
        {
            let b = uuRandomUInt8()
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
        
        let words = uuRandomUInt32(low: 0, high: UInt32(maxNumberOfWords))
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

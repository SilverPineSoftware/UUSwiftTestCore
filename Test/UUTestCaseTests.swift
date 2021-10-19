//
//  UUTestCaseTests.swift
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
@testable import UUSwiftTestCore

class UUTestCaseExtesionTests: XCTestCase
{
    func testXCTestCaseExtensionMethods()
    {
        uuLogBeginTest()
        
        let exp = uuExpectationForMethod()
        
        DispatchQueue.main.async
        {
            exp.fulfill()
        }
        
        uuWaitForExpectations()
        uuLogEndTest()
    }
    
    func testRandomWords()
    {
        let a = uuRandomWord(20)
        XCTAssertNotNil(a)
        UUDebugLog("\(a)")
        
        let b = uuRandomWords(5, 10)
        XCTAssertNotNil(b)
        UUDebugLog("\(b)")
    }
}

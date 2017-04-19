//
//  TestFrameworkTests.swift
//  TestFrameworkTests
//
//  Created by Jerry Mayers on 4/19/17.
//  Copyright © 2017 Mobelux. All rights reserved.
//

import XCTest
@testable import TestFramework

class TestFrameworkTests: XCTestCase {
    
    func testLingoBundle() {
        XCTAssert(Lingo.Test.title == "TestFrameworkTests", "Test bundle localized string incorrect")
        XCTAssert(TestFramework.Lingo.Test.title == "TestFramework", "Framework bundle localized string incorrect")
    }
    
}

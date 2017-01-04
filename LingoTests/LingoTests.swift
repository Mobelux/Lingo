//
//  LingoTests.swift
//  LingoTests
//
//  Created by Jerry Mayers on 1/3/17.
//  Copyright © 2017 Mobelux. All rights reserved.
//

import XCTest

class LingoTests: XCTestCase {

    func testStringLowercase() {
        let originalString0 = "HELLO WORLD"
        let originalString1 = "hello world"
        let originalString2 = "Hello World"

        let lowerCase0 = originalString0.lowercaseFirstCharacter()
        let lowerCase1 = originalString1.lowercaseFirstCharacter()
        let lowerCase2 = originalString2.lowercaseFirstCharacter()

        XCTAssert(lowerCase0 == "hELLO WORLD", "Not lowercased properly")
        XCTAssert(lowerCase1 == originalString1, "Not lowercased properly")
        XCTAssert(lowerCase2 == "hello World", "Not lowercased properly")
    }

    func testStructGeneration() {
        let keys = ["Lingo.Title", "Lingo.Body", "Flair.Title", "MONK.Title"]
        let structs = StructGenerator.generate(keys: keys)
        XCTAssert(structs.count == 3, "Incorrect # of structs created")

        // order is alphabetical
        let flair = structs[0]
        XCTAssert(flair.name == "Flair", "Name incorrect")
        XCTAssert(flair.keys.count == 1, "Incorrect number of keys")
        XCTAssert(flair.keys[0] == "Title", "First key wrong")

        let lingo = structs[1]
        XCTAssert(lingo.name == "Lingo", "Name incorrect")
        XCTAssert(lingo.keys.count == 2, "Incorrect number of keys")
        XCTAssert(lingo.keys[0] == "Body", "First key wrong")
        XCTAssert(lingo.keys[1] == "Title", "Second key wrong")

        let monk = structs[2]
        XCTAssert(monk.name == "MONK", "Name incorrect")
        XCTAssert(monk.keys.count == 1, "Incorrect number of keys")
        XCTAssert(monk.keys[0] == "Title", "First key wrong")
    }

    func testSwiftGeneration() {
        let keys = ["Lingo.Title", "Lingo.Body", "Flair.Title", "MONK.Title"]
        let structs = StructGenerator.generate(keys: keys)
        let swift = SwiftGenerator.generate(structs: structs)
        let expectedSwiftURL = Bundle(for: LingoTests.self).url(forResource: "generated_swift", withExtension: "txt")!
        let expectedSwift = try! String(contentsOf: expectedSwiftURL)

        XCTAssert(swift == expectedSwift, "Generated Swift doesn't match expected")
    }

    func testLocalizedStringParsing() {
        let url = Bundle(for: LingoTests.self).url(forResource: "Localizeable", withExtension: "strings")!
        let strings = try! String(contentsOf: url)

        let keys = KeyGenerator.generate(localizationFileContents: strings)

        XCTAssert(keys.count == 3, "Incorrect keys count")
        XCTAssert(keys[0] == "Lingo.WasHisName", "Incorrect key")
        XCTAssert(keys[1] == "Lingo.Title", "Incorrect key")
        XCTAssert(keys[2] == "Flair.Description", "Incorrect key")
    }
    
}

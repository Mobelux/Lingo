//
//  LingoTests.swift
//  LingoTests
//
//  Created by Jerry Mayers on 1/3/17.
//  Copyright © 2017 Mobelux. All rights reserved.
//

import XCTest

class LingoTests: XCTestCase {

    let inputURL = Bundle(for: LingoTests.self).url(forResource: "Localizeable", withExtension: "strings")!
    let expectedSwiftURL = Bundle(for: LingoTests.self).url(forResource: "generated_swift", withExtension: "txt")!
    let outputURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("output.swift")

    override func tearDown() {
        super.tearDown()
        try? FileManager.default.removeItem(at: outputURL)
    }

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
        let keys = ["Lingo.Title", "Lingo.WasHisName", "Flair.Description", "MONK.Title"]
        let structs = StructGenerator.generate(keys: keys)
        let swift = SwiftGenerator.generate(structs: structs)
        let expectedSwift = try! String(contentsOf: expectedSwiftURL)

        XCTAssert(swift == expectedSwift, "Generated Swift doesn't match expected")
    }

    func testLocalizedStringParsing() {
        let strings = try! String(contentsOf: inputURL)

        let keys = KeyGenerator.generate(localizationFileContents: strings)

        XCTAssert(keys.count == 4, "Incorrect keys count")
        XCTAssert(keys[0] == "Lingo.WasHisName", "Incorrect key")
        XCTAssert(keys[1] == "Lingo.Title", "Incorrect key")
        XCTAssert(keys[2] == "Flair.Description", "Incorrect key")
        XCTAssert(keys[3] == "MONK.Title", "Incorrect key")
    }

    func testArgumentParsing() {
        let rawArguments0 = ["--Input", "~/Desktop", "--output", "~/Desktop/output.swift"]
        let rawArguments1 = ["--output", "~/Desktop/output.swift", "--Input", "~/Desktop"]
        let rawArguments2 = ["--output", "~/Desktop/output.swift"]

        let arguments0 = ArgumentsParser.parse(arguments: rawArguments0)
        let arguments1 = ArgumentsParser.parse(arguments: rawArguments1)
        let arguments2 = ArgumentsParser.parse(arguments: rawArguments2)

        XCTAssertNotNil(arguments0, "We should have arguments")
        XCTAssertNotNil(arguments1, "We should have arguments")
        XCTAssertNil(arguments2, "We should not have arguments")
    }

    func testFileHandling() {
        let arguments = Arguments(inputURL: inputURL, outputURL: outputURL)

        let fileData = FileHandler.readFiles(from: arguments)
        XCTAssertNotNil(fileData, "Couldn't read files")

        let expectedSwift = try! String(contentsOf: expectedSwiftURL)
        do {
            try FileHandler.writeOutput(swift: expectedSwift, to: arguments)
        } catch let error {
            XCTAssert(false, error.localizedDescription)
        }
    }

    func testEverything() {
        let arguments = ["--input", inputURL.path, "--output", outputURL.path]
        let success = Lingo.run(withArguments: arguments)
        XCTAssert(success, "Did not succeed")

        let expectedSwift = try! String(contentsOf: expectedSwiftURL)
        let generatedSwift = try? String(contentsOf: outputURL)
        XCTAssertNotNil(generatedSwift, "Didn't generate Swift")
        if let generatedSwift = generatedSwift {
            XCTAssert(generatedSwift == expectedSwift, "Generated Swift doesn't match expected")
        }
    }
}

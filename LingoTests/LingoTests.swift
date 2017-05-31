//
//  LingoTests.swift
//  LingoTests
//
//  MIT License
//
//  Copyright (c) 2017 Mobelux
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import XCTest

class LingoTests: XCTestCase {

    let inputURL = Bundle(for: LingoTests.self).url(forResource: "Localizeable", withExtension: "strings")!
    let expectedSwiftURL = Bundle(for: LingoTests.self).url(forResource: "Expected", withExtension: "txt")!
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
        let keyValues = ["Lingo.Title": "Blingo", "Lingo.Body": "Was his name oh!", "Flair.Title": "Straight sketchin'", "MONK.Title": "So Peaceful"]
        let structs = StructGenerator.generate(keyValues: keyValues)
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
        let keyValues = ["Lingo.Title": "\"Lingo\"", "Lingo.WasHisName": "\"Oh\"", "Flair.Description": "\"As in pieces of flair from Office Space the movie\"", "MONK.Title": "\"A networking lib\""]
        
        let structs = StructGenerator.generate(keyValues: keyValues)
        let swift = SwiftGenerator.generate(structs: structs, keyValues: keyValues)
        let expectedSwift = try! String(contentsOf: expectedSwiftURL)

        XCTAssert(swift == expectedSwift, "Generated Swift doesn't match expected")
    }

    func testLocalizedStringParsing() {
        let strings = try! String(contentsOf: inputURL)

        let keys = Array(KeyGenerator.generate(localizationFileContents: strings).keys).sorted()

        XCTAssert(keys.count == 4, "Incorrect keys count")
        XCTAssert(keys[0] == "Flair.Description", "Incorrect key")
        XCTAssert(keys[1] == "Lingo.Title", "Incorrect key")
        XCTAssert(keys[2] == "Lingo.WasHisName", "Incorrect key")
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
        measure {
            let success = Lingo.run(withArguments: arguments)
            XCTAssert(success, "Did not succeed")

            let expectedSwift = try! String(contentsOf: self.expectedSwiftURL)
            let generatedSwift = try? String(contentsOf: self.outputURL)
            XCTAssertNotNil(generatedSwift, "Didn't generate Swift")
            if let generatedSwift = generatedSwift {
                XCTAssert(generatedSwift == expectedSwift, "Generated Swift doesn't match expected")
            }
        }
    }
}

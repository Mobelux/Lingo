//
//  CoreTests.swift
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
@testable import LingoCore

class CoreTests: XCTestCase {
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
        let swift = SwiftGenerator.generate(structs: structs, keyValues: keyValues, packageName: nil)

        XCTAssert(swift == CoreTests.expectedText, "Generated Swift doesn't match expected")
    }

    func testLocalizedStringParsing() {
        let strings = CoreTests.localizableStrings

        let keys = Array(KeyGenerator.generate(localizationFileContents: strings).keys).sorted()

        XCTAssert(keys.count == 4, "Incorrect keys count")
        XCTAssert(keys[0] == "Flair.Description", "Incorrect key")
        XCTAssert(keys[1] == "Lingo.Title", "Incorrect key")
        XCTAssert(keys[2] == "Lingo.WasHisName", "Incorrect key")
        XCTAssert(keys[3] == "MONK.Title", "Incorrect key")
    }

    func testFileHandling() {
        do {
            let inputURL = try CoreTests.write(CoreTests.localizableStrings, toTemp: "input")
            let fileData = FileHandler.readFiles(inputPath: inputURL.path, outputPath: outputURL.path)
            XCTAssertNotNil(fileData, "Couldn't read files")

            try FileHandler.writeOutput(swift: CoreTests.expectedText, to: outputURL.path)
        } catch let error {
            XCTAssert(false, error.localizedDescription)
        }
    }

    func testEverything() {
        let url = try! CoreTests.write(CoreTests.localizableStrings, toTemp: "input")
        measure {
            do {
                try LingoCore.run(input: url.path, output: outputURL.path, packageName: nil)

                let expectedSwift = CoreTests.expectedText
                let generatedSwift = try? String(contentsOf: self.outputURL)
                XCTAssertNotNil(generatedSwift, "Didn't generate Swift")
                if let generatedSwift = generatedSwift {
                    XCTAssert(generatedSwift == expectedSwift, "Generated Swift doesn't match expected")
                }
            } catch {
                XCTAssert(false, error.localizedDescription)
            }
        }
    }
}

private extension CoreTests {
    static func write(_ text: String, toTemp fileName: String) throws -> URL {
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        try text.write(to: url, atomically: true, encoding: .utf8)

        return url
    }

    static var expectedText: String {
        return """
        // This file is autogenerated by Lingo from your localized strings file.\n\nimport Foundation\n\nprivate class BundleLocator {\n    static let bundle: Bundle = {\n        #if SWIFT_PACKAGE\n            return Bundle.module\n        #else\n            return Bundle(for: BundleLocator.self)\n        #endif\n    }()\n}\n\npublic struct Lingo {\n    public struct Flair {\n        /// \"As in pieces of flair from Office Space the movie\"\n        public static let description = NSLocalizedString(\"Flair.Description\", bundle: BundleLocator.bundle, comment: \"\")\n    }\n\n    public struct Lingo {\n        /// \"Lingo\"\n        public static let title = NSLocalizedString(\"Lingo.Title\", bundle: BundleLocator.bundle, comment: \"\")\n        /// \"Oh\"\n        public static let wasHisName = NSLocalizedString(\"Lingo.WasHisName\", bundle: BundleLocator.bundle, comment: \"\")\n    }\n\n    public struct MONK {\n        /// \"A networking lib\"\n        public static let title = NSLocalizedString(\"MONK.Title\", bundle: BundleLocator.bundle, comment: \"\")\n    }\n}\n
        """
    }

    static var localizableStrings: String {
        return """
            "Lingo.WasHisName" = "Oh";
            "Lingo.Title" = "Lingo";

            "Flair.Description" = "As in pieces of flair from Office Space the movie";

            "MONK.Title" = "A networking lib";
        """
    }
}

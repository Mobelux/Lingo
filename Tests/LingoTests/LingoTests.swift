//
//  LingoTests.swift
//
//  MIT License
//
//  Copyright (c) 2024 Mobelux
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

import ArgumentParser
import XCTest

class LingoTests: XCTestCase {
    static let localizableStrings = """
        "Lingo.WasHisName" = "Oh";
        """

    func testCLI() throws {
        let inputURL = try Self.write(Self.localizableStrings, toTemp: "Localizable.strings")
        let outputURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("Lingo.swift")
        let command = "lingo --input \(inputURL.path()) --output \(outputURL.path()) --package-name Localization"
        try AssertExecuteCommand(command: command)
    }

    func testMissingOptionsFail() throws {
        let command = "lingo --package-name Localization"
        try AssertExecuteCommand(command: command, exitCode: ExitCode(64))
    }
}

private extension LingoTests {
    static func write(_ text: String, toTemp fileName: String) throws -> URL {
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        try text.write(to: url, atomically: true, encoding: .utf8)

        return url
    }
}

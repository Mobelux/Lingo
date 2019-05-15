//
//  Lingo.swift
//  Lingo
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

import Foundation

public struct Lingo {
    public static func run(withArguments rawArguments: [String]) throws {
        guard let arguments = ArgumentsParser.parse(arguments: rawArguments) else {
            throw LingoError.custom("Usage: --input <path to Localizable.strings file> --output <path including file name to write Swift to>")
        }

        guard let fileData = FileHandler.readFiles(from: arguments) else {
            throw LingoError.custom("Couldn't read files. Did you type your arguments incorrectly?")
        }

        let keyValues = KeyGenerator.generate(localizationFileContents: fileData.input)
        let generatedStructs = StructGenerator.generate(keyValues: keyValues)
        let swift = SwiftGenerator.generate(structs: generatedStructs, keyValues: keyValues)

        try FileHandler.writeOutput(swift: swift, to: arguments)
    }
}

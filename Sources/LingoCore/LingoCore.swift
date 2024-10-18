//
//  LingoCore.swift
//  LingoCore
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

/// The main entry point for LingoCore.
public struct LingoCore {
    /// Runs LingoCore.
    ///
    /// - Parameters:
    ///  - input: The path to the Localizable.strings file.
    ///  - output: The path to write the generated Swift file to.
    ///  - packageName: The name of the SPM package which `Lingo.swift` will belong to.
    ///  - writeAtomically: If `true`, the generated Swift file is first written to an auxiliary
    ///  file, and then the auxiliary file is renamed to `output`. The `true` option guarantees that
    ///  `output`, if it exists at all, won’t be corrupted even if the system should crash during 
    ///  writing.
    public static func run(
        input: String,
        output: String,
        packageName: String?,
        writeAtomically: Bool = true
    ) throws {
        guard let fileData = FileHandler.readFiles(inputPath: input, outputPath: output) else {
            throw LingoError.custom("Couldn't read files. Did you type your arguments incorrectly?")
        }

        let keyValues = KeyGenerator.generate(localizationFileContents: fileData.input)
        let generatedStructs = StructGenerator.generate(keyValues: keyValues)
        let swift = SwiftGenerator.generate(structs: generatedStructs, keyValues: keyValues, packageName: packageName)

        try FileHandler.writeOutput(swift: swift, to: output, atomically: writeAtomically)
    }
}

//
//  FileHandler.swift
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

struct FileData {
    let input: String
    let output: String?
}

struct FileHandler {
    static func readFiles(inputPath: String, outputPath: String) -> FileData? {
        let outputFileData = try? String(contentsOfFile: outputPath)
        if let inputFileData = try? String(contentsOfFile: inputPath) {
            return FileData(input: inputFileData, output: outputFileData)
        } else {
            return nil
        }
    }

    static func writeOutput(swift: String, to outputPath: String, atomically: Bool = true) throws {
        let doWrite = {
            try swift.write(toFile: outputPath, atomically: atomically, encoding: .utf8)
        }

        if let existingSwift = try? String(contentsOfFile: outputPath)  {
            // Only write if there was a change
            if existingSwift != swift {
                try doWrite()
            }
        } else {
            try doWrite()
        }
    }
}

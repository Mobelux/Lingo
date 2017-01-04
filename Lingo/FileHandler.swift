//
//  FileHandler.swift
//  Lingo
//
//  Created by Jerry Mayers on 1/4/17.
//  Copyright © 2017 Mobelux. All rights reserved.
//

import Foundation

struct FileData {
    let input: String
    let output: String?
}

struct FileHandler {
    static func readFiles(from arguments: Arguments) -> FileData? {
        let outputFileData = try? String(contentsOf: arguments.outputURL)
        if let inputFileData = try? String(contentsOf: arguments.inputURL) {
            return FileData(input: inputFileData, output: outputFileData)
        } else {
            return nil
        }
    }

    static func writeOutput(swift: String, to arguments: Arguments) throws {
        let doWrite = {
            try swift.write(to: arguments.outputURL, atomically: true, encoding: .utf8)
        }

        if let fileData = readFiles(from: arguments), let existingSwift = fileData.output {
            // Only write if there was a change
            if existingSwift != swift {
                try doWrite()
            }
        } else {
            try doWrite()
        }
    }
}

//
//  Lingo.swift
//  Lingo
//
//  Created by Jerry Mayers on 1/4/17.
//  Copyright © 2017 Mobelux. All rights reserved.
//

import Foundation

struct Lingo {
    static func run(withArguments rawArguments: [String]) -> Bool {
        guard let arguments = ArgumentsParser.parse(arguments: rawArguments) else {
            print("Usage: --input <path to Localizable.strings file> --output <path including file name to write Swift to>")
            return false
        }

        guard let fileData = FileHandler.readFiles(from: arguments) else {
            print("Couldn't read files. Did you type your arguments incorrectly?")
            return false
        }

        let keys = KeyGenerator.generate(localizationFileContents: fileData.input)
        let generatedStructs = StructGenerator.generate(keys: keys)
        let swift = SwiftGenerator.generate(structs: generatedStructs)
        do {
            try FileHandler.writeOutput(swift: swift, to: arguments)
            return true
        } catch let error {
            print("Error writing output: \(error.localizedDescription)")
            return false
        }
    }
}

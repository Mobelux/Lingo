//
//  ArgumentsParser.swift
//  Lingo
//
//  Created by Jerry Mayers on 1/4/17.
//  Copyright © 2017 Mobelux. All rights reserved.
//

import Foundation

struct Arguments {
    let inputURL: URL
    let outputURL: URL
}

struct ArgumentsParser {
    static func parse(arguments: [String]) -> Arguments? {
        let lowercaseArguments = arguments.map({ $0.lowercased() })
        guard let inputCommandIndex = lowercaseArguments.index(of: "--input"),
            let outputCommandIndex = lowercaseArguments.index(of: "--output"),
            inputCommandIndex <= arguments.count - 2, outputCommandIndex <= arguments.count - 2,
            inputCommandIndex + 1 != outputCommandIndex, outputCommandIndex + 1 != inputCommandIndex else { return nil }

        let inputURLString = arguments[inputCommandIndex + 1]
        let outputURLString = arguments[outputCommandIndex + 1]

        let inputURL = URL(fileURLWithPath: inputURLString)
        let outputURL = URL(fileURLWithPath: outputURLString)
        return Arguments(inputURL: inputURL, outputURL: outputURL)
    }
}

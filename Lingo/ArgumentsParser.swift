//
//  ArgumentsParser.swift
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

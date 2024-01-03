//
//  main.swift
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

import ArgumentParser
import LingoCore

struct Lingo: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Swift code generation for Localizable.strings files",
        version: Version.number)

    @Option(help: "path to Localizable.strings file")
    var input: String

    @Option(help: "path including file name to write Swift to")
    var output: String

    @Option(
        help: ArgumentHelp(
            "The name of the SPM package which `Lingo.swift` will belong to.",
            discussion: "If you are using SwiftUI and your strings file (and Lingo.swift) belong to a Swift package, specify that Swift package's name with this option. Without it SwiftUI previews will fatal error.",
            valueName: "package-name")
    )
    var packageName: String?

    func run() throws {
        try LingoCore.run(input: input, output: output, packageName: packageName)
    }
}

Lingo.main()

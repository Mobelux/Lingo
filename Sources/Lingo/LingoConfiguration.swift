//
//  LingoConfiguration.swift
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

import Foundation

/// The configuration for Lingo.
struct LingoConfiguration: Codable {
    /// The path of the `Localizable.strings` file.
    let input: String
    
    /// The path of the file to which the output will be written.
    let output: String

    /// The name of the SPM package to which ``LingoConfiguration/output`` will belong.
    ///
    /// - Warning: If you are using SwiftUI and your strings file (and Lingo.swift) belong to a
    /// Swift package, failure to specify a package name will cause SwiftUI previews to fatal error.
    let packageName: String?

    /// Creates an instance.
    ///
    /// - Parameters:
    ///   - input: The path of the `Localizable.strings` file.
    ///   - output: The path of the file to which the output will be written.
    ///   - packageName: The name of the SPM package to which the output will belong.
    init(input: String, output: String, packageName: String? = nil) {
        self.input = input
        self.output = output
        self.packageName = packageName
    }
}

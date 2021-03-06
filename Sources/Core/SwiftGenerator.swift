//
//  SwiftGenerator.swift
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

public struct SwiftGenerator {
    public static func generate(structs: [Struct], keyValues: [String:String]) -> String {
        var swift = "// This file is autogenerated by Lingo from your localized strings file.\n\n"
        swift += "import Foundation\n\n"
        swift += "private class BundleLocator {\n"
        swift += "    static let bundle: Bundle = Bundle(for: BundleLocator.self)\n"
        swift += "}\n\n"
        swift += "struct Lingo {\n"
        for (index, value) in structs.enumerated() {
            swift += swiftFor(struct: value, keyValues: keyValues)
            swift += "\n"
            if index < structs.count - 1 {
                swift += "\n"
            }
        }
        swift += "}\n"
        return swift
    }

    private static func swiftFor(struct aStruct: Struct, keyValues: [String:String]) -> String {
        var swift = "    struct \(aStruct.name) {"
        for key in aStruct.keys {
            let lowercasedKey = key.lowercaseFirstCharacter()
            let nsLocalizedKey = "\(aStruct.name).\(key)"
            if let value = keyValues[nsLocalizedKey] {
                swift += "\n        /// \(value)"
            }
            swift += "\n        static let \(lowercasedKey) = NSLocalizedString(\"\(nsLocalizedKey)\", bundle: BundleLocator.bundle, comment: \"\")"
        }
        swift += "\n    }"
        return swift
    }
}

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
    public static func generate(structs: [Struct], keyValues: [String:String], packageName: String?) -> String {
        var swift = "// This file is autogenerated by Lingo from your localized strings file.\n\n"
        swift += "import Foundation\n\n"
        swift += "private class BundleLocator {\n"
        swift += "    static let bundle: Bundle = {\n"
        swift += "        #if SWIFT_PACKAGE\n"
        swift += "            \(module(packageName))\n"
        swift += "        #else\n"
        swift += "            return Bundle(for: BundleLocator.self)\n"
        swift += "        #endif\n"
        swift += "    }()\n"
        swift += "}\n\n"
        swift += "public struct Lingo {\n"
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
        var swift = "    public struct \(aStruct.name) {"
        for key in aStruct.keys {
            let lowercasedKey = key.lowercaseFirstCharacter()
            let nsLocalizedKey = "\(aStruct.name).\(key)"
            if let value = keyValues[nsLocalizedKey] {
                swift += "\n        /// \(value)"
            }
            swift += "\n        public static let \(lowercasedKey) = NSLocalizedString(\"\(nsLocalizedKey)\", bundle: BundleLocator.bundle, comment: \"\")"
        }
        swift += "\n    }"
        return swift
    }

    private static func module(_ packageName: String?) -> String {
        if let packageName = packageName {
            return """
            let bundleName = "\(packageName)_\(packageName)"
                        let candidates = [
                            /* Bundle should be present here when the package is linked into an App. */
                            Bundle.main.resourceURL,
                            /* Bundle should be present here when the package is linked into a framework. */
                            Bundle(for: BundleLocator.self).resourceURL,
                            /* For command-line tools. */
                            Bundle.main.bundleURL,
                            /* Bundle should be present here when the package is used in UI Tests. */
                            Bundle(for: BundleLocator.self).resourceURL?.deletingLastPathComponent(),
                            /* Bundle should be present here when running previews from a different package (this is the path to "…/Debug-iphonesimulator/"). */
                            Bundle(for: BundleLocator.self).resourceURL?.deletingLastPathComponent().deletingLastPathComponent()
                        ]

                        for candidate in candidates {
                            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
                            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                                return bundle
                            }
                        }

                        fatalError("unable to find bundle named \\(bundleName)")
            """
        } else {
            return "return Bundle.module"
        }
    }
}
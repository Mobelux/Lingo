//
//  SwiftGenerator.swift
//  Lingo
//
//  Created by Jerry Mayers on 1/3/17.
//  Copyright © 2017 Mobelux. All rights reserved.
//

import Foundation

struct SwiftGenerator {
    static func generate(structs: [Struct], keyValues: [String:String]) -> String {
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
            swift += "\n        static let \(lowercasedKey) = NSLocalizedString(\"\(nsLocalizedKey)\", bundle: BundleLocator.bundle, comment:\"\")"
        }
        swift += "\n    }"
        return swift
    }
}

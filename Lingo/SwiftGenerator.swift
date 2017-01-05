//
//  SwiftGenerator.swift
//  Lingo
//
//  Created by Jerry Mayers on 1/3/17.
//  Copyright © 2017 Mobelux. All rights reserved.
//

import Foundation

struct SwiftGenerator {
    static func generate(structs: [Struct]) -> String {
        var swift = "// This file is autogenerated by Lingo from your localized strings file.\n\n"
        swift += "import Foundation\n\n"
        swift += "struct Lingo {\n"
        for (index, value) in structs.enumerated() {
            swift += swiftFor(struct: value)
            swift += "\n"
            if index < structs.count - 1 {
                swift += "\n"
            }
        }
        swift += "}\n"
        return swift
    }

    private static func swiftFor(struct aStruct: Struct) -> String {
        var swift = "    struct \(aStruct.name) {"
        for key in aStruct.keys {
            let lowercasedKey = key.lowercaseFirstCharacter()
            swift += "\n        static let \(lowercasedKey) = NSLocalizedString(\"\(aStruct.name).\(key)\", comment:\"\")"
        }
        swift += "\n    }"
        return swift
    }
}

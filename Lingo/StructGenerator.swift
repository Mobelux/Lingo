//
//  StructGenerator.swift
//  Lingo
//
//  Created by Jerry Mayers on 1/3/17.
//  Copyright © 2017 Mobelux. All rights reserved.
//

import Foundation

struct StructGenerator {
    static func generate(keyValues: [String:String]) -> [Struct] {
        let sortedKeys = Array(keyValues.keys).sorted()

        let names = Set(sortedKeys.flatMap({ $0.components(separatedBy: ".").first }))

        return names.map({
            let prefix = "\($0)."
            let allKeysWithNamePrefix = sortedKeys.filter({ return $0.hasPrefix(prefix) })
            let keys: [String] = allKeysWithNamePrefix.flatMap({
                guard let prefixRange = $0.range(of: prefix) else { return nil }
                return $0.substring(from: prefixRange.upperBound)
            })
            return Struct(name: $0, keys: keys.sorted())
        }).sorted(by: { (lhs, rhs) -> Bool in
            return lhs.name < rhs.name
        })
    }
}

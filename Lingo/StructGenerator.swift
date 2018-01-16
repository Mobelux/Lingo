//
//  StructGenerator.swift
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

struct StructGenerator {
    static func generate(keyValues: [String:String]) -> [Struct] {
        let sortedKeys = Array(keyValues.keys).sorted()

        let names = Set(sortedKeys.flatMap({ $0.components(separatedBy: ".").first }))

        return names.map({
            let prefix = "\($0)."
            let allKeysWithNamePrefix = sortedKeys.filter({ return $0.hasPrefix(prefix) })
            let keys: [String] = allKeysWithNamePrefix.flatMap({
                guard let prefixRange = $0.range(of: prefix) else { return nil }
				return String($0[prefixRange.upperBound...])
            })
            return Struct(name: $0, keys: keys.sorted())
        }).sorted(by: { (lhs, rhs) -> Bool in
            return lhs.name < rhs.name
        })
    }
}

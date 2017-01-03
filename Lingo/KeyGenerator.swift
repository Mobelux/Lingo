//
//  KeyGenerator.swift
//  Lingo
//
//  Created by Todd Crown on 1/3/17.
//  Copyright © 2017 Mobelux. All rights reserved.
//

import Foundation

struct KeyGenerator {
    private static func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    static func generate(raw: String) -> [String] {
        let matched = matches(for: "\\\"\\w+\\.\\w+\\\" = ", in: raw)
        
        let results = matched.map {(x: String) -> String in
            var match = matches(for: "\\w+\\.\\w+", in: x)
            return match[0]
        }
        
        return results
    }
}

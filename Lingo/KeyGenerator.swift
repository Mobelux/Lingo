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
    
    static func generate(localizationFileContents: String) -> [String : String] {
        let keyValueMatches = matches(for: "\\\"\\w+\\.\\w+\\\"\\s?=\\s?\\\"(.*)\\\"", in: localizationFileContents)
        
        var resultDictionary: [String : String] = [:]
        keyValueMatches.forEach {
            let keyResult = matches(for: "(\\w+\\.\\w+)", in: $0)
            let valueMatched = matches(for: "=[^;]*", in: $0)
            let valueResult = valueMatched.map {(x: String) -> String in
                var match = matches(for: "[^=\\s\\\"].*[^\\\";]", in: x)
                return match[0]
            }
            
            //be sure we have key:value
            guard keyResult != [] && valueResult != [] else { return }
            
            resultDictionary[keyResult[0]] = valueResult[0]
        }
        
        return resultDictionary
    }
}

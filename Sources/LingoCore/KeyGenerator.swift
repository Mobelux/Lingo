//
//  KeyGenerator.swift
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
                let match = matches(for: "\\\"([^\\\"]|(?<=\\\\)\\\")*\\\"", in: x)
                return match[0]
            }
            
            //be sure we have key:value
            guard keyResult != [] && valueResult != [] else { return }
            
            resultDictionary[keyResult[0]] = valueResult[0]
        }
        
        return resultDictionary
    }
}

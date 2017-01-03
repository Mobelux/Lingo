//
//  String+Lowercase.swift
//  Lingo
//
//  Created by Jerry Mayers on 1/3/17.
//  Copyright © 2017 Mobelux. All rights reserved.
//

import Foundation

extension String {
    func lowercaseFirstCharacter() -> String {
        let firstIndex = index(after: startIndex)
        return substring(to: firstIndex).lowercased() + substring(from: firstIndex)
    }
}

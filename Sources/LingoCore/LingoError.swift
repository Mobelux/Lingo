//
//  LingoError.swift
//  LingoCore
//
//  Created by Jeremy Greenwood on 5/14/19.
//

import Foundation

enum LingoError: LocalizedError {
    case custom(String)

    var errorDescription: String? {
        switch self {
        case .custom(let message):
            return message
        }
    }
}

//
//  main.swift
//  Lingo
//
//  Created by Jerry Mayers on 1/3/17.
//  Copyright © 2017 Mobelux. All rights reserved.
//

import Foundation

// temp example usage

let keys = ["DataController.NoNetworkError", "DataController.NotAuthenticatedError", "DataController.MalformedDataError"]

let generated = StructGenerator.generate(keys: keys)
print(generated)

let swift = SwiftGenerator.generate(structs: generated)

print(swift)

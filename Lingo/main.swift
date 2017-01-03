//
//  main.swift
//  Lingo
//
//  Created by Jerry Mayers on 1/3/17.
//  Copyright © 2017 Mobelux. All rights reserved.
//

import Foundation

// temp example usage
let raw = "\"DataController.NoNetworkError\" = \"Unable to connect to the server, check internet connection\"; \"DataController.NotAuthenticatedError\" = \"Not authenticated, maybe your session timed out\"; \"DataController.MalformedDataError\" = \"Response from the server was not what was expected\"; \"DataController.ServerError\" = \"The server had a problem, try again shortly\";"

let keys = KeyGenerator.generate(raw: raw)

let generated = StructGenerator.generate(keys: keys)
print(generated)

let swift = SwiftGenerator.generate(structs: generated)

print(swift)

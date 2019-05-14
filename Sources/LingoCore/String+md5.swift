//
//  String+md5.swift
//  LingoCore
//
//  Created by Jeremy Greenwood on 5/14/19.
//

import Foundation
import CommonCrypto

extension String {
    var md5: String {
        let data = self.data(using: String.Encoding.utf8)!
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}

// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import CommonCrypto

public extension Data {

    var md5: Data {
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        _ = digestData.withUnsafeMutableBytes { digestBytes in
            self.withUnsafeBytes { messageBytes in
                CC_MD5(messageBytes, CC_LONG(self.count), digestBytes)
            }
        }
        return digestData
    }

    var sha256: Data {
        var digestData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = digestData.withUnsafeMutableBytes { digestBytes in
            self.withUnsafeBytes { messageBytes in
                CC_SHA256(messageBytes, CC_LONG(self.count), digestBytes)
            }
        }
        return digestData
    }

}

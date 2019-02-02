// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation

public protocol ActivityTrackingService {
    func trackActivity(name: String)
    func trackActivity(name: String, meta: [String: String])
}

// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation

public protocol AuthenticationScheme {
    var isAuthenticated: Pr<Bool> { get }
    var authenticationStateToken: String? { get }
    func unauthenticate()
}

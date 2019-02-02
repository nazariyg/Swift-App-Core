// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones

public struct AuthenticationSchemeProvider {

    // `BearerAuthentication`
    static let defaultAuthenticationScheme = BearerAuthentication()

    static public func authenticationScheme() -> AuthenticationScheme {
        let authenticationScheme = InstanceProvider.shared.instance(for: AuthenticationScheme.self, defaultInstance: defaultAuthenticationScheme)
        return authenticationScheme
    }

}

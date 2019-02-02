// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones

struct BearerAuthenticationToken {

    let token: String

    // MARK: - Lifecycle

    init(token: String) {
        self.token = token
        Self.saveTokenToPersistentStore(token)
    }

    init?() {
        if let storedToken = Self.loadTokenFromPersistentStore() {
            token = storedToken
        } else {
            return nil
        }
    }

    func clearToken() {
        Self.store.removeValue(forKey: Self.tokenStoreKey)
    }

    // MARK: - Private

    private static let store = {
        return Config.shared.general.storeAuthenticationTokensInGlobalKeychain ? KeychainStore.global : KeychainStore.local
    }()

    private static let tokenStoreKey = "authToken"

    private static func saveTokenToPersistentStore(_ token: String) {
        Self.store.string[Self.tokenStoreKey] = token
    }

    private static func loadTokenFromPersistentStore() -> String? {
        return Self.store.string[Self.tokenStoreKey]
    }

    private typealias `Self` = BearerAuthenticationToken

}

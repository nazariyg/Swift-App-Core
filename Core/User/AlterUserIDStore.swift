// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones

public struct AlterUserIDStore {

    public static var ids: [String] {
        get {
            guard let data = store.data[storeKey] else { return [] }
            guard let container = try? JSONDecoder().decode(IDContainer.self, from: data) else { return [] }
            return container.ids
        }
        set(ids) {
            let container = IDContainer(ids: ids)
            guard let data = try? JSONEncoder().encode(container) else { return }
            store.data[storeKey] = data
        }
    }

    public static func clear() {
        store.removeValue(forKey: storeKey)
    }

    private struct IDContainer: Codable {
        let ids: [String]
    }

    private static let store = KeychainStore.global
    private static let storeKey = "alterUserIDs"

}

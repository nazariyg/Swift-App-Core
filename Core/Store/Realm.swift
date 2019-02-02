// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Cornerstones
import RealmSwift

private let logCategory = "Store"

// MARK: - Public

public extension Realm {

    func modify(_ modificationClosure: ThrowingVoidClosure) rethrows {
        do {
            try write {
                try modificationClosure()
            }
        } catch {
            log.error("Error while trying to modify a store: \(error)", logCategory)
        }
    }

}

// MARK: - Internal

extension Realm {

    func enableBackgroundAccess() {
        let directoryPath = configuration.fileURL!.deletingLastPathComponent().path
        let attributes = [FileAttributeKey.protectionKey: FileProtectionType.none]
        do {
            try FileManager.default.setAttributes(attributes, ofItemAtPath: directoryPath)
        } catch {
            log.error("Error while trying to change Realm file attributes: \(error)", logCategory)
        }
    }

}

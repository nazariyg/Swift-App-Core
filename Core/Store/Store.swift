// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Cornerstones
import RealmSwift

// MARK: - Protocol

public protocol StoreProtocol {
    static var main: Realm { get }
    var main: Realm { get }
    static var `default`: Realm { get }
    var `default`: Realm { get }
    func initializeMainStore(forID storeID: String)
    func forgetMainStore()
    var isMainStoreInitialized: Bool { get }
}

// MARK: - Implementation

private let logCategory = "Store"

/// The main store is associated with a specific user and is not automatically initialized. Any globally available data is stored in the default store,
/// which is initialized automatically. The default store is also used as the fallback store when trying to access the main store while it's not initialized.
public final class Store: StoreProtocol, SharedInstance {

    public typealias InstanceProtocol = StoreProtocol
    public static let defaultInstance: InstanceProtocol = Store()

    public private(set) var isMainStoreInitialized = false

    private static let storeCreationDirectoryURL = FileManager.documentsURL
    private static let storeFileExtension = "realm"

    private var queueLabelsToMainStores: [String: Realm?] = [:]
    private var queueGlobalMainStoreConfiguration: Realm.Configuration?
    private let mainStoreLock = VoidObject()

    private var queueLabelsToDefaultStores: [String: Realm?] = [:]
    private var queueGlobalDefaultStoreConfiguration: Realm.Configuration?
    private let defaultStoreLock = VoidObject()

    // MARK: - Lifecycle

    private init() {
        // Disable Realm's "new version available" notification in the console.
        setenv("REALM_DISABLE_UPDATE_CHECKER", "1", 1)

        initializeDefaultStore()
    }

    // MARK: - Main store

    public static var main: Realm {
        return Self.shared.main
    }

    public var main: Realm {
        return synchronized(mainStoreLock) {
            if let mainStore = queueLabelsToMainStores[DispatchQueue.currentQueueLabel] as? Realm {
                return mainStore
            } else if let commonMainStoreConfiguration = queueGlobalMainStoreConfiguration,
                      let mainStore = getOrCreateMainStore(forConfiguration: commonMainStoreConfiguration) {
                return mainStore
            } else {
                log.warning("Providing the default store instead of the uninitialized main store", logCategory)
                return `default`
            }
        }
    }

    public func initializeMainStore(forID storeID: String) {
        synchronized(mainStoreLock) {
            log.info("Initializing the main store for ID: \(storeID)", logCategory)
            queueLabelsToMainStores.removeAll()
            queueLabelsToMainStores[DispatchQueue.currentQueueLabel] = getOrCreateQueueGlobalMainStore(forID: storeID)
            isMainStoreInitialized = true
        }
    }

    public func forgetMainStore() {
        synchronized(mainStoreLock) {
            log.info("Forgetting the main store", logCategory)
            queueLabelsToMainStores[DispatchQueue.currentQueueLabel] = nil
            isMainStoreInitialized = false
        }
    }

    // MARK: - Default store

    public static var `default`: Realm {
        return Self.shared.default
    }

    public var `default`: Realm {
        return synchronized(defaultStoreLock) {
            if let defaultStore = queueLabelsToDefaultStores[DispatchQueue.currentQueueLabel] as? Realm {
                return defaultStore
            } else if let queueGlobalDefaultStoreConfiguration = queueGlobalDefaultStoreConfiguration,
                      let defaultStore = getOrCreateDefaultStore(forConfiguration: queueGlobalDefaultStoreConfiguration) {
                return defaultStore
            } else {
                log.error("The default store is not initialized", logCategory)
                assertionFailure("The default store is not initialized")
                return try! Realm()
            }
        }
    }

    private func initializeDefaultStore() {
        synchronized(defaultStoreLock) {
            log.info("Initializing the default store", logCategory)
            queueLabelsToDefaultStores.removeAll()
            queueLabelsToDefaultStores[DispatchQueue.currentQueueLabel] = getOrCreateQueueGlobalDefaultStore()
        }
    }

    // MARK: - Private

    private func baseStoreConfiguration() -> Realm.Configuration {
        let configuration =
            Realm.Configuration(
                schemaVersion: UInt64(StoreMigrations.currentSchemaVersion),
                migrationBlock: StoreMigrations.migrationClosure)
        return configuration
    }

    private func mainStoreConfiguration(forID storeID: String) -> Realm.Configuration {
        let storeName = storeID.isAlphanumeric ? storeID : storeID.md5
        var configuration = baseStoreConfiguration()
        let fileName = "ID-\(storeName).\(Self.storeFileExtension)"
        configuration.fileURL = Self.storeCreationDirectoryURL.appendingPathComponent(fileName)
        return configuration
    }

    private func getOrCreateQueueGlobalMainStore(forID id: String) -> Realm? {
        let configuration = mainStoreConfiguration(forID: id)

        var store: Realm?
        do {
            store = try Realm(configuration: configuration)
            queueGlobalMainStoreConfiguration = configuration
        } catch {
            log.error("Error while trying to get/create the main store: \(error)", logCategory)
            assertionFailure(error.localizedDescription)
            return nil
        }

        // Prepare accessing Realm while the device is locked.
        store?.enableBackgroundAccess()

        return store
    }

    private func getOrCreateMainStore(forConfiguration configuration: Realm.Configuration) -> Realm? {
        var store: Realm?
        do {
            store = try Realm(configuration: configuration)
        } catch {
            log.error("Error while trying to get/create the main store: \(error)", logCategory)
            assertionFailure(error.localizedDescription)
            return nil
        }

        // Prepare accessing Realm while the device is locked.
        store?.enableBackgroundAccess()

        return store
    }

    private func defaultStoreConfiguration() -> Realm.Configuration {
        var configuration = baseStoreConfiguration()
        let fileName = "Default.\(Self.storeFileExtension)"
        configuration.fileURL = Self.storeCreationDirectoryURL.appendingPathComponent(fileName)
        return configuration
    }

    private func getOrCreateQueueGlobalDefaultStore() -> Realm? {
        let configuration = defaultStoreConfiguration()

        var store: Realm?
        do {
            store = try Realm(configuration: configuration)
            queueGlobalDefaultStoreConfiguration = configuration
        } catch {
            log.error("Error while trying to get/create the default store: \(error)", logCategory)
            assertionFailure(error.localizedDescription)
            return nil
        }

        // Prepare accessing Realm while the device is locked.
        store?.enableBackgroundAccess()

        return store
    }

    private func getOrCreateDefaultStore(forConfiguration configuration: Realm.Configuration) -> Realm? {
        var store: Realm?
        do {
            store = try Realm(configuration: configuration)
        } catch {
            log.error("Error while trying to get/create the default store: \(error)", logCategory)
            assertionFailure(error.localizedDescription)
            return nil
        }

        // Prepare accessing Realm while the device is locked.
        store?.enableBackgroundAccess()

        return store
    }

    private typealias `Self` = Store

}

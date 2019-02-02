// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones
import UserNotifications

// MARK: - Protocol

public protocol RemoteNotificationsServiceProtocol {

    func registering() -> Sp<SystemPermission.Status>
    func registerIfPermissionIsGranted()
    func unregister()

    // For AppDelegate.
    func _didRegisterForRemoteNotifications(deviceTokenData: Data)
    func _didLaunchByRemoteNotification(userInfo: [String: Any])
    func _didReceiveRemoteNotification(userInfo: [String: Any]) -> UIBackgroundFetchResult
    func _registeringForRemoteNotificationsDidFail(error: Error)

}

// MARK: - Implementation

private let logCategory = "Remote Notifications"

public final class RemoteNotificationsService: RemoteNotificationsServiceProtocol, SharedInstance {

    public typealias InstanceProtocol = RemoteNotificationsServiceProtocol
    public static let defaultInstance: InstanceProtocol = RemoteNotificationsService()

    private static let tokenStore = KeychainStore.local
    private static let registeredDeviceTokenStoreKey = "remoteNotificationsRegisteredDeviceToken"
    private static let uploadedDeviceTokenStoreKey = "remoteNotificationsUploadedDeviceToken"

    private var cachedDeviceTokenToUpload: String?

    // MARK: - Lifecycle

    private init() {
        wireInAuthService()
    }

    // MARK: - Registering

    public func registering() -> Sp<SystemPermission.Status> {
        return Sp { emitter, _ in
            SystemPermission.notifications.status { [weak self] status in
                guard let strongSelf = self else { return }
                log.info("Current permission status is '\(status)'", logCategory)

                switch status {

                case .undetermined:
                    log.info("Requesting permission", logCategory)
                    SystemPermission.notifications.request(completion: { [weak self] status in
                        guard let strongSelf = self else { return }
                        log.info("Permission requesting resulted in status: '\(status)'", logCategory)

                        if status == .granted {
                            ActivityTracker.shared.userDidGrantNotificationsPermission()
                            strongSelf.registerWithSystem()
                        } else if status == .denied {
                            ActivityTracker.shared.userDidDenyNotificationsPermission()
                        }

                        emitter.send(value: status)
                        emitter.sendCompleted()
                    }, notificationsOptions: Config.shared.general.remoteNotificationsOptions)

                case .granted:
                    strongSelf.registerWithSystem()

                    emitter.send(value: status)
                    emitter.sendCompleted()

                default:
                    emitter.send(value: status)
                    emitter.sendCompleted()

                }
            }
        }
    }

    public func registerIfPermissionIsGranted() {
        SystemPermission.notifications.status { [weak self] status in
            guard let strongSelf = self else { return }
            log.info("Current permission status is '\(status)'", logCategory)
            switch status {
            case .granted:
                strongSelf.registerWithSystem()
            default: break
            }
        }
    }

    public func unregister() {
        unregisterWithSystemAndBackend()
    }

    // MARK: - AppDelegate

    public func _didRegisterForRemoteNotifications(deviceTokenData: Data) {
        synchronized(self) {
            let deviceToken = deviceTokenData.hexString
            Self.tokenStore.string[Self.registeredDeviceTokenStoreKey] = deviceToken
            registerDeviceWithBackendIfNeeded()
        }
    }

    public func _didLaunchByRemoteNotification(userInfo: [String: Any]) {
        log.info("Did launch by a remote notification with payload:\n\(userInfo.prettyPrinted)", logCategory)
    }

    public func _didReceiveRemoteNotification(userInfo: [String: Any]) -> UIBackgroundFetchResult {
        log.info("Did receive a remote notification with payload:\n\(userInfo.prettyPrinted)", logCategory)
        return .noData
    }

    public func _registeringForRemoteNotificationsDidFail(error: Error) {
        synchronized(self) {
            log.error("Could not register the app for remote notifications: \(error)", logCategory)
            clearState()
        }
    }

    // MARK: - AuthService

    private func wireInAuthService() {
        AuthService.shared.knownIsLoggedIn.producer
            .startWithValues { [weak self] knownIsLoggedIn in
                guard let strongSelf = self else { return }
                synchronized(strongSelf) {
                    if let knownIsLoggedIn = knownIsLoggedIn {
                        if knownIsLoggedIn {
                            strongSelf.registerIfPermissionIsGranted()
                            strongSelf.startEnsuringRegisteringDeviceWithBackend()
                        } else {
                            strongSelf.unregister()
                        }
                    }
                }
            }
    }

    // MARK: - Private

    private func registerWithSystem() {
        DispatchQueue.main.executeSync {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

    private func unregisterWithSystemAndBackend() {
        synchronized(self) {
            DispatchQueue.main.executeSync {
                UIApplication.shared.unregisterForRemoteNotifications()
            }
            unregisterDeviceWithBackend()
            clearState()
        }
    }

    private func startEnsuringRegisteringDeviceWithBackend() {
        synchronized(self) {
            cachedDeviceTokenToUpload = getDeviceTokenToUpload()
            Network.shared.isOnline.producer
                .filter { $0 }
                .startWithValues { [weak self] _ in
                    guard let strongSelf = self else { return }
                    synchronized(strongSelf) {
                        if let deviceTokenToUpload = strongSelf.cachedDeviceTokenToUpload {
                            strongSelf.registerDeviceWithBackend(deviceTokenToUpload)
                        }
                    }
                }
        }
    }

    private func getDeviceTokenToUpload() -> String? {
        return synchronized(self) {
            guard
                let deviceToken = Self.tokenStore.string[Self.registeredDeviceTokenStoreKey],
                deviceToken != Self.tokenStore.string[Self.uploadedDeviceTokenStoreKey]
            else { return nil }

            return deviceToken
        }
    }

    private func registerDeviceWithBackendIfNeeded() {
        synchronized(self) {
            guard let deviceToken = getDeviceTokenToUpload() else { return }
            cachedDeviceTokenToUpload = deviceToken
            registerDeviceWithBackend(deviceToken)
        }
    }

    private func registerDeviceWithBackend(_ deviceToken: String) {
        let deviceID = UIDevice.current.persistentID

        log.info("Uploading device token for remote notifications to the backend", logCategory)

        let endpoint =
            Backend.API.Push.registerApnsDevice(
                deviceToken: deviceToken,
                deviceID: deviceID)

        BackendAPIRequester.making(endpoint.request)
            .payloadlessResult()
            .startWithCompleted { [weak self] in
                guard let strongSelf = self else { return }
                synchronized(strongSelf) {
                    log.info("Did upload device token for remote notifications to the backend", logCategory)
                    Self.tokenStore.string[Self.uploadedDeviceTokenStoreKey] = deviceToken
                    strongSelf.cachedDeviceTokenToUpload = nil
                }
            }
    }

    private func unregisterDeviceWithBackend() {
        let deviceID = UIDevice.current.persistentID

        log.info("Unregistering the device with the backend", logCategory)

        let endpoint = Backend.API.Push.unregisterApnsDevice(deviceID: deviceID)
        BackendAPIRequester.making(endpoint.request).start()
    }

    private func clearState() {
        synchronized(self) {
            Self.tokenStore.string[Self.registeredDeviceTokenStoreKey] = nil
            Self.tokenStore.string[Self.uploadedDeviceTokenStoreKey] = nil
            cachedDeviceTokenToUpload = nil
        }
    }

    private typealias `Self` = RemoteNotificationsService

}

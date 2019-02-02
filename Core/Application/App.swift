// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import UIKit
import Cornerstones

// MARK: - Protocol

public protocol AppProtocol {
    func initialize(withLaunchOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    var isBackgrounded: Bool { get }
    var version: String { get }
    var buildNumber: String { get }
    var fullVersion: String { get }
    var eventSignal: Si<App.Event> { get }  // AppEventEmitterProtocol

    // For AppDelegate.
    func _appWillEnterForeground()
    func _appDidBecomeActive()
    func _appWillResignActive()
    func _appDidEnterBackground()
    func _appWillTerminate()
}

// MARK: - Implementation

private let logCategory = "App"

public final class App: AppProtocol, EventEmitter, SharedInstance {

    public enum Event {
        case willEnterForeground
        case didBecomeActive
        case willResignActive
        case didEnterBackground
        case willTerminate
    }

    public typealias InstanceProtocol = AppProtocol
    public static let defaultInstance: InstanceProtocol = App()

    private var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    private var cachedIsBackgrounded: Bool?

    // MARK: - Lifecycle

    private init() {}

    // Called by AppDelegate.
    public func initialize(withLaunchOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        log.debug("Initializing the app", logCategory)

        AutoInitSharedInstances.initializeAll()

        self.launchOptions = launchOptions

        log.appInfo()
        if let launchOptions = launchOptions {
            log.infoInvocation()
            log.info("launchOptions: \(launchOptions)", logCategory)
        }
    }

    // MARK: - App state

    public var isBackgrounded: Bool {
        // Avoid sync execution on the main queue. This is primarily to increase logging performance.
        if let cachedIsBackgrounded = cachedIsBackgrounded {
            return cachedIsBackgrounded
        }
        let isBackgrounded = DispatchQueue.main.executeSync {
            return UIApplication.shared.applicationState == .background
        }
        cachedIsBackgrounded = isBackgrounded
        return isBackgrounded
    }

    // MARK: - App info

    public var version: String {
        let infoDictionary = Bundle.main.infoDictionary
        let version = infoDictionary?["CFBundleShortVersionString"] as? String
        return version ?? ""
    }

    public var buildNumber: String {
        let infoDictionary = Bundle.main.infoDictionary
        let buildNumber = infoDictionary?["CFBundleVersion"] as? String
        return buildNumber ?? ""
    }

    public var fullVersion: String {
        let fullVersion = "\(version) (\(buildNumber))"
        return fullVersion
    }

    // MARK: - UIApplicationDelegate events to be called by the AppDelegate only

    public func _appWillEnterForeground() {
        log.info("App will enter foreground", logCategory)
        if cachedIsBackgrounded != nil {
            cachedIsBackgrounded = false
        }
        eventEmitter.send(value: .willEnterForeground)
    }

    public func _appDidBecomeActive() {
        log.info("App did become active", logCategory)
        eventEmitter.send(value: .didBecomeActive)
    }

    public func _appWillResignActive() {
        log.info("App will resign active", logCategory)
        eventEmitter.send(value: .willResignActive)
    }

    public func _appDidEnterBackground() {
        log.info("App did enter background", logCategory)
        if cachedIsBackgrounded != nil {
            cachedIsBackgrounded = true
        }
        eventEmitter.send(value: .didEnterBackground)
    }

    public func _appWillTerminate() {
        log.info("App will terminate", logCategory)
        eventEmitter.send(value: .willTerminate)
    }

}

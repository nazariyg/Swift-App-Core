// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones

// MARK: - Protocol

public protocol ActivityTrackerProtocol {
    func userDidSignUp()
    func userDidLogIn()
    func userDidLogOut()
    func userDidChangePassword()
    func userDidRequestResettingPassword()
    func userDidLogOutUnexpectedly()
    func userDidGrantNotificationsPermission()
    func userDidDenyNotificationsPermission()
}

// MARK: - Implementation

public final class ActivityTracker: ActivityTrackerProtocol, SharedInstance {

    public typealias InstanceProtocol = ActivityTrackerProtocol
    public static let defaultInstance: InstanceProtocol = ActivityTracker()

    private let activityTrackingService: ActivityTrackingService = DummyActivityTrackingService()

    // MARK: - Lifecycle

    private init() {}

    // MARK: - Activity tracking

    public func userDidSignUp() {
        activityTrackingService.trackActivity(name: #function)
    }

    public func userDidLogIn() {
        activityTrackingService.trackActivity(name: #function)
    }

    public func userDidLogOut() {
        activityTrackingService.trackActivity(name: #function)
    }

    public func userDidChangePassword() {
        activityTrackingService.trackActivity(name: #function)
    }

    public func userDidRequestResettingPassword() {
        activityTrackingService.trackActivity(name: #function)
    }

    public func userDidLogOutUnexpectedly() {
        activityTrackingService.trackActivity(name: #function)
    }

    public func userDidGrantNotificationsPermission() {
        activityTrackingService.trackActivity(name: #function)
    }

    public func userDidDenyNotificationsPermission() {
        activityTrackingService.trackActivity(name: #function)
    }

}

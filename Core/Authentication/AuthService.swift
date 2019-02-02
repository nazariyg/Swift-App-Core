// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones
import ReactiveSwift

// MARK: - Protocol

public protocol AuthServiceProtocol {
    func checkingNewUserName(name: String) -> SpEr<Bool>
    func signingUp(
        name: String,
        password: String,
        email: String?,
        measurementSystem: MeasurementSystem)
        -> SpEr<APIUser>
    func loggingIn(name: String, password: String) -> SpEr<APIUser>
    func checkingLoggedIn() -> SpEr<Bool>
    func loggingOut() -> SpEr<APIPayloadlessResult>
    func changingPassword(toNewPassword newPassword: String) -> SpEr<APIPayloadlessResult>
    func resettingPassword(forEmail email: String) -> SpEr<APIPayloadlessResult>
    var knownIsLoggedIn: Pr<Bool?> { get }
    var eventSignal: Si<AuthService.Event> { get }  // AuthServiceEventEmitterProtocol
}

// MARK: - Implementation

private let logCategory = "Auth"

public final class AuthService: AuthServiceProtocol, EventEmitter, SharedInstance {

    public enum Event {
        case didLogIn(asUser: APIUser)
        case didLogOut
    }

    public typealias InstanceProtocol = AuthServiceProtocol
    public static let defaultInstance: InstanceProtocol = AuthService()

    /// Skipping repeats.
    private let _knownIsLoggedIn = Mp<Bool?>(nil)
    public var knownIsLoggedIn: Pr<Bool?> {
        return _knownIsLoggedIn.skipRepeats()
    }

    private let authenticationScheme = AuthenticationSchemeProvider.authenticationScheme()

    // MARK: - Lifecycle

    private init() {
        wireInAuthenticationScheme()
        wireInNetwork()
    }

    // MARK: - User authentication

    public func checkingNewUserName(name: String) -> SpEr<Bool> {
        let endpoint = Backend.API.Auth.checkNewUserName(name: name)
        return
            BackendAPIRequester.making(endpoint.request)
            .bool()
    }

    public func signingUp(
        name: String,
        password: String,
        email: String?,
        measurementSystem: MeasurementSystem)
        -> SpEr<APIUser> {

        let alterUserIDs = AlterUserIDStore.ids

        let endpoint =
            Backend.API.Auth.createUser(
                name: name,
                password: password,
                email: email,
                measurementSystem: measurementSystem,
                alterUserIDs: alterUserIDs)

        return
            BackendAPIRequester.making(endpoint.request)
            .entity(for: APIUser.self)
            .on(value: { [weak self] apiUser in
                guard let strongSelf = self else { return }
                log.info("Created an account and logged in a user with name \"\(name)\" and ID \(apiUser.userID)", logCategory)
                ActivityTracker.shared.userDidSignUp()
                strongSelf._knownIsLoggedIn.value = true
                strongSelf.eventEmitter.send(value: .didLogIn(asUser: apiUser))
            })
    }

    public func loggingIn(name: String, password: String) -> SpEr<APIUser> {
        let alterUserIDs = AlterUserIDStore.ids

        let endpoint =
            Backend.API.Auth.logIn(
                name: name,
                password: password,
                alterUserIDs: alterUserIDs)

        return
            BackendAPIRequester.making(endpoint.request)
            .entity(for: APIUser.self)
            .on(value: { [weak self] apiUser in
                guard let strongSelf = self else { return }
                log.info("Logged in a user with name \"\(name)\" and ID \(apiUser.userID)", logCategory)
                ActivityTracker.shared.userDidLogIn()
                strongSelf._knownIsLoggedIn.value = true
                strongSelf.eventEmitter.send(value: .didLogIn(asUser: apiUser))
            })
    }

    public func checkingLoggedIn() -> SpEr<Bool> {
        var originalAuthStateToken: String?

        let endpoint = Backend.API.Auth.checkLoggedIn
        return
            BackendAPIRequester.making(endpoint.request)
            .bool()
            .on(starting: { [weak self] in
                guard let strongSelf = self else { return }
                originalAuthStateToken = strongSelf.authenticationScheme.authenticationStateToken
            })
            .on(value: { [weak self] isLoggedIn in
                guard let strongSelf = self else { return }
                guard
                    strongSelf.authenticationScheme.isAuthenticated.value,
                    let originalAuthStateToken = originalAuthStateToken,
                    let currentAuthStateToken = strongSelf.authenticationScheme.authenticationStateToken,
                    currentAuthStateToken == originalAuthStateToken
                else { return }

                log.info("Checked if currently logged in, result: \(isLoggedIn)", logCategory)
                if isLoggedIn {
                    strongSelf._knownIsLoggedIn.value = true
                } else {
                    ActivityTracker.shared.userDidLogOutUnexpectedly()
                    strongSelf.authenticationScheme.unauthenticate()
                }
            })
    }

    public func loggingOut() -> SpEr<APIPayloadlessResult> {
        let endpoint = Backend.API.Auth.logOut
        return
            BackendAPIRequester.making(endpoint.request)
            .payloadlessResult()
            .on(completed: { [weak self] in
                log.info("Did log out", logCategory)
                ActivityTracker.shared.userDidLogOut()
                self?.authenticationScheme.unauthenticate()
            })
    }

    public func changingPassword(toNewPassword newPassword: String) -> SpEr<APIPayloadlessResult> {
        let endpoint = Backend.API.Auth.changePassword(newPassword: newPassword)
        return
            BackendAPIRequester.making(endpoint.request)
            .payloadlessResult()
            .on(completed: {
                log.info("Did change user password", logCategory)
                ActivityTracker.shared.userDidChangePassword()
            })
    }

    public func resettingPassword(forEmail email: String) -> SpEr<APIPayloadlessResult> {
        let endpoint = Backend.API.Auth.resetPassword(email: email)
        return
            BackendAPIRequester.making(endpoint.request)
            .payloadlessResult()
            .on(completed: {
                log.info("Did request resetting password for email: \(email)", logCategory)
                ActivityTracker.shared.userDidRequestResettingPassword()
            })
    }

    // MARK: - AuthenticationScheme

    private func wireInAuthenticationScheme() {
        authenticationScheme.isAuthenticated.signal
            .observeValues { [weak self] isAuthenticated in
                guard let strongSelf = self else { return }
                if !isAuthenticated {
                    log.info("Did log out", logCategory)
                    strongSelf._knownIsLoggedIn.value = false
                    strongSelf.eventEmitter.send(value: .didLogOut)
                }
            }
    }

    // MARK: - Network

    private func wireInNetwork() {
        // If online and every time we go online, check if we're logged in.
        Network.shared.isOnline.producer
            .filter { $0 }
            .startWithValues { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.checkingLoggedIn().start()
            }
    }

}

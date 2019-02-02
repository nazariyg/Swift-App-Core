// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones

// MARK: - Protocol

public protocol UserServiceProtocol {
    var user: User? { get }
    var eventSignal: Si<UserService.Event> { get }  // UserServiceEventEmitterProtocol
}

// MARK: - Implementation

private let logCategory = "User"

public final class UserService: UserServiceProtocol, EventEmitter, SharedInstance {

    public enum Event {
        case didLoadLoggedInUser(User)
        case didLogOutUser
    }

    public typealias InstanceProtocol = UserServiceProtocol
    public static let defaultInstance: InstanceProtocol = UserService()

    private static let loggedInUserIDStoreKey = "loggedInUserID"

    private let mainStoreWithUserLock = VoidObject()

    // MARK: - Lifecycle

    private init() {
        wireInAuthService()
        tryLoadingLoggedInUser()
    }

    // MARK: - User

    /// Currently logged in user.
    public var user: User? {
        return synchronized(mainStoreWithUserLock) {
            guard Store.shared.isMainStoreInitialized else { return nil }
            return Store.main[User.self]
        }
    }

    private func tryLoadingLoggedInUser() {
        synchronized(mainStoreWithUserLock) {
            guard let userID = Store.default.string[Self.loggedInUserIDStoreKey] else { return }

            // Initialize the main store with the user's ID.
            Store.shared.initializeMainStore(forID: userID)

            if let user = Store.main[User.self] {
                log.info("Found a logged in user with ID: \(userID)", logCategory)
                eventEmitter.send(value: .didLoadLoggedInUser(user))
            } else {
                log.error("No user was found in the main store for user ID: \(userID)", logCategory)
                assertionFailure()
            }
        }
    }

    // MARK: - AuthService events

    private func wireInAuthService() {
        // User authentication.
        AuthService.shared.eventSignal
            .observeValues { [weak self] authEvent in
                guard let strongSelf = self else { return }
                switch authEvent {
                case let .didLogIn(apiUser): strongSelf.authServiceDidLogIn(withAPIUser: apiUser)
                case .didLogOut: strongSelf.authServiceDidLogOut()
                }
            }
    }

    private func authServiceDidLogIn(withAPIUser apiUser: APIUser) {
        synchronized(mainStoreWithUserLock) {
            log.info("Saving a logged in user with ID: \(apiUser.userID)", logCategory)

            // Save the ID of the logged in user to be able to initialize the main store on subsequent app launches.
            Store.default.string[Self.loggedInUserIDStoreKey] = apiUser.userID

            // Initialize the main store with the user's ID.
            Store.shared.initializeMainStore(forID: apiUser.userID)

            let user = User(apiUser)
            Store.main[User.self] = user

            AlterUserIDStore.ids = apiUser.alterUserIds

            eventEmitter.send(value: .didLoadLoggedInUser(user))
        }
    }

    private func authServiceDidLogOut() {
        synchronized(mainStoreWithUserLock) {
            log.info("Forgetting the previously logged in user", logCategory)
            Store.default.string.removeValue(forKey: Self.loggedInUserIDStoreKey)
            Store.shared.forgetMainStore()
            eventEmitter.send(value: .didLogOutUser)
        }
    }

    // MARK: - Private

    private typealias `Self` = UserService

}

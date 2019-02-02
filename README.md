# SwiftAppCore

In this repository, you are welcomed to get acquainted with my coding style, design approaches, and coding techniques.

### App Modularity

Modular app design, in which the app is composed of separate frameworks, is beneficial in coordinating team work on large projects as well as for practical reasons of keeping Xcode build times as quick as possible.

For large non-modular Swift projects, building the project after making any change in the code may take up to *30 seconds* of waiting time, while making a change to a Swift file in a modular project results in a build time that is only proportional to the size of that individual module, which is under 3 seconds in my experience.

Therefore it's crucial to take the modular approach when starting to develop an app aimed at growth.

### Cornerstones & Core

There are two centerpiece modules to my apps, **Cornerstones** framework and **Core** framework.

The mission of **Cornerstones** is to supplement and add convenience to the Apple's Foundation framework. The Cornerstones framework is completely agnostic about the app's business logic and deals with Swift language itself, Swift types, concurrency, basic UIKit and Core Animation, and networking entities.

The **Core** framework, on the other hand, provides components that power the app's essential functionality, which includes configuration, logging, FRP, persistent store, error handling, networking and serialization, backend API, authentication, remote notifications, and core UI.

Both frameworks are written in Swift 4.2. My FRP preference is ReactiveSwift with ReactiveCocoa.

### Cornerstones Highlights

* [**StoredProperties**](Cornerstones/Swift/StoredProperties/StoredProperties.swift) Allows for stored properties in Swift class extensions and protocol extensions. In the spirit of favoring composition over inheritance, this adds the advantage of storing state for any class without the need to subclass it. Properties can be stored and accessed atomically.

* [**InstanceProvider**](Cornerstones/Swift/Testing/InstanceProvider.swift) Maintains a pushable/popable stack of instances to be used in dependency injection during tests. During normal execution, provides the default instance for the specified protocol. Also lets replace network responses for specific network requests during tests.

* [**SharedInstance**](Cornerstones/Swift/Testing/SharedInstance.swift) The protocol to be adopted by any class with a shared instance. Asks `InstanceProvider` for the currently set shared instance or returns the default one.

* [**DispatchQueue**](Cornerstones/Concurrency/DispatchQueue/DispatchQueue.swift) Methods for more intelligent execution on the main and background queues.

* [**FileSpecificQueue**](Cornerstones/Concurrency/DispatchQueue/FileSpecificQueue.swift) Lets create queues with unique labeling specific to the current app's bundle ID and the current Swift file.

* [**Synchronized**](Cornerstones/Concurrency/Synchronization/Synchronized.swift) The Swift's alternative to Objective-C's `@synchronized`.

* [**ReaderWriterQueue**](Cornerstones/Concurrency/Synchronization/ReaderWriterQueue.swift) Allows for fast state access synchronization using a concurrent queue, on which state reading operations are isolated from state writing operations, and with performance optimizations for recursive calls.

* [**SystemPermission**](Cornerstones/Permissions/SystemPermission.swift) Generalizes the possible states of system granted permissions and lets request system permissions.

* [**UIDevice**](Cornerstones/UIKit/UIDevice/UIDevice.swift) Among others, provides a device ID that persists between app installations.

* [**UIScreenMetrics**](Cornerstones/UIKit/UIScreen/UIScreenMetrics.swift) To optimize UI ergonomics for various device models, lets adjust screen point values, such as lengths and font sizes, to the size and characteristics of the device's screen.

* [**HTTP**](Cornerstones/Networking/HTTP) Entities for HTTP networking.

### Core Highlights

* [**App**](Core/Application/App.swift) The application class.

* [**Log**](Core/Logging/Log.swift) & [**LogManager**](Core/Logging/LogManager.swift) Logging based on [SwiftyBeaver](https://github.com/SwiftyBeaver/SwiftyBeaver).

* [**EventEmitter**](Core/Reactive/EventEmitter.swift) Takes advantage of [StoredProperties](Cornerstones/Swift/StoredProperties/StoredProperties.swift) to let any class quickly add support for sending observable events by simply adding `EventEmitter` protocol to the list of protocols for that class and adding a nested `Event` enum.

* [**Store**](Core/Store) A persistent store based on [Realm](https://github.com/realm/realm-cocoa). Allows for multithreaded store access, singleton storage and subscript access by singleton type, and key-value Realm storage as a replacement for `UserDefaults`.

* [**Network**](Core/Networking/Network/Network.swift) The network monitor.

* [**Requester**](Core/Networking/Network/Requester.swift) A collection of stateless and stateful networking session providers.

* [**HTTPReactiveRequesting**](Core/Networking/HTTP/HTTPReactiveRequesting.swift) Lets networking sessions reactively make HTTP requests for data and JSON responses, reactively download and upload with progress.

* [**HTTPRequestRetrier**](Core/Networking/HTTP/HTTPRequestRetrier.swift) Lets timed out and other failed HTTP requests be retried.

* [**BackendAPIRequestPluginProvider**](Core/BackendAPI/Backend/BackendAPIRequestPluginProvider.swift) Lets plug into HTTP requests and observe responses, useful for plugging authentication tokens into HTTP requests and observing "unauthorized" responses.

* [**AuthService**](Core/Authentication/AuthService.swift) Reactively makes backend requests related to authentication and manages side effects.

* [**BearerAuthentication**](Core/Authentication/BearerAuthentication.swift) & [**BearerAuthenticationToken**](Core/Authentication/BearerAuthenticationToken.swift) An implementation of bearer authentication scheme.

* [**UserService**](Core/User/UserService.swift) Manages users.

* [**RemoteNotificationsService**](Core/RemoteNotifications/RemoteNotificationsService.swift) Registers and unregisters for remote notifications, handles device token upload to the backend, and manages remote notifications permission state.

* [**UIViewControllerBase**](Core/UI/UICore/UIViewControllerBase.swift) The base view controller.

* [**UIScener**](Core/UI/UICore/UIScener.swift) Manages screen transitions with pushing and presenting view controllers as well as setting the root view controller. Automatically embeds view controllers into `UINavigationController` with the hidden navigation bar to enable push transitions whenever needed.

* [**UIControls**](Core/UI/UIControls) A collection of stylized UI controls.

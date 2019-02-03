## Swift App Core

In this repository, you can get acquainted with my coding style, design approaches, and programming techniques.

### Cornerstones & Core

There are two centerpiece modules to my apps, **Cornerstones** framework and **Core** framework.

The mission of **Cornerstones** is to supplement the Apple's Foundation framework with extra convenience. The Cornerstones framework is completely agnostic about the app's business logic and deals with Swift language itself, Swift types, concurrency, basic UIKit and Core Animation, and networking entities.

The **Core** framework, on the other hand, provides components to power the app's essential functionality, which includes configuration, logging, FRP, persistent storage, error handling, networking and serialization, backend API, authentication, remote notifications, user management, and core UI.

Both frameworks are written in Swift 4.2. My FRP preference is [ReactiveSwift](https://github.com/ReactiveCocoa/ReactiveSwift).

This repository contains the complete source code for the two frameworks. Below are only some highlights that may be points of interest.

### Cornerstones Highlights

* [**StoredProperties**](Cornerstones/Swift/StoredProperties/StoredProperties.swift) Allows for stored properties in Swift class extensions and protocol extensions. In the spirit of favoring composition over inheritance, this adds the advantage of storing state for any class without the need to subclass it. Properties can be stored and accessed atomically.

* [**InstanceProvider**](Cornerstones/Swift/Testing/InstanceProvider.swift) Maintains a pushable/popable stack of instances to be used for dependency injection during tests. During normal execution, provides the default instance for the specified protocol. Also lets substitute network responses for specific network requests with custom responses during tests.

* [**SharedInstance**](Cornerstones/Swift/Testing/SharedInstance.swift) The protocol to be adopted by any class with a shared instance. When asked for the shared instance, refers to the `InstanceProvider` for the currently set shared instance if currently running tests or returns the default instance.

* [**DispatchQueue**](Cornerstones/Concurrency/DispatchQueue/DispatchQueue.swift) Contains methods for more intelligent execution on the main and background queues.

* [**FileSpecificQueue**](Cornerstones/Concurrency/DispatchQueue/FileSpecificQueue.swift) Lets create queues with unique labeling specific to the app's bundle ID and the current Swift file.

* [**Synchronized**](Cornerstones/Concurrency/Synchronization/Synchronized.swift) The Swift's alternative to Objective-C's `@synchronized`.

* [**ReaderWriterQueue**](Cornerstones/Concurrency/Synchronization/ReaderWriterQueue.swift) Allows for fast state access synchronization using a concurrent queue, on which state reading operations are isolated from state writing operations, and with performance optimizations for recursive calls.

* [**SystemPermission**](Cornerstones/Permissions/SystemPermission.swift) Generalizes the possible states of system granted permissions and lets request permissions from the system.

* [**UIDevice**](Cornerstones/UIKit/UIDevice/UIDevice.swift) Among others, provides the device ID that persists between app installations.

* [**UIScreenMetrics**](Cornerstones/UIKit/UIScreen/UIScreenMetrics.swift) To optimize UI ergonomics for various device models, lets adjust screen point values, such as lengths and font sizes, to the size and characteristics of the device's screen.

* [**HTTP**](Cornerstones/Networking/HTTP) Entities for HTTP networking.

### Core Highlights

* [**Log**](Core/Logging/Log.swift) & [**LogManager**](Core/Logging/LogManager.swift) Logging based on [SwiftyBeaver](https://github.com/SwiftyBeaver/SwiftyBeaver).

* [**EventEmitter**](Core/Reactive/EventEmitter.swift) Takes advantage of [StoredProperties](Cornerstones/Swift/StoredProperties/StoredProperties.swift) to let any class quickly add support for sending observable events by simply adding `EventEmitter` protocol to the list of protocols for that class and adding a nested `Event` enum.

* [**Store**](Core/Store) A persistent store based on [Realm](https://github.com/realm/realm-cocoa). Allows for multithreaded store access, singleton storage and subscript access by singleton type, and key-value Realm storage as a replacement for `UserDefaults`.

* [**Network**](Core/Networking/Network/Network.swift) The network monitor.

* [**Requester**](Core/Networking/Network/Requester.swift) Provides a collection of stateless and stateful networking sessions.

* [**HTTPReactiveRequesting**](Core/Networking/HTTP/HTTPReactiveRequesting.swift) Lets networking sessions reactively make HTTP requests for data and JSON responses, reactively download and upload with progress and completion signal events.

* [**HTTPRequestRetrier**](Core/Networking/HTTP/HTTPRequestRetrier.swift) Lets timed out and other failed HTTP requests be retried.

* [**BackendAPIRequestPluginProvider**](Core/BackendAPI/Backend/BackendAPIRequestPluginProvider.swift) Lets plug into HTTP requests and observe responses, useful for plugging authentication tokens into HTTP requests and observing "unauthorized" responses.

* [**AuthService**](Core/Authentication/AuthService.swift) Reactively makes backend requests related to authentication and manages side effects.

* [**BearerAuthentication**](Core/Authentication/BearerAuthentication.swift) & [**BearerAuthenticationToken**](Core/Authentication/BearerAuthenticationToken.swift) An implementation of bearer authentication scheme.

* [**UserService**](Core/User/UserService.swift) Manages users.

* [**RemoteNotificationsService**](Core/RemoteNotifications/RemoteNotificationsService.swift) Registers and unregisters for remote notifications and handles device token upload to the backend.

* [**UIViewControllerBase**](Core/UI/UICore/UIViewControllerBase.swift) The base view controller.

* [**UIScener**](Core/UI/UICore/UIScener.swift) Manages screen transitions with pushing and presenting view controllers as well as setting the root view controller. Automatically embeds view controllers into `UINavigationController` with the hidden navigation bar to enable push transitions whenever needed.

* [**UIControls**](Core/UI/UIControls) A collection of stylized UI controls.

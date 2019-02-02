# SwiftAppCore

In this repository, you can get acquainted with my coding style and design approaches.

### App modularity

Modular app design, in which the app is composed of separate frameworks, is beneficial in coordinating team work on large projects as well as for practical reasons of keeping Xcode build times as quick as possible.

For large non-modular Swift projects, building the project after making any change in the code may take up to *30 seconds* of waiting time, while making a change to a Swift file in a modular project results in a build time that is only proportional to the size of that individual module, which is under 3 seconds in my experience. Therefore it's crucial to take the modular approach in designing an app aimed at constant growth.

### Cornerstones & Core

There are two centerpiece modules to my apps, **Cornerstones** framework and **Core** framework.

The mission of **Cornerstones** is to supplement and add convenience to the Apple's Foundation framework. The Cornerstones framework is completely agnostic about the app's business logic and deals with Swift language itself, Swift types, concurrency, basic UIKit and Core Animation, and networking entities.

The **Core** framework, on the other hand, provides components that power the app's essential functionality, which includes configuration, logging, FRP utilities, persistent store, error handling, networking and serialization, backend API, authentication, remote notifications, and core UI.

Both frameworks are written in Swift 4.2.

### Cornerstones Highlights



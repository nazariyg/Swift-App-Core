// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import UIKit

extension UIDevice: StoredProperties {

    // MARK: - Device Info

    /// Returns the iOS's version.
    public var iosVersion: String {
        return systemVersion
    }

    /// Returns the device's model.
    public var modelName: String {
        if let modelName = atomicStoredProperties.string[#function] {
            return modelName
        }

        let modelName = Self.modelName(fromIdentifier: machineIdentifier)
        atomicStoredProperties.string[#function] = modelName

        return modelName
    }

    /// Returns the device's PPI.
    public var pixelsPerInch: Double {
        if let pixelsPerInch = atomicStoredProperties.double[#function] {
            return pixelsPerInch
        }

        let pixelsPerInch = Self.pixelsPerInch(fromIdentifier: machineIdentifier)
        atomicStoredProperties.double[#function] = pixelsPerInch

        return pixelsPerInch
    }

    /// Returns whether currently running on an iPhone.
    public var isPhone: Bool {
        return userInterfaceIdiom == .phone
    }

    /// Returns whether currently running on an iPad.
    public var isPad: Bool {
        return userInterfaceIdiom == .pad
    }

    /// Returns whether currently running on an Apple TV.
    public var isTV: Bool {
        return userInterfaceIdiom == .tv
    }

    /// Returns whether the device has a native screen.
    public var hasNativeScreen: Bool {
        return isPhone || isPad
    }

    /// Returns whether this is one of the small screen (iPhone 5/SE) models.
    public var hasSmallScreen: Bool {
        let hasSmallScreen = UIScreen.main.bounds.width <= 320.0
        return hasSmallScreen
    }

    /// Returns whether this is an iPhone with a screen notch.
    public var isAnyIPhoneX: Bool {
        if let isAnyIPhoneX = atomicStoredProperties.bool[#function] {
            return isAnyIPhoneX
        }

        guard userInterfaceIdiom == .phone else { return false }
        let isAnyIPhoneX = modelName.containsCaseInsensitive(substring: "iPhone X")
        atomicStoredProperties.bool[#function] = isAnyIPhoneX

        return isAnyIPhoneX
    }

    /// The Apple's API returns a different device ID for every app installation. Therefore, we reuse the first ID we get or generate our own ID and
    /// use a permanent store to keep the ID in, without synchronizing the ID across devices.
    public var persistentID: String {
        if let persistentID = atomicStoredProperties.string[#function] {
            return persistentID
        }

        let persistentID: String

        let store = KeychainStore.local
        let deviceIDKey = "deviceID"
        if let storedID = store.string[deviceIDKey] {
            persistentID = storedID
        } else {
            persistentID = UUID().uuidString
            store.string[deviceIDKey] = persistentID
        }
        atomicStoredProperties.string[#function] = persistentID

        return persistentID
    }

    private var machineIdentifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }

    private typealias `Self` = UIDevice

}

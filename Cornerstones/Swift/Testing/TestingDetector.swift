// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation

public struct TestingDetector {

    private static let testingFlagEnvironmentVariableName = "XCTestConfigurationFilePath"

    static var isTesting: Bool = {
        let isTesting = ProcessInfo.processInfo.environment[testingFlagEnvironmentVariableName] != nil
        return isTesting
    }()

    static var isNotTesting: Bool = {
        return !isTesting
    }()

}

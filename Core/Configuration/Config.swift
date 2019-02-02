// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones

public enum ConfigEnvironment {
    case dev
    case prod
}

public protocol ConfigProtocol {
    var environment: ConfigEnvironment { get }
    var general: GeneralConfig { get }
    var backend: BackendConfig { get }
    var appearance: AppearanceConfig { get }
}

public final class Config: ConfigProtocol, SharedInstance {

    public typealias InstanceProtocol = ConfigProtocol
    public static let defaultInstance: InstanceProtocol = Config()

    // MARK: - Settings

    public let environment: ConfigEnvironment
    public let general: GeneralConfig
    public let backend: BackendConfig
    public let appearance: AppearanceConfig

    // MARK: - Lifecycle

    private init() {
        switch UserDefinedBuildSettings.string["environment"] {
        case "Dev":
            environment = .dev
        case "Prod":
            environment = .prod
        default:
            assertionFailure()
            environment = .prod
        }

        switch environment {
        case .dev:
            general = GeneralConfigDev()
            backend = BackendConfigDev()
        case .prod:
            general = GeneralConfigProd()
            backend = BackendConfigProd()
        }

        appearance = AppearanceConfig()
    }

}

// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import UIKit

public protocol UIScene {
    init()
    var isReady: Mp<Bool> { get }
    var viewController: UIViewController { get }
}

public protocol ParameterizedUIScene: UIScene {
    associatedtype Parameters
    func setParameters(_ parameters: Parameters)
}

public extension UIScene {

    var workerQueueSchedulerQos: DispatchQoS {
        return .userInitiated
    }

}

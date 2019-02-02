// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones
import UIKit

public protocol UISceneRouterProtocol {
    func go<Scene: UIScene>(_: Scene.Type)
    func go<Scene: ParameterizedUIScene>(_: Scene.Type, parameters: Scene.Parameters)
}

public final class UISceneRouter: SharedInstance {

    public typealias InstanceProtocol = UISceneRouterProtocol
    public static var defaultInstance: InstanceProtocol = DummyUISceneRouter()

}

private final class DummyUISceneRouter: UISceneRouterProtocol {
    func go<Scene: UIScene>(_: Scene.Type) {}
    func go<Scene: ParameterizedUIScene>(_: Scene.Type, parameters: Scene.Parameters) {}
}

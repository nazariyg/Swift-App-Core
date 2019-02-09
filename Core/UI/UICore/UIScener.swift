// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import UIKit
import Cornerstones
import ReactiveSwift
import Result

/// Manages transitions between scenes in a stack of scenes, with support for transition styles and tabs.
/// Automatically embeds every "up" ("present") and "set" scene into a UINavigationController to enable "next" ("push") transitions for subsequent scenes.

// MARK: - Protocol

public protocol UIScenerProtocol {

    /// Initializes the scener with an initial scene.
    func initialize(initialScene: UIScene)

    /// Initializes the scener with a set of initial scenes supervised by a tab controller.
    func initialize<TabsController: TabsControllerProtocol>(initialScenes: [UIScene], initialTabIndex: Int, tabsControllerType: TabsController.Type)

    /// Makes a "next" ("push") transition to a scene using the default transition style for "next" transitions.
    func next<Scene: UIScene>(_: Scene.Type)

    /// Makes a "next" ("push") transition to a scene using the specified transition style.
    func next<Scene: UIScene>(_: Scene.Type, transitionStyle: UISceneTransitionStyle)

    /// Makes an "up" ("present") transition to a scene using the default transition style for "up" transitions.
    func up<Scene: UIScene>(_: Scene.Type)

    /// Makes an "up" ("present") transition to a scene using the specified transition style.
    func up<Scene: UIScene>(_: Scene.Type, transitionStyle: UISceneTransitionStyle)

    /// Makes a "set" (root view controller replacement) transition to a scene using the default transition style for "set" transitions.
    func set<Scene: UIScene>(_: Scene.Type)

    /// Makes a "set" (root view controller replacement) transition to a scene using the specified transition style.
    func set<Scene: UIScene>(_: Scene.Type, transitionStyle: UISceneTransitionStyle)

    /// Makes a "next" ("push") transition to a parameterized scene using the default transition style for "next" transitions.
    func next<Scene: ParameterizedUIScene>(_: Scene.Type, parameters: Scene.Parameters)

    /// Makes a "next" ("push") transition to a parameterized scene using the specified transition style.
    func next<Scene: ParameterizedUIScene>(_: Scene.Type, parameters: Scene.Parameters, transitionStyle: UISceneTransitionStyle)

    /// Makes an "up" ("present") transition to a parameterized scene using the default transition style for "up" transitions.
    func up<Scene: ParameterizedUIScene>(_: Scene.Type, parameters: Scene.Parameters)

    /// Makes an "up" ("present") transition to a parameterized scene using the specified transition style.
    func up<Scene: ParameterizedUIScene>(_: Scene.Type, parameters: Scene.Parameters, transitionStyle: UISceneTransitionStyle)

    /// Makes a "tab" ("selectedIndex") transition to the scene currently at the top of the scene stack associated with the tab at the specified tab index.
    func tab(tabIndex: Int)

    /// Makes a "back" ("pop" or "dismiss") transition to the previous scene using the backward flavor of the transition style that was used
    /// to transition to the current scene, if any.
    func back()

    /// Traverses the scene stack back from the current scene in search for the scene of the specified type and makes a "pop" or "dismiss" transition
    /// using the backward flavor of the transition style that was used to transition to the found scene. The reverse traversal goes through
    /// any chain of "next" scenes, if such exist, and then through any chain of "up" scenes. The reverse traversal does not go beyond the last
    /// encountered scene in the first encountered chain of "up" scenes.
    func backTo<Scene: UIScene>(_: Scene.Type)

    /// Traverses the scene stack back from the current scene in search for the parameterized scene of the specified type and makes a "pop" or "dismiss"
    /// transition using the backward flavor of the transition style that was used to transition to the found scene. The reverse traversal goes through
    /// any chain of "next" scenes, if such exist, and then through any chain of "up" scenes. The reverse traversal does not go beyond the last
    /// encountered scene in the first encountered chain of "up" scenes.
    func backTo<Scene: ParameterizedUIScene>(_: Scene.Type, parameters: Scene.Parameters)

    // Called by UIViewControllerBase only.
    func _goingBack(outgoingViewController: UIViewController)

}

public protocol TabsControllerProtocolBase: class {}
public protocol TabsControllerProtocol: TabsControllerProtocolBase {
    init()
    var viewControllers: [UIViewController]? { get set }
    var selectedIndex: Int { get set }
}

// MARK: - Implementation

private let logCategory = "UI"

public final class UIScener: UIScenerProtocol, SharedInstance {

    public typealias InstanceProtocol = UIScenerProtocol
    public static let defaultInstance: InstanceProtocol = UIScener()

    private enum SceneNodeType {
        case root
        case next
        case up
    }

    private struct SceneNode {
        let type: SceneNodeType
        let scene: UIScene
        let uiViewController: UIViewController
        let transitionStyle: UISceneTransitionStyle?
    }

    private var sceneNodeStack: [[SceneNode]] = []
    private var tabsController: TabsControllerProtocol?
    private var currentTabIndex = 0
    private var currentlyActiveTransition: UISceneTransition?

    // MARK: - Lifecycle

    private init() {}

    public func initialize(initialScene: UIScene) {
        DispatchQueue.main.executeSync {
            log.info("Initializing the UI with \(stringType(initialScene))", logCategory)

            let rootViewController = Self.embedInNavigationControllerIfNeeded(initialScene.viewController)
            UIRootViewControllerContainer.shared.setRootViewController(rootViewController)

            let sceneNode = SceneNode(type: .root, scene: initialScene, uiViewController: rootViewController, transitionStyle: nil)
            sceneNodeStack = [[sceneNode]]
        }
    }

    public func initialize<TabsController: TabsControllerProtocol>(
        initialScenes: [UIScene], initialTabIndex: Int, tabsControllerType: TabsController.Type) {

        DispatchQueue.main.executeSync {
            log.info("Initializing the UI with \(stringType(TabsController.self))", logCategory)

            let viewControllers = initialScenes.map { scene in Self.embedInNavigationControllerIfNeeded(scene.viewController) }

            let tabsController = TabsController()
            tabsController.viewControllers = viewControllers
            tabsController.selectedIndex = initialTabIndex
            self.tabsController = tabsController

            UIRootViewControllerContainer.shared.setRootViewController(tabsController as! UIViewController)

            sceneNodeStack = initialScenes.enumerated().map { index, scene in
                return [SceneNode(type: .root, scene: scene, uiViewController: viewControllers[index], transitionStyle: nil)]
            }
            currentTabIndex = initialTabIndex
        }
    }

    // MARK: - Transitions

    public func next<Scene: UIScene>(_: Scene.Type) {
        next(Scene.self, transitionStyle: .defaultNext)
    }

    public func next<Scene: UIScene>(_: Scene.Type, transitionStyle: UISceneTransitionStyle) {
        DispatchQueue.main.executeSync {
            guard let navigationController = currentSceneNode.scene.viewController.navigationController else {
                assertionFailure()
                return
            }

            let scene = Scene()
            let viewController = scene.viewController

            let sceneNode = SceneNode(type: .next, scene: scene, uiViewController: viewController, transitionStyle: transitionStyle)
            pushSceneNode(sceneNode)

            currentlyActiveTransition = transitionStyle.transition
            navigationController.delegate = currentlyActiveTransition

            log.info("Making a \"next\" transition to \(stringType(Scene.self))", logCategory)

            scene.isReady.producer
                .filter { $0 }
                .observe(on: UIScheduler())
                .startWithValues { _ in
                    navigationController.pushViewController(viewController, animated: true)
                }
        }
    }

    public func up<Scene: UIScene>(_: Scene.Type) {
        up(Scene.self, transitionStyle: .defaultUp)
    }

    public func up<Scene: UIScene>(_: Scene.Type, transitionStyle: UISceneTransitionStyle) {
        DispatchQueue.main.executeSync {
            let scene = Scene()
            let viewController = Self.embedInNavigationControllerIfNeeded(scene.viewController)

            let sceneNode = SceneNode(type: .up, scene: scene, uiViewController: viewController, transitionStyle: transitionStyle)
            let currentScene = currentSceneNode.scene
            pushSceneNode(sceneNode)

            currentlyActiveTransition = transitionStyle.transition
            viewController.transitioningDelegate = currentlyActiveTransition

            log.info("Making an \"up\" transition to \(stringType(Scene.self))", logCategory)

            scene.isReady.producer
                .filter { $0 }
                .observe(on: UIScheduler())
                .startWithValues { _ in
                    currentScene.viewController.present(viewController, animated: true)
                }
        }
    }

    public func set<Scene: UIScene>(_: Scene.Type) {
        set(Scene.self, transitionStyle: .defaultSet)
    }

    public func set<Scene: UIScene>(_: Scene.Type, transitionStyle: UISceneTransitionStyle) {
        DispatchQueue.main.executeSync {
            let scene = Scene()
            let rootViewController = Self.embedInNavigationControllerIfNeeded(scene.viewController)

            let sceneNode = SceneNode(type: .root, scene: scene, uiViewController: rootViewController, transitionStyle: nil)
            sceneNodeStack = [[sceneNode]]

            log.info("Setting the root scene to \(stringType(Scene.self))", logCategory)

            scene.isReady.producer
                .filter { $0 }
                .observe(on: UIScheduler())
                .startWithValues { _ in
                    UIRootViewControllerContainer.shared.setRootViewController(rootViewController, transitionStyle: transitionStyle)
                }
        }
    }

    public func next<Scene: ParameterizedUIScene>(_: Scene.Type, parameters: Scene.Parameters) {
        next(Scene.self, parameters: parameters, transitionStyle: .defaultNext)
    }

    public func next<Scene: ParameterizedUIScene>(_: Scene.Type, parameters: Scene.Parameters, transitionStyle: UISceneTransitionStyle) {
        DispatchQueue.main.executeSync {
            guard let navigationController = currentSceneNode.scene.viewController.navigationController else {
                assertionFailure()
                return
            }

            let scene = Scene()
            scene.setParameters(parameters)
            let viewController = scene.viewController

            let sceneNode = SceneNode(type: .next, scene: scene, uiViewController: viewController, transitionStyle: nil)
            pushSceneNode(sceneNode)

            currentlyActiveTransition = transitionStyle.transition
            navigationController.delegate = currentlyActiveTransition

            log.info("Making a \"next\" transition to \(stringType(Scene.self))", logCategory)

            scene.isReady.producer
                .filter { $0 }
                .observe(on: UIScheduler())
                .startWithValues { _ in
                    navigationController.pushViewController(viewController, animated: true)
                }
        }
    }

    public func up<Scene: ParameterizedUIScene>(_: Scene.Type, parameters: Scene.Parameters) {
        up(Scene.self, parameters: parameters, transitionStyle: .defaultUp)
    }

    public func up<Scene: ParameterizedUIScene>(_: Scene.Type, parameters: Scene.Parameters, transitionStyle: UISceneTransitionStyle) {
        DispatchQueue.main.executeSync {
            let scene = Scene()
            scene.setParameters(parameters)
            let viewController = Self.embedInNavigationControllerIfNeeded(scene.viewController)

            let sceneNode = SceneNode(type: .up, scene: scene, uiViewController: viewController, transitionStyle: nil)
            let currentScene = currentSceneNode.scene
            pushSceneNode(sceneNode)

            currentlyActiveTransition = transitionStyle.transition
            viewController.transitioningDelegate = currentlyActiveTransition

            log.info("Making an \"up\" transition to \(stringType(Scene.self))", logCategory)

            scene.isReady.producer
                .filter { $0 }
                .observe(on: UIScheduler())
                .startWithValues { _ in
                    currentScene.viewController.present(viewController, animated: true)
                }
        }
    }

    public func tab(tabIndex: Int) {
        DispatchQueue.main.executeSync {
            guard let tabsController = tabsController else {
                assertionFailure()
                return
            }

            if let firstSceneNode = sceneNodeStack[currentTabIndex].first,
               let tabBarController = firstSceneNode.uiViewController.tabBarController,
               let transition = firstSceneNode.transitionStyle?.transition {

                currentlyActiveTransition = transition
                tabBarController.delegate = currentlyActiveTransition
            }

            log.info("Making a \"tab\" transition to \(stringType(sceneNodeStack[tabIndex].first!.scene))", logCategory)
            tabsController.selectedIndex = tabIndex

            currentTabIndex = tabIndex
        }
    }

    public func back() {
        DispatchQueue.main.executeSync {
            assert(sceneNodeCount > 1)
            switch currentSceneNode.type {
            case .next:
                guard let navigationController = currentSceneNode.scene.viewController.navigationController else {
                    assertionFailure()
                    return
                }
                if let transition = currentSceneNode.transitionStyle?.transition {
                    currentlyActiveTransition = transition
                    navigationController.delegate = transition
                }
                log.info("Making a \"back\" transition to \(stringType(backSceneNode.scene))", logCategory)
                popSceneNode()
                navigationController.popViewController(animated: true)
            case .up:
                guard let presentingViewController = currentSceneNode.uiViewController.presentingViewController else {
                    assertionFailure()
                    return
                }
                if let transition = currentSceneNode.transitionStyle?.transition {
                    currentlyActiveTransition = transition
                    currentSceneNode.uiViewController.transitioningDelegate = transition
                }
                log.info("Making a \"back\" transition to \(stringType(backSceneNode.scene))", logCategory)
                popSceneNode()
                presentingViewController.dismiss(animated: true)
            default:
                assertionFailure()
            }
        }
    }

    public func backTo<Scene: UIScene>(_: Scene.Type) {
        DispatchQueue.main.executeSync {
            if currentSceneNode.scene is Scene {
                return
            }

            func backToPresenting() {
                for index in (0..<(sceneNodeCount - 1)).reversed() {
                    let previousSceneNode = sceneNodeStack[currentTabIndex][index]
                    let nextSceneNode = sceneNodeStack[currentTabIndex][index + 1]
                    if previousSceneNode.scene is Scene {
                        guard let presentingViewController = nextSceneNode.uiViewController.presentingViewController else {
                            assertionFailure()
                            return
                        }
                        if let transition = currentSceneNode.transitionStyle?.transition {
                            currentlyActiveTransition = transition
                            currentSceneNode.uiViewController.transitioningDelegate = transition
                        }
                        sceneNodeStack[currentTabIndex].removeSubrange((index + 1)...)
                        log.info("Making a \"back\" transition to \(stringType(Scene.self))", logCategory)
                        presentingViewController.dismiss(animated: true)
                        return
                    }
                }
                assertionFailure()
            }

            if currentSceneNode.type == .next {
                for index in (0..<(sceneNodeCount - 1)).reversed() {
                    let previousSceneNode = sceneNodeStack[currentTabIndex][index]
                    let nextSceneNode = sceneNodeStack[currentTabIndex][index + 1]
                    if nextSceneNode.type != .next { break }
                    if previousSceneNode.scene is Scene {
                        guard let navigationController = nextSceneNode.scene.viewController.navigationController else {
                            assertionFailure()
                            return
                        }
                        if let transition = currentSceneNode.transitionStyle?.transition {
                            currentlyActiveTransition = transition
                            navigationController.delegate = transition
                        }
                        sceneNodeStack[currentTabIndex].removeSubrange((index + 1)...)
                        log.info("Making a \"back\" transition to \(stringType(Scene.self))", logCategory)
                        navigationController.popToViewController(previousSceneNode.scene.viewController, animated: true)
                        return
                    }
                }

                backToPresenting()
            } else if currentSceneNode.type == .up {
                backToPresenting()
            } else {
                assertionFailure()
            }
        }
    }

    public func backTo<Scene: ParameterizedUIScene>(_: Scene.Type, parameters: Scene.Parameters) {
        DispatchQueue.main.executeSync {

            func backToPresenting() {
                for index in (0..<(sceneNodeCount - 1)).reversed() {
                    let previousSceneNode = sceneNodeStack[currentTabIndex][index]
                    let nextSceneNode = sceneNodeStack[currentTabIndex][index + 1]
                    if let parameterizedScene = previousSceneNode.scene as? Scene {
                        guard let presentingViewController = nextSceneNode.uiViewController.presentingViewController else {
                            assertionFailure()
                            return
                        }
                        parameterizedScene.setParameters(parameters)
                        if let transition = currentSceneNode.transitionStyle?.transition {
                            currentlyActiveTransition = transition
                            currentSceneNode.uiViewController.transitioningDelegate = transition
                        }
                        sceneNodeStack[currentTabIndex].removeSubrange((index + 1)...)
                        log.info("Making a \"back\" transition to \(stringType(Scene.self))", logCategory)
                        presentingViewController.dismiss(animated: true)
                        return
                    }
                }
                assertionFailure()
            }

            if currentSceneNode.type == .next {
                for index in (0..<(sceneNodeCount - 1)).reversed() {
                    let previousSceneNode = sceneNodeStack[currentTabIndex][index]
                    let nextSceneNode = sceneNodeStack[currentTabIndex][index + 1]
                    if nextSceneNode.type != .next { break }
                    if let parameterizedScene = previousSceneNode.scene as? Scene {
                        guard let navigationController = nextSceneNode.scene.viewController.navigationController else {
                            assertionFailure()
                            return
                        }
                        parameterizedScene.setParameters(parameters)
                        if let transition = currentSceneNode.transitionStyle?.transition {
                            currentlyActiveTransition = transition
                            navigationController.delegate = transition
                        }
                        sceneNodeStack[currentTabIndex].removeSubrange((index + 1)...)
                        log.info("Making a \"back\" transition to \(stringType(Scene.self))", logCategory)
                        navigationController.popToViewController(parameterizedScene.viewController, animated: true)
                        return
                    }
                }

                backToPresenting()
            } else if currentSceneNode.type == .up {
                backToPresenting()
            } else {
                assertionFailure()
            }
        }
    }

    public func _goingBack(outgoingViewController: UIViewController) {
        DispatchQueue.main.executeSync {
            guard
                currentSceneNode.type == .next,
                currentSceneNode.scene.viewController === outgoingViewController
            else { return }

            assert(sceneNodeCount > 1)

            popSceneNode()
        }
    }

    // MARK: - Private

    private static func embedInNavigationControllerIfNeeded(_ viewController: UIViewController) -> UIViewController {
        if !(viewController is UINavigationController) &&
           !(viewController is UITabBarController) &&
           !(viewController is UISplitViewController) {
            // Embed into a UINavigationController.
            return UIEmbeddingNavigationController(rootViewController: viewController)
        } else {
            // Use as is.
            return viewController
        }
    }

    private var currentSceneNode: SceneNode {
        return sceneNodeStack[currentTabIndex].last!
    }

    private func pushSceneNode(_ sceneNode: SceneNode) {
        return sceneNodeStack[currentTabIndex].append(sceneNode)
    }

    private func popSceneNode() {
        sceneNodeStack[currentTabIndex].removeLast()
    }

    private var sceneNodeCount: Int {
        return sceneNodeStack[currentTabIndex].count
    }

    private var backSceneNode: SceneNode {
        let lastIndex = sceneNodeStack[currentTabIndex].lastIndex
        return sceneNodeStack[currentTabIndex][lastIndex - 1]
    }

    private typealias `Self` = UIScener

}

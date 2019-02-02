// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import UIKit
import Cornerstones

// MARK: - Protocol

protocol UIContainerRootViewControllerProtocol {
    func setRootViewController(_ viewController: UIViewController)
    func setRootViewController(_ viewController: UIViewController, transitionStyle: UISceneTransitionStyle)
    var view: UIView! { get }
}

// MARK: - Implementation

final class UIRootViewControllerContainer: UIViewController, UIContainerRootViewControllerProtocol, SharedInstance {

    typealias InstanceProtocol = UIContainerRootViewControllerProtocol
    static let defaultInstance: InstanceProtocol = UIRootViewControllerContainer()

    private var rootViewController: UIViewController?

    // MARK: - Lifecycle

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Config.shared.appearance.defaultBackgroundColor
    }

    // MARK: - Root view controller

    func setRootViewController(_ viewController: UIViewController) {
        setRootViewController(viewController, transitionStyle: .defaultSet)
    }

    func setRootViewController(_ viewController: UIViewController, transitionStyle: UISceneTransitionStyle) {
        DispatchQueue.main.executeSync {
            if let existingViewController = rootViewController {
                existingViewController.willMove(toParent: nil)
                addChild(viewController)
                if transitionStyle != .system,
                   let transitionAnimation = transitionStyle.transition.childViewControllerReplacementAnimation {

                    transition(
                        from: existingViewController, to: viewController,
                        duration: transitionAnimation.duration, options: transitionAnimation.options,
                        animations: nil, completion: { _ in
                            existingViewController.removeFromParent()
                            viewController.didMove(toParent: self)
                        })
                } else {
                    transition(
                        from: existingViewController, to: viewController,
                        duration: 0, options: [],
                        animations: nil, completion: { _ in
                            existingViewController.removeFromParent()
                            viewController.didMove(toParent: self)
                        })
                }
            } else {
                addChild(viewController)
                with(view!, viewController.view!) {
                    $0.addSubview($1)
                    $1.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        $1.leadingAnchor.constraint(equalTo: $0.leadingAnchor),
                        $1.trailingAnchor.constraint(equalTo: $0.trailingAnchor),
                        $1.topAnchor.constraint(equalTo: $0.topAnchor),
                        $1.bottomAnchor.constraint(equalTo: $0.bottomAnchor)
                    ])
                }
                viewController.didMove(toParent: self)
            }
            rootViewController = viewController
        }
    }

    public override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return true
    }

    public override var childForStatusBarHidden: UIViewController? {
        return rootViewController
    }

    public override var childForStatusBarStyle: UIViewController? {
        return rootViewController
    }

    public override var childForHomeIndicatorAutoHidden: UIViewController? {
        return rootViewController
    }

    public override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
        return rootViewController
    }

}

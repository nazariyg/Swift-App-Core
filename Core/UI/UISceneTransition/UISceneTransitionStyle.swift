// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import UIKit

public enum UISceneTransitionStyle {

    case system
    case defaultNext
    case defaultUp
    case defaultSet

    public var transition: UISceneTransition {
        switch self {
        case .system:
            let transition = UISceneTransition()
            return transition
        case .defaultNext:
            let transition =
                UISceneTransition(
                    animationControllerForPresentation: ShiftyZoomyAnimationController(isReversed: false),
                    animationControllerForDismissal: ShiftyZoomyAnimationController(isReversed: true))
            return transition
        case .defaultUp:
            let transition =
                UISceneTransition(
                    animationControllerForPresentation: SlidyZoomyAnimationController(isReversed: false),
                    animationControllerForDismissal: SlidyZoomyAnimationController(isReversed: true))
            return transition
        case .defaultSet:
            let animation =
                UISceneTransition.ChildViewControllerReplacementAnimation(
                    duration: 0.33, options: .transitionCrossDissolve)
            let transition = UISceneTransition(childViewControllerReplacementAnimation: animation)
            return transition
        }

    }

}

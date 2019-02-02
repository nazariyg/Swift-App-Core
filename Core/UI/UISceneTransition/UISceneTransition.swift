// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import UIKit

public final class UISceneTransition: NSObject {

    struct ChildViewControllerReplacementAnimation {
        let duration: TimeInterval
        let options: UIView.AnimationOptions
    }

    private(set) var animationControllerForPresentation: UIViewControllerAnimatedTransitioning?
    private(set) var animationControllerForDismissal: UIViewControllerAnimatedTransitioning?
    private(set) var presentationController: UIPresentationController?
    private(set) var interactionControllerForPresentation: UIViewControllerInteractiveTransitioning?
    private(set) var interactionControllerForDismissal: UIViewControllerInteractiveTransitioning?
    private(set) var childViewControllerReplacementAnimation: ChildViewControllerReplacementAnimation?

    override init() {
        super.init()
    }

    init(animationController: UIViewControllerAnimatedTransitioning) {
        self.animationControllerForPresentation = animationController
    }

    init(
        animationControllerForPresentation: UIViewControllerAnimatedTransitioning,
        animationControllerForDismissal: UIViewControllerAnimatedTransitioning) {

        self.animationControllerForPresentation = animationControllerForPresentation
        self.animationControllerForDismissal = animationControllerForDismissal
    }

    init(
        animationControllerForPresentation: UIViewControllerAnimatedTransitioning,
        animationControllerForDismissal: UIViewControllerAnimatedTransitioning,
        presentationController: UIPresentationController) {

        self.animationControllerForPresentation = animationControllerForPresentation
        self.animationControllerForDismissal = animationControllerForDismissal
        self.presentationController = presentationController
    }

    init(
        animationControllerForPresentation: UIViewControllerAnimatedTransitioning,
        animationControllerForDismissal: UIViewControllerAnimatedTransitioning,
        interactionControllerForPresentation: UIViewControllerInteractiveTransitioning,
        interactionControllerForDismissal: UIViewControllerInteractiveTransitioning) {

        self.animationControllerForPresentation = animationControllerForPresentation
        self.animationControllerForDismissal = animationControllerForDismissal
        self.interactionControllerForPresentation = interactionControllerForPresentation
        self.interactionControllerForDismissal = interactionControllerForDismissal
    }

    init(
        animationControllerForPresentation: UIViewControllerAnimatedTransitioning,
        animationControllerForDismissal: UIViewControllerAnimatedTransitioning,
        presentationController: UIPresentationController,
        interactionControllerForPresentation: UIViewControllerInteractiveTransitioning,
        interactionControllerForDismissal: UIViewControllerInteractiveTransitioning) {

        self.animationControllerForPresentation = animationControllerForPresentation
        self.animationControllerForDismissal = animationControllerForDismissal
        self.presentationController = presentationController
        self.interactionControllerForPresentation = interactionControllerForPresentation
        self.interactionControllerForDismissal = interactionControllerForDismissal
    }

    init(childViewControllerReplacementAnimation: ChildViewControllerReplacementAnimation) {
        self.childViewControllerReplacementAnimation = childViewControllerReplacementAnimation
    }

}

extension UISceneTransition: UIViewControllerTransitioningDelegate {

    public func animationController(
        forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return animationControllerForPresentation
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animationControllerForDismissal
    }

    public func presentationController(
        forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {

        return presentationController
    }

    public func interactionControllerForPresentation(
        using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

        return interactionControllerForPresentation
    }

    public func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

        return interactionControllerForDismissal
    }

}

extension UISceneTransition: UINavigationControllerDelegate {

    public func navigationController(
        _ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        switch operation {
        case .push: return animationControllerForPresentation
        case .pop: return animationControllerForDismissal
        default: return nil
        }
    }

    public func navigationController(
        _ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {

        return interactionControllerForPresentation
    }

}

extension UISceneTransition: UITabBarControllerDelegate {

    public func tabBarController(
        _ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {

        return animationControllerForPresentation
    }

    public func tabBarController(
        _ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {

        return interactionControllerForPresentation
    }

}

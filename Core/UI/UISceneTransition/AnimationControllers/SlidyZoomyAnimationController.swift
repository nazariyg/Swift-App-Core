// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import UIKit
import Cornerstones

final class SlidyZoomyAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    private static let animationDuration: TimeInterval = 0.75
    private static let zoomOutRatio: CGFloat = 0.9
    private static let minAlpha: CGFloat = 0.25
    private static let maxCornerRadius: CGFloat = 16
    private static let animationDampingRatio: CGFloat = 0.8

    private let isReversed: Bool
    private var animator: UIViewImplicitlyAnimating?

    init(isReversed: Bool) {
        self.isReversed = isReversed
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Self.animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = interruptibleAnimator(using: transitionContext)
        animator.startAnimation()
    }

    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        if let animator = self.animator {
            return animator
        }

        let context = transitionContext.unpack()

        let bottomOuterFrame = context.toViewEndFrame.offsetBy(dx: 0, dy: context.fromViewStartFrame.height)
        let zoomOutTransform = CGAffineTransform(scaleX: Self.zoomOutRatio, y: Self.zoomOutRatio)

        if !isReversed {
            context.containerView.insertSubview(context.toView, aboveSubview: context.fromView)

            context.toView.frame = bottomOuterFrame
            context.toView.layer.cornerRadius = Self.maxCornerRadius
            context.toView.layer.masksToBounds = true
        } else {
            context.containerView.insertSubview(context.toView, belowSubview: context.fromView)

            context.toView.frame = context.toViewEndFrame
            context.toView.transform = zoomOutTransform
            context.toView.alpha = Self.minAlpha
            context.toView.layer.cornerRadius = Self.maxCornerRadius
            context.toView.layer.masksToBounds = true
        }

        let animator =
            UIViewPropertyAnimator(duration: Self.animationDuration, dampingRatio: Self.animationDampingRatio,
                animations: { [isReversed] in
                    if !isReversed {
                        context.fromView.transform = zoomOutTransform
                        context.fromView.bounds = context.fromViewStartFrame.size.rect
                        context.fromView.alpha = Self.minAlpha
                        context.fromView.layer.cornerRadius = Self.maxCornerRadius
                        context.fromView.layer.masksToBounds = true

                        context.toView.frame = context.toViewEndFrame
                        context.toView.layer.cornerRadius = 0
                    } else {
                        context.fromView.frame = bottomOuterFrame
                        context.fromView.layer.cornerRadius = Self.maxCornerRadius
                        context.fromView.layer.masksToBounds = true

                        context.toView.transform = .identity
                        context.toView.bounds = context.toViewEndFrame.size.rect
                        context.toView.alpha = 1
                        context.toView.layer.cornerRadius = 0
                    }
                })

        animator.addCompletion { _ in
            context.fromView.transform = .identity
            context.fromView.frame = context.fromViewStartFrame
            context.fromView.alpha = 1
            context.fromView.sharpenCorners()

            context.toView.transform = .identity
            context.toView.frame = context.toViewEndFrame
            context.toView.alpha = 1
            context.toView.sharpenCorners()

            transitionContext.completeTransition(true)
        }

        self.animator = animator
        return animator
    }

    func animationEnded(_ transitionCompleted: Bool) {
        animator = nil
    }

    private typealias `Self` = SlidyZoomyAnimationController

}

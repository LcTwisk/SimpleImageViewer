import UIKit

final class ImageViewerTransitioningHandler: NSObject {
    fileprivate let dismissalTransition: ImageViewerDismissalTransition
    fileprivate let toImageView: UIImageView
    fileprivate let fromImageView: UIImageView
    
    var dismissInteractively = false
    
    init(fromImageView: UIImageView, toImageView: UIImageView) {
        self.dismissalTransition = ImageViewerDismissalTransition(fromImageView: toImageView, toImageView: fromImageView)
        self.fromImageView = fromImageView
        self.toImageView = toImageView
        super.init()
    }
    
    func updateInteractiveTransition(transform: CGAffineTransform) {
        dismissalTransition.updateTranslation(transform: transform)
    }
    
    func updateInteractiveTransition(percentage: CGFloat) {
        dismissalTransition.updatePercentage(percentage)
    }
    
    func finishInteractiveTransition() {
        dismissalTransition.finishTransition()
    }
}

extension ImageViewerTransitioningHandler: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImageViewerPresentationTransition(fromImageView: fromImageView)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissalTransition
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return dismissInteractively ? dismissalTransition : nil
    }
}

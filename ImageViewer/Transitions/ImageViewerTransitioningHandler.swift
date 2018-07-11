import UIKit

final class ImageViewerTransitioningHandler: NSObject {
    fileprivate let presentationTransition: ImageViewerPresentationTransition
    fileprivate let dismissalTransition: ImageViewerDismissalTransition
    
    let dismissalInteractor: ImageViewerDismissalInteractor
    
    var dismissInteractively = false
    
    init(fromImageView: UIImageView, toImageView: UIImageView, fromImage: UIImage?, animatingRadius: Bool) {
        self.presentationTransition = ImageViewerPresentationTransition(fromImageView: fromImageView, fromImage: fromImage, animatingRadius: animatingRadius)
        self.dismissalTransition = ImageViewerDismissalTransition(fromImageView: toImageView, toImageView: fromImageView, animatingRadius: animatingRadius)
        self.dismissalInteractor = ImageViewerDismissalInteractor(transition: dismissalTransition)
        super.init()
    }
}

extension ImageViewerTransitioningHandler: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentationTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissalTransition
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return dismissInteractively ? dismissalInteractor : nil
    }
}

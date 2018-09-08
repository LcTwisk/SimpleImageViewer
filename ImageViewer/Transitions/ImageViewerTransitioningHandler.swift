import UIKit

final class ImageViewerTransitioningHandler: NSObject {
    private let presentationTransition: ImageViewerPresentationTransition
    private let dismissalTransition: ImageViewerDismissalTransition
    
    let dismissalInteractor: ImageViewerDismissalInteractor
    
    var dismissInteractively = false
    
    init(fromImageView: UIImageView, toAssetView: UIView) {
        self.presentationTransition = ImageViewerPresentationTransition(fromImageView: fromImageView)
        self.dismissalTransition = ImageViewerDismissalTransition(fromAssetView: toAssetView, toImageView: fromImageView)
        self.dismissalInteractor = ImageViewerDismissalInteractor(transition: dismissalTransition)
        super.init()
    }
    
    func update(dismissImage: UIImage?) {
        dismissalTransition.update(dismissImage: dismissImage)
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

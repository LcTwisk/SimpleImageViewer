import UIKit

final class ImageViewerPresentationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let fromImageView: UIImageView
    
    private let animatingRadius: Bool
    
    init(fromImageView: UIImageView, animatingRadius: Bool) {
        self.fromImageView = fromImageView
        self.animatingRadius = animatingRadius
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        let fromParentView = fromImageView.superview!

        let transitionImageView = AnimatableImageView()
        transitionImageView.image = fromImageView.image
        if animatingRadius {
            transitionImageView.setCornerRadius(fromImageView.frame.width / 2)
        }
        transitionImageView.frame = fromParentView.convert(fromImageView.frame, to: nil)
        transitionImageView.contentMode = fromImageView.contentMode
        
        let fadeView = UIView(frame: containerView.bounds)
        fadeView.backgroundColor = .black
        fadeView.alpha = 0.0
        
        toView.frame = containerView.bounds
        toView.isHidden = true
        fromImageView.isHidden = true
        
        containerView.addSubview(toView)
        containerView.addSubview(fadeView)
        containerView.addSubview(transitionImageView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,  animations: {
            transitionImageView.contentMode = .scaleAspectFit
            transitionImageView.frame = containerView.bounds
            transitionImageView.setCornerRadius(0)
            fadeView.alpha = 1.0
        }, completion: { _ in
            toView.isHidden = false
            fadeView.removeFromSuperview()
            transitionImageView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}

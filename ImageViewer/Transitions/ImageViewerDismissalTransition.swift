import UIKit

final class ImageViewerDismissalTransition: NSObject, UIViewControllerAnimatedTransitioning {
    fileprivate var transitionContext: UIViewControllerContextTransitioning?
    
    fileprivate let fromImageView: UIImageView
    fileprivate let toImageView: UIImageView
    
    fileprivate var animatableImageview = AnimatableImageView()
    fileprivate var fromView: UIView?
    fileprivate var fadeView = UIView()
    
    fileprivate var translationTransform: CGAffineTransform = CGAffineTransform.identity {
        didSet { updateTransform() }
    }
    
    fileprivate var scaleTransform: CGAffineTransform = CGAffineTransform.identity {
        didSet { updateTransform() }
    }
    
    init(fromImageView: UIImageView, toImageView: UIImageView) {
        self.fromImageView = fromImageView
        self.toImageView = toImageView
        super.init()
    }
    
    func update(transform: CGAffineTransform) {
        translationTransform = transform
    }
    
    func update(percentage: CGFloat) {
        let invertedPercentage = 1.0 - percentage
        fadeView.alpha = invertedPercentage
        scaleTransform = CGAffineTransform(scaleX: invertedPercentage, y: invertedPercentage)
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        start(transitionContext)
        finish()
    }

    func start(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        let container = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { return }
        guard let image = toImageView.image else { return }
        
        fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        
        animatableImageview.image = image
        animatableImageview.frame = container.bounds
        animatableImageview.contentMode = .scaleAspectFit
        
        fadeView.frame = container.bounds
        fadeView.backgroundColor = .black
        
        fromView?.isHidden = true
        toView.frame = transitionContext.finalFrame(for: toViewController)
        
        container.addSubview(toView)
        container.addSubview(fadeView)
        container.addSubview(animatableImageview)
    }
    
    func finish() {
        guard let parentView = toImageView.superview else { return }
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut,  animations: {
            self.animatableImageview.contentMode = self.toImageView.contentMode
            self.animatableImageview.transform = CGAffineTransform.identity
            self.animatableImageview.frame = parentView.convert(self.toImageView.frame, to: UIScreen.main.coordinateSpace)
            self.fadeView.alpha = 0.0
        }, completion: { completed in
            self.toImageView.isHidden = false
            self.fadeView.removeFromSuperview()
            self.animatableImageview.removeFromSuperview()
            self.fromView?.removeFromSuperview()
            self.transitionContext?.completeTransition(completed)
        })
    }
}

private extension ImageViewerDismissalTransition {
    func updateTransform() {
        animatableImageview.transform = scaleTransform.concatenating(translationTransform)
    }
}

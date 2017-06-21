import UIKit

final class ImageViewerDismissalTransition: NSObject, UIViewControllerAnimatedTransitioning {
    fileprivate var transitionContext: UIViewControllerContextTransitioning?
    
    fileprivate let fromImageView: UIImageView
    fileprivate let toImageView: UIImageView
    
    fileprivate var animatableImageview = AnimatableImageView()
    fileprivate var fromView: UIView?
    fileprivate var fadeView = UIView()
    
    enum TransitionState {
        case start
        case end
    }
    
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
        guard
            let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from),
            let image = fromImageView.image ?? toImageView.image else {
                transitionContext.completeTransition(true)
                return
        }
        
        self.fromView = fromView
        
        fromView.isHidden = true
        transitionContext.view(forKey: UITransitionContextViewKey.to)?.isHidden = false
        animatableImageview.image = image
        animatableImageview.frame = container.bounds
        animatableImageview.contentMode = .scaleAspectFit
        
        fadeView.frame = container.bounds
        fadeView.backgroundColor = .black
        
        container.addSubview(fadeView)
        container.addSubview(animatableImageview)
    }
    
    func cancel() {
        transitionContext?.cancelInteractiveTransition()
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: apply(state: .start),
                       completion: { completed in
                        self.fromView?.isHidden = false
                        self.animatableImageview.removeFromSuperview()
                        self.fadeView.removeFromSuperview()
                        self.transitionContext?.completeTransition(false)
        })
    }
    
    func finish() {
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: apply(state: .end),
                       completion: { completed in
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
    
    func apply(state: TransitionState) -> () -> Void  {
        return {
            switch state {
            case .start:
                self.animatableImageview.contentMode = .scaleAspectFit
                self.animatableImageview.transform = .identity
                self.animatableImageview.frame = self.fromImageView.frame
                self.fadeView.alpha = 1.0
            case .end:
                self.animatableImageview.contentMode = self.toImageView.contentMode
                self.animatableImageview.transform = .identity
                self.animatableImageview.frame = self.toImageView.superview!.convert(self.toImageView.frame, to: UIScreen.main.coordinateSpace)
                self.fadeView.alpha = 0.0
            }
        }
    }
}

import UIKit

final class ImageViewerDismissalTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private weak var transitionContext: UIViewControllerContextTransitioning?
    
    private let fromAssetView: UIView
    private var toImageView: UIImageView
    private var dismissImage: UIImage?
    
    private var animatableImageview = AnimatableImageView()
    private var fromView: UIView?
    private var fadeView = UIView()
    
    enum TransitionState {
        case start
        case end
    }
    
    private var translationTransform: CGAffineTransform = CGAffineTransform.identity {
        didSet { updateTransform() }
    }
    
    private var scaleTransform: CGAffineTransform = CGAffineTransform.identity {
        didSet { updateTransform() }
    }
    
    init(fromAssetView: UIView, toImageView: UIImageView) {
        self.fromAssetView = fromAssetView
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
    
    func update(dismissImage: UIImage?) {
        self.dismissImage = dismissImage
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
        self.fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let containerView = transitionContext.containerView
        let fromSuperView = fromAssetView.superview!
        
        let image = dismissImage ?? toImageView.image
        
        animatableImageview.image = image
        animatableImageview.frame = fromSuperView.convert(fromAssetView.frame, to: nil)
        animatableImageview.contentMode = .scaleAspectFit
        
        fromView?.isHidden = true
        fadeView.frame = containerView.bounds
        fadeView.backgroundColor = .black
        
        containerView.addSubview(fadeView)
        containerView.addSubview(animatableImageview)
    }
    
    func cancel() {
        transitionContext?.cancelInteractiveTransition()
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: apply(state: .start),
                       completion: { _ in
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
                       completion: { _ in
                        self.toImageView.isHidden = false
                        self.fadeView.removeFromSuperview()
                        self.animatableImageview.removeFromSuperview()
                        self.fromView?.removeFromSuperview()
                        self.transitionContext?.completeTransition(true)
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
                self.animatableImageview.frame = self.fromAssetView.frame
                self.fadeView.alpha = 1.0
            case .end:
                self.animatableImageview.contentMode = self.toImageView.contentMode
                self.animatableImageview.transform = .identity
                self.animatableImageview.frame = self.toImageView.superview!.convert(self.toImageView.frame, to: nil)
                self.fadeView.alpha = 0.0
            }
        }
    }
}

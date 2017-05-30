import UIKit

final class ImageViewerPresentationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private let fromImageView: UIImageView
    
    init(fromImageView: UIImageView) {
        self.fromImageView = fromImageView
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        guard let parentView = fromImageView.superview else { return }
        guard let image = fromImageView.image else { return }
        
        let imageView = AnimatableImageView(image: image)
        imageView.frame = parentView.convert(fromImageView.frame, to: UIScreen.main.coordinateSpace)
        imageView.contentMode = fromImageView.contentMode
        
        let fadeView = UIView(frame: container.bounds)
        fadeView.backgroundColor = .black
        fadeView.alpha = 0.0
        
        toView.frame = container.bounds
        toView.isHidden = true
        fromImageView.isHidden = true
        
        container.addSubview(toView)
        container.addSubview(fadeView)
        container.addSubview(imageView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut,  animations: {
            imageView.contentMode = .scaleAspectFit
            imageView.frame = container.bounds
            fadeView.alpha = 1.0
        }, completion: { _ in
            toView.isHidden = false
            fadeView.removeFromSuperview()
            imageView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}

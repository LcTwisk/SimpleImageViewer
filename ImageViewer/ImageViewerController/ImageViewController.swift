import UIKit
import AVFoundation

public final class ImageViewController: UIViewController {
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var transitionHandler: ImageViewerTransitioningHandler?
    private var fromImageView: UIImageView?
    private var fromImage: UIImage?
    private var fromImageBlock: ImageBlock?
    
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    public init(imageView: UIImageView?, image: UIImage?, imageBlock: ImageBlock?) {
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
        
        fromImage = image
        fromImageView = imageView
        fromImageBlock = imageBlock
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = fromImageView?.image ?? fromImage
        
        setupScrollView()
        setupGestureRecognizers()
        setupActivityIndicator()
    }
}

extension ImageViewController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard let image = imageView.image else { return }
        let imageViewSize = Utilities.aspectFitRect(forSize: image.size, insideRect: imageView.frame)
        let verticalInsets = -(scrollView.contentSize.height - max(imageViewSize.height, scrollView.bounds.height)) / 2
        let horizontalInsets = -(scrollView.contentSize.width - max(imageViewSize.width, scrollView.bounds.width)) / 2
        scrollView.contentInset = UIEdgeInsets(top: verticalInsets,
                                               left: horizontalInsets,
                                               bottom: verticalInsets,
                                               right: horizontalInsets)
    }
}

extension ImageViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return scrollView.zoomScale == scrollView.minimumZoomScale
    }
}

extension ImageViewController: TransitionDismissable {
    var assetView: UIView { return imageView }
    var dismissImage: UIImage? { return imageView.image }
}

private extension ImageViewController {
    func setupScrollView() {
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = true
    }
    
    func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.numberOfTapsRequired = 2
        tapGestureRecognizer.addTarget(self, action: #selector(imageViewDoubleTapped))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.addTarget(self, action: #selector(imageViewPanned(_:)))
        panGestureRecognizer.delegate = self
        imageView.addGestureRecognizer(panGestureRecognizer)
    }
    
    func setupActivityIndicator() {
        guard let block = fromImageBlock else { return }
        activityIndicator.startAnimating()
        block { [weak self] image in
            guard let image = image else { return }
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.imageView.image = image
            }
        }
    }
    
    
    @objc func imageViewDoubleTapped() {
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
    
    @objc func imageViewPanned(_ recognizer: UIPanGestureRecognizer) {
        guard transitionHandler != nil else { return }
            
        let translation = recognizer.translation(in: imageView)
        let velocity = recognizer.velocity(in: imageView)
        
        switch recognizer.state {
        case .began:
            transitionHandler?.dismissInteractively = true
            dismiss(animated: true)
        case .changed:
            let percentage = abs(translation.y) / imageView.bounds.height
            let transform = CGAffineTransform(translationX: translation.x, y: translation.y)
            transitionHandler?.dismissalInteractor.update(percentage: percentage)
            transitionHandler?.dismissalInteractor.update(transform: transform)
        case .ended, .cancelled:
            transitionHandler?.dismissInteractively = false
            let percentage = abs(translation.y + velocity.y) / imageView.bounds.height
            if percentage > 0.25 {
                transitionHandler?.dismissalInteractor.finish()
            } else {
                transitionHandler?.dismissalInteractor.cancel()
            }
        default: break
        }
    }
}








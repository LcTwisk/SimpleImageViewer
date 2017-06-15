import UIKit
import AVFoundation

public typealias ImageCompletion = (UIImage?) -> Void
public typealias ImageBlock = (@escaping ImageCompletion) -> Void

public final class ImageViewerController: UIViewController {
    @IBOutlet fileprivate var scrollView: UIScrollView!
    @IBOutlet fileprivate var imageView: UIImageView!
    @IBOutlet fileprivate var activityIndicator: UIActivityIndicatorView!
    
    fileprivate let tapGestureRecognizer = UITapGestureRecognizer()
    fileprivate let panGestureRecognizer = UIPanGestureRecognizer()
    fileprivate var transitionHandler: ImageViewerTransitioningHandler?
    fileprivate var imageBlock: ImageBlock?
    fileprivate var image: UIImage?
    fileprivate var fromImageView: UIImageView?
        
    public init(image: UIImage?) {
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
        self.image = image
    }
    
    convenience public init(imageView: UIImageView) {
        self.init(image: imageView.image)
        self.fromImageView = imageView
    }
    
    convenience public init(image: UIImage?, imageBlock: @escaping ImageBlock) {
        self.init(image: image)
        self.imageBlock = imageBlock
    }
    
    convenience public init(imageView: UIImageView, imageBlock: @escaping ImageBlock) {
        self.init(imageView: imageView)
        self.imageBlock = imageBlock
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        setupScrollView()
        setupGestureRecognizers()
        setupTransitions()
        setupActivityIndicator()
    }
}

extension ImageViewerController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard let image = image else { return }
        let imageViewSize = Utilities.aspectFitRect(forSize: image.size, insideRect: imageView.frame)
        let verticalInsets = -(scrollView.contentSize.height - max(imageViewSize.height, scrollView.bounds.height)) / 2
        let horizontalInsets = -(scrollView.contentSize.width - max(imageViewSize.width, scrollView.bounds.width)) / 2
        scrollView.contentInset = UIEdgeInsets(top: verticalInsets, left: horizontalInsets, bottom: verticalInsets, right: horizontalInsets)
    }
}

extension ImageViewerController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return scrollView.zoomScale == scrollView.minimumZoomScale
    }
}

private extension ImageViewerController {
    func setupScrollView() {
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = true
    }
    
    func setupGestureRecognizers() {
        tapGestureRecognizer.numberOfTapsRequired = 2
        tapGestureRecognizer.addTarget(self, action: #selector(imageViewDoubleTapped))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        panGestureRecognizer.addTarget(self, action: #selector(imageViewPanned(_:)))
        panGestureRecognizer.delegate = self
        imageView.addGestureRecognizer(panGestureRecognizer)
    }
    
    func setupTransitions() {
        modalTransitionStyle = .crossDissolve
        guard let imageView = fromImageView else { return }
        transitionHandler = ImageViewerTransitioningHandler(fromImageView: imageView, toImageView: imageView)
        transitioningDelegate = transitionHandler
    }
    
    func setupActivityIndicator() {
        guard let block = imageBlock else { return }
        activityIndicator.startAnimating()
        block { [weak self] image in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.imageView.image = image
            }
        }
    }
    
    @IBAction func closeButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc func imageViewDoubleTapped() {
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
    
    @objc func imageViewPanned(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: imageView)
        let percentage = (abs(translation.y) / imageView.bounds.height) * 0.5
        
        switch recognizer.state {
        case .began:
            transitionHandler?.dismissInteractively = true
            dismiss(animated: true)
        case .changed:
            transitionHandler?.dismissalInteractor.update(percentage: percentage)
            transitionHandler?.dismissalInteractor.update(transform: CGAffineTransform(translationX: translation.x, y: translation.y))
        case .ended, .cancelled:
            transitionHandler?.dismissInteractively = false
            transitionHandler?.dismissalInteractor.finish()
        default: break
        }
    }
}



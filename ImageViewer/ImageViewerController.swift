import UIKit
import AVFoundation

public final class ImageViewerController: UIViewController {
    @IBOutlet fileprivate var scrollView: UIScrollView!
    @IBOutlet fileprivate var imageView: UIImageView!
    @IBOutlet fileprivate var activityIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate var closeButton: UIButton!

    fileprivate var transitionHandler: ImageViewerTransitioningHandler?
    public var configuration: ImageViewerConfiguration?
    
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    public static func imageViewerController(configuration: ImageViewerConfiguration?) -> ImageViewerController {
        let storyboard = UIStoryboard(name: "ImageViewerController", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImageViewerController") as! ImageViewerController
        viewController.configuration = configuration
        return viewController
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        modalPresentationCapturesStatusBarAppearance = true
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        guard let config = configuration else {
            fatalError("configuration has not been set")
        }

        if !config.showCloseButton {
            closeButton.isHidden = true
        }

        loadImage()

        setupScrollView()
        setupGestureRecognizers()
        setupTransitions()

        if let color = configuration?.backgroundColor {
            view.setBackgroundColors(color)
        }
    }

    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        resetZoomScale()
    }

    public func reloadImage() {
        resetZoomScale()
        loadImage()
    }

    public func resetZoomScale() {
        scrollView.zoomScale = scrollView.minimumZoomScale
    }
}

extension ImageViewerController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard let image = imageView.image else { return }
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

private extension UIView {
    func setBackgroundColors(_ color: UIColor) {
        for subview in subviews {
            subview.backgroundColor = .clear
        }
        backgroundColor = color
    }
}

private extension ImageViewerController {
    func loadImage() {
        if configuration?.imageBlock == nil {
            imageView.image = configuration?.imageView?.image ?? configuration?.image
        } else {
            setupActivityIndicator()
        }
    }

    func setupScrollView() {
        scrollView.decelerationRate = UIScrollView.DecelerationRate.fast
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
    
    func setupTransitions() {
        guard let imageView = configuration?.imageView else { return }
        transitionHandler = ImageViewerTransitioningHandler(fromImageView: imageView, toImageView: self.imageView)
        transitioningDelegate = transitionHandler
    }
    
    func setupActivityIndicator() {
        guard let block = configuration?.imageBlock else { return }
        activityIndicator.startAnimating()
        block { [weak self] image in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                if image != nil {
                    self?.imageView.image = image
                }
            }
        }
    }
    
    @IBAction func closeButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc func imageViewDoubleTapped(recognizer: UITapGestureRecognizer) {
        func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
            var zoomRect = CGRect.zero
            zoomRect.size.height = imageView.frame.size.height / scale
            zoomRect.size.width  = imageView.frame.size.width  / scale
            let newCenter = scrollView.convert(center, from: imageView)
            zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
            zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
            return zoomRect
        }

        if scrollView.zoomScale > scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
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
            transitionHandler?.dismissalInteractor.update(percentage: percentage)
            transitionHandler?.dismissalInteractor.update(transform: CGAffineTransform(translationX: translation.x, y: translation.y))
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


import UIKit
import AVFoundation

public final class ImageViewerController: UIViewController {
    @IBOutlet fileprivate var scrollView: UIScrollView!
    @IBOutlet fileprivate var imageView: UIImageView!
    @IBOutlet fileprivate var activityIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate var closeButton: UIButton!

    fileprivate var transitionHandler: ImageViewerTransitioningHandler?
    fileprivate let configuration: ImageViewerConfiguration?
    
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    public init(configuration: ImageViewerConfiguration?) {
        self.configuration = configuration
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        modalPresentationCapturesStatusBarAppearance = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = configuration?.imageView?.image ?? configuration?.image
        
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

private extension ImageViewerController {
    func setupScrollView() {
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = true
    }
    
    func setupGestureRecognizers() {
        let doubleTapGestureRecognizer = UITapGestureRecognizer()
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        doubleTapGestureRecognizer.addTarget(self, action: #selector(imageViewDoubleTapped))
        imageView.addGestureRecognizer(doubleTapGestureRecognizer)

        let singleTapGestureRecognizer = UITapGestureRecognizer()
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.addTarget(self, action: #selector(imageViewSingleTapped))
        singleTapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
        imageView.addGestureRecognizer(singleTapGestureRecognizer)
        
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
            guard let image = image else { return }
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

    @objc func imageViewSingleTapped() {
        let presenting = closeButton.isHidden
        if presenting {
            closeButton.isHidden = false
            closeButton.alpha = 0.0
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.closeButton.alpha = presenting ? 1.0 : 0.0
        }) { _ in
            self.closeButton.isHidden = !presenting
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


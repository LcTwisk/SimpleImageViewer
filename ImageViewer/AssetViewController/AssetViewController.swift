import UIKit

protocol AssetViewPanGestureDelegate: class {
    func didStartPanGesture()
    func didChangePanGesture(translation: CGPoint)
    func didEndPanGesture(translation: CGPoint, velocity: CGPoint)
}

public class AssetViewController: UIViewController {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var assetView: UIView!
    
    weak var assetPanGestureDelegate: AssetViewPanGestureDelegate?
    var assetSize: CGSize? { return .zero }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupGestureRecognizers()
    }
    
    @objc func assetViewPanned(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: assetView)
        let velocity = recognizer.velocity(in: assetView)
        
        switch recognizer.state {
        case .began:
            assetPanGestureDelegate?.didStartPanGesture()
        case .changed:
            assetPanGestureDelegate?.didChangePanGesture(translation: translation)
        case .ended, .cancelled:
            assetPanGestureDelegate?.didEndPanGesture(translation: translation, velocity: velocity)
        default: break
        }
    }
}

extension AssetViewController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return assetView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard let assetSize = assetSize else { return }
        let assetViewSize = Utilities.aspectFitRect(forSize: assetSize, insideRect: assetView.frame)
        let verticalInsets = -(scrollView.contentSize.height - max(assetViewSize.height, scrollView.bounds.height)) / 2
        let horizontalInsets = -(scrollView.contentSize.width - max(assetViewSize.width, scrollView.bounds.width)) / 2
        scrollView.contentInset = UIEdgeInsets(top: verticalInsets,
                                               left: horizontalInsets,
                                               bottom: verticalInsets,
                                               right: horizontalInsets)
    }
}

extension AssetViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return scrollView.zoomScale == scrollView.minimumZoomScale
    }
}

private extension AssetViewController {
    func setupScrollView() {
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
    }
    
    func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.numberOfTapsRequired = 2
        tapGestureRecognizer.addTarget(self, action: #selector(assetViewDoubleTapped))
        assetView.addGestureRecognizer(tapGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.addTarget(self, action: #selector(assetViewPanned(_:)))
        panGestureRecognizer.delegate = self
        assetView.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func assetViewDoubleTapped() {
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
}

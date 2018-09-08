import UIKit

protocol TransitionDismissable {
    var assetView: UIView { get }
    var dismissImage: UIImage? { get }
}

public final class AssetViewController: UIViewController {
    private var transitionHandler: ImageViewerTransitioningHandler?
    private let configuration: ImageViewerConfiguration
    private var childViewController: TransitionDismissable!

    @IBOutlet private var containerView: UIView!
    
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    public init(configuration: ImageViewerConfiguration) {
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
        
        setupChildAssetViewController()
        setupTransitions()
    }
    
    func setupChildAssetViewController() {
        let viewController = configuration.asset.assetViewController
        childViewController = viewController
        addChildViewController(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.didMove(toParentViewController: self)
    }
    
    func setupTransitions() {
        guard let imageView = configuration.asset.imageView,
            let assetView = childViewController?.assetView else { return }
        transitionHandler = ImageViewerTransitioningHandler(fromImageView: imageView, toAssetView: assetView)
        transitioningDelegate = transitionHandler
    }
    
    @IBAction func closeButtonPressed() {
        transitionHandler?.update(dismissImage: childViewController.dismissImage)
        dismiss(animated: true)
    }
}

private extension Asset {
    var assetViewController: UIViewController & TransitionDismissable {
        switch self {
        case let .image(imageView, image, imageBlock):
            return ImageViewController(imageView: imageView, image: image, imageBlock: imageBlock)
        case let .video(imageView, video):
            return VideoViewController(imageView: imageView, video: video)
        }
    }
}









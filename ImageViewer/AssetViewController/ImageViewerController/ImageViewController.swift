import UIKit
import AVFoundation

public final class ImageViewController: AssetViewController {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var fromImageView: UIImageView?
    private var fromImage: UIImage?
    private var fromImageBlock: ImageBlock?
    
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
        setupActivityIndicator()
    }
    
    override var assetSize: CGSize? {
        return imageView.image?.size
    }
}

extension ImageViewController: TransitionDismissable {
    var dismissAssetView: UIView { return assetView }
    var dismissImage: UIImage? { return imageView.image }
}

private extension ImageViewController {
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
}

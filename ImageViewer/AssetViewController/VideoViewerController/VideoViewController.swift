
import UIKit
import AVFoundation

public final class VideoViewController: AssetViewController {
    private var playerItem: AVPlayerItem
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer!
    
    public init(imageView: UIImageView?, video: AVAsset) {
        self.playerItem = AVPlayerItem(asset: video)
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = assetView.bounds
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupVideoLayer()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
    
    override var assetSize: CGSize? {
        return playerItem.asset.tracks(withMediaType: AVMediaType.video).first?.naturalSize
    }
    
    func setupVideoLayer() {
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        assetView.layer.addSublayer(playerLayer)
    }
    
    @objc override func assetViewPanned(_ recognizer: UIPanGestureRecognizer) {
        super.assetViewPanned(recognizer)
        
        switch recognizer.state {
        case .began:
            player?.pause()
        case .ended, .cancelled:
            player?.play()
        default: break
        }
    }
}

extension VideoViewController: TransitionDismissable {
    var dismissAssetView: UIView { return assetView }
    var dismissImage: UIImage? {
        return Utilities.screenShot(fromAsset: playerItem.asset, atTime: playerItem.currentTime())
    }
}


import UIKit
import AVFoundation

public final class VideoViewController: UIViewController {
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
        playerLayer?.frame = view.bounds
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupVideoLayer()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
    
    func setupVideoLayer() {
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        view.layer.addSublayer(playerLayer)
    }
}

extension VideoViewController: TransitionDismissable {
    var assetView: UIView { return view }
    var dismissImage: UIImage? {
        return Utilities.screenShot(fromAsset: playerItem.asset, atTime: playerItem.currentTime())
    }
}









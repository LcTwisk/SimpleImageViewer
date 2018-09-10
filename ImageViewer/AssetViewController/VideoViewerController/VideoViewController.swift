
import UIKit
import AVFoundation

public final class VideoViewController: AssetViewController {
    private var playerItem: AVPlayerItem
    private var player: AVPlayer?
    private var playerOutput: AVPlayerItemVideoOutput!
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
    
    override var assetSize: CGSize? {
        return playerItem.asset.tracks(withMediaType: AVMediaType.video).first?.naturalSize
    }
    
    func setupVideoLayer() {
        let settings = [String(kCVPixelBufferPixelFormatTypeKey): NSNumber(value:kCVPixelFormatType_32BGRA)]
        player = AVPlayer(playerItem: playerItem)
        playerOutput = AVPlayerItemVideoOutput(pixelBufferAttributes: settings)
        playerItem.add(playerOutput)
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
        guard let pixelBuffer = playerOutput.copyPixelBuffer(forItemTime: playerItem.currentTime(),
                                                             itemTimeForDisplay: nil) else { return nil }
        return Utilities.image(fromPixelBuffer: pixelBuffer)
    }
}

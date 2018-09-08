import Foundation
import UIKit
import AVFoundation

public enum Asset {
    case image(imageView: UIImageView?, image: UIImage?, imageBlock: ImageBlock?)
    case video(imageView: UIImageView?, video: AVAsset)
}

extension Asset {
    var imageView: UIImageView? {
        switch self {
        case let .image(imageView, _, _):
            return imageView
        case let .video(imageView, _):
            return imageView
        }
    }
}

public typealias ImageCompletion = (UIImage?) -> Void
public typealias ImageBlock = (@escaping ImageCompletion) -> Void

public final class ImageViewerConfiguration {
    public var asset: Asset!
    
    public typealias ConfigurationClosure = (ImageViewerConfiguration) -> ()
    
    public init(configurationClosure: ConfigurationClosure) {
        configurationClosure(self)
    }
}

import Foundation
import UIKit

public typealias ImageCompletion = (UIImage?) -> Void
public typealias ImageBlock = (@escaping ImageCompletion) -> Void
public typealias ScrollViewBlock = (UIScrollView) -> Void

public final class ImageViewerConfiguration {
    public var image: UIImage?
    public var imageView: UIImageView?
    public var imageBlock: ImageBlock?
    public var setupScrollViewBlock: ScrollViewBlock?
    
    public typealias ConfigurationClosure = (ImageViewerConfiguration) -> ()
    
    public init(configurationClosure: ConfigurationClosure) {
        configurationClosure(self)
    }
}

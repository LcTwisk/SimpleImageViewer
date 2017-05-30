import UIKit
import AVFoundation

final class AnimatableImageView: UIView {
    fileprivate let imageView = UIImageView()
    
    override var contentMode: UIViewContentMode {
        didSet { update() }
    }
    
    override var frame: CGRect {
        didSet { update() }
    }
    
    var image: UIImage = UIImage() {
        didSet {
            imageView.image = image
            update()
        }
    }
    
    init() {
        super.init(frame: .zero)
        clipsToBounds = true
        addSubview(imageView)
        imageView.contentMode = .scaleToFill
    }
    
    convenience init(image: UIImage) {
        self.init()
        self.image = image
        self.imageView.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AnimatableImageView {
    func update() {
        switch contentMode {
        case .scaleToFill:
            updateViewToScaleToFill()
        case .scaleAspectFit:
            updateViewToAspectFit()
        case .scaleAspectFill:
            updateViewToAspectFill()
        case .redraw:
            updateViewToScaleToFill()
        case .center:
            updateViewToCenter()
        case .top:
            updateViewToTop()
        case .bottom:
            updateViewToBottom()
        case .left:
            updateViewToLeft()
        case .right:
            updateViewToRight()
        case .topLeft:
            updateViewToTopLeft()
        case .topRight:
            updateViewToTopRight()
        case .bottomLeft:
            updateViewToBottomLeft()
        case .bottomRight:
            updateViewToBottomRight()
        }
    }
    
    func updateViewToScaleToFill() {
        imageView.bounds = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        imageView.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
    }
    
    func updateViewToAspectFit() {
        imageView.bounds = AVMakeRect(aspectRatio: image.size, insideRect: bounds)
        imageView.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
    }
    
    func updateViewToAspectFill() {
        let imageRatio = image.size.width / image.size.height
        let insideRectRatio = bounds.width / bounds.height
        if imageRatio > insideRectRatio {
            imageView.bounds = CGRect(x: 0, y: 0, width: bounds.height * imageRatio, height: bounds.height)
        } else {
            imageView.bounds = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.width / imageRatio)
        }
        imageView.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
    }
    
    func updateViewToCenter() {
        imageView.bounds = CGRect(origin: .zero, size: image.size)
        imageView.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
    }
    
    func updateViewToTop() {
        imageView.bounds = CGRect(origin: .zero, size: image.size)
        imageView.center = CGPoint(x: bounds.size.width / 2, y: image.size.height / 2)
    }
    
    func updateViewToBottom() {
        imageView.bounds = CGRect(origin: .zero, size: image.size)
        imageView.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height - image.size.height / 2)
    }
    
    func updateViewToLeft() {
        imageView.bounds = CGRect(origin: .zero, size: image.size)
        imageView.center = CGPoint(x: image.size.width / 2, y: bounds.size.height / 2)
    }
    
    func updateViewToRight() {
        imageView.bounds = CGRect(origin: .zero, size: image.size)
        imageView.center = CGPoint(x: bounds.size.width - image.size.width / 2, y: bounds.size.height / 2)
    }
    
    func updateViewToTopLeft() {
        imageView.bounds = CGRect(origin: .zero, size: image.size)
        imageView.center = CGPoint(x: image.size.width / 2, y: image.size.height / 2)
    }
    
    func updateViewToTopRight() {
        imageView.bounds = CGRect(origin: .zero, size: image.size)
        imageView.center = CGPoint(x: bounds.size.width - image.size.width / 2, y: image.size.height / 2)
    }
    
    func updateViewToBottomLeft() {
        imageView.bounds = CGRect(origin: .zero, size: image.size)
        imageView.center = CGPoint(x: image.size.width / 2, y: bounds.size.height - image.size.height / 2)
    }
    
    func updateViewToBottomRight() {
        imageView.bounds = CGRect(origin: .zero, size: image.size)
        imageView.center = CGPoint(x: bounds.size.width - image.size.width / 2, y: bounds.size.height - image.size.height / 2)
    }
}

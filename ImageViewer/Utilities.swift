import QuartzCore
import AVFoundation
import UIKit
import VideoToolbox

public struct Utilities {
    public static func screenShot(fromAsset asset: AVAsset, atTime time: CMTime, size: CGSize) -> UIImage? {
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.requestedTimeToleranceBefore = kCMTimeZero
        imageGenerator.requestedTimeToleranceAfter = kCMTimeZero
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.maximumSize = size
        guard let image = try? imageGenerator.copyCGImage(at: time, actualTime: nil) else { return nil }
        return UIImage(cgImage: image)
    }
    
    static func image(fromPixelBuffer pixelBuffer: CVPixelBuffer) -> UIImage? {
        var coreGraphicsImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, nil, &coreGraphicsImage)
        guard let cgImage = coreGraphicsImage else { return nil }
        return UIImage(cgImage: cgImage)
    }
    
    static func zoomRect(forScale scale: CGFloat, center: CGPoint, inRect: CGRect) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = inRect.size.height / scale
        zoomRect.size.width  = inRect.size.width  / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }

    static func rect(forSize size: CGSize) -> CGRect {
        return CGRect(origin: .zero, size: size)
    }

    static func aspectFitRect(forSize size: CGSize, insideRect: CGRect) -> CGRect {
        return AVMakeRect(aspectRatio: size, insideRect: insideRect)
    }

    static func aspectFillRect(forSize size: CGSize, insideRect: CGRect) -> CGRect {
        let imageRatio = size.width / size.height
        let insideRectRatio = insideRect.width / insideRect.height
        if imageRatio > insideRectRatio {
            return CGRect(x: 0, y: 0, width: floor(insideRect.height * imageRatio), height: insideRect.height)
        } else {
            return CGRect(x: 0, y: 0, width: insideRect.width, height: floor(insideRect.width / imageRatio))
        }
    }

    static func center(forSize size: CGSize) -> CGPoint {
        return CGPoint(x: size.width / 2, y: size.height / 2)
    }
    
    static func centerTop(forSize size: CGSize, insideSize: CGSize) -> CGPoint {
        return CGPoint(x: insideSize.width / 2, y: size.height / 2)
    }
    
    static func centerBottom(forSize size: CGSize, insideSize: CGSize) -> CGPoint {
        return CGPoint(x: insideSize.width / 2, y: insideSize.height - size.height / 2)
    }
    
    static func centerLeft(forSize size: CGSize, insideSize: CGSize) -> CGPoint {
        return CGPoint(x: size.width / 2, y: insideSize.height / 2)
    }
    
    static func centerRight(forSize size: CGSize, insideSize: CGSize) -> CGPoint {
        return CGPoint(x: insideSize.width - size.width / 2, y: insideSize.height / 2)
    }
    
    static func topLeft(forSize size: CGSize, insideSize: CGSize) -> CGPoint {
        return CGPoint(x: size.width / 2, y: size.height / 2)
    }
    
    static func topRight(forSize size: CGSize, insideSize: CGSize) -> CGPoint {
        return CGPoint(x: insideSize.width - size.width / 2, y: size.height / 2)
    }
    
    static func bottomLeft(forSize size: CGSize, insideSize: CGSize) -> CGPoint {
        return CGPoint(x: size.width / 2, y: insideSize.height - size.height / 2)
    }
    
    static func bottomRight(forSize size: CGSize, insideSize: CGSize) -> CGPoint {
        return CGPoint(x: insideSize.width - size.width / 2, y: insideSize.height - size.height / 2)
    }
}

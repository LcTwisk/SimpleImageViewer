import UIKit
import SimpleImageViewer
import AVFoundation

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let contentModes: [UIViewContentMode] = [.scaleAspectFill,
                                                     .scaleAspectFit,
                                                     .scaleToFill,
                                                     .center,
                                                     .top,
                                                     .bottom,
                                                     .left,
                                                     .right,
                                                     .topLeft,
                                                     .topRight,
                                                     .bottomLeft,
                                                     .bottomRight]
    
    private let images = [UIImage(named: "1"),
                          UIImage(named: "2"),
                          UIImage(named: "3"),
                          UIImage(named: "4"),
                          UIImage(named: "5"),
                          UIImage(named: "6")]
    
    private let videos = [AVAsset(url: URL(fileURLWithPath: Bundle.main.path(forResource: "1", ofType: "mp4")!)),
                          AVAsset(url: URL(fileURLWithPath: Bundle.main.path(forResource: "2", ofType: "mp4")!)),
                          AVAsset(url: URL(fileURLWithPath: Bundle.main.path(forResource: "3", ofType: "mp4")!)),
                          AVAsset(url: URL(fileURLWithPath: Bundle.main.path(forResource: "4", ofType: "mp4")!)),
                          AVAsset(url: URL(fileURLWithPath: Bundle.main.path(forResource: "5", ofType: "mp4")!)),
                          AVAsset(url: URL(fileURLWithPath: Bundle.main.path(forResource: "6", ofType: "mp4")!))]
    
    private lazy var thumbnails: [UIImage?] = {
        let thumbnailSize = CGSize(width: 300, height: 300)
        return self.videos.map { Utilities.screenShot(fromAsset: $0, atTime: CMTimeMake(0, 1), size: thumbnailSize)}
    }()

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return contentModes.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + videos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row % 2 == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell.imageView.image = images[indexPath.row / 2]
            cell.imageView.contentMode = contentModes[indexPath.section]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell
            cell.imageView.image = thumbnails[(indexPath.row + 1) / 2 - 1]
            cell.imageView.contentMode = contentModes[indexPath.section]
            return cell
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var asset: Asset!
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageCell {
            asset = Asset.image(imageView: cell.imageView, image: nil, imageBlock: nil)
        } else if let cell = collectionView.cellForItem(at: indexPath) as? VideoCell {
            let video = videos[(indexPath.row + 1) / 2 - 1]
            asset = Asset.video(imageView: cell.imageView, video: video)
        }
        
        let configuration = ImageViewerConfiguration { config in
            config.asset = asset
        }
        
        present(GalleryViewController(configuration: configuration), animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
                                                                         withReuseIdentifier: "HeaderView",
                                                                         for: indexPath) as! HeaderView
        headerView.titleLabel.text = contentModes[indexPath.section].name
        return headerView
    }
    
    override func willTransition(to newCollection: UITraitCollection,
                                        with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width / 3 - 8
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

private extension UIViewContentMode {
    var name: String {
        switch self {
        case .scaleToFill:
            return "scaleToFill"
        case .scaleAspectFit:
            return "scaleAspectFit"
        case .scaleAspectFill:
            return "scaleAspectFill"
        case .redraw:
            return "redraw (not animatable)"
        case .center:
            return "center"
        case .top:
            return "top"
        case .bottom:
            return "bottom"
        case .left:
            return "left"
        case .right:
            return "right"
        case .topLeft:
            return "topLeft"
        case .topRight:
            return "topRight"
        case .bottomLeft:
            return "bottomLeft"
        case .bottomRight:
            return "bottomRight"
        }
    }
}

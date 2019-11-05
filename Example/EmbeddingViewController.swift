//
//  EmbeddingViewController.swift
//  Example
//
//  Created by Sebastian Westemeyer on 13.12.18.
//  Copyright © 2018 aFrogleap. All rights reserved.
//

import UIKit
import SimpleImageViewer

class EmbeddingViewController: UIViewController {
    fileprivate var viewerController: ImageViewerController!
    fileprivate var fooImage: UIImage!
    fileprivate var barImage: UIImage!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "embedImage") {
            fooImage = UIImage(named: "1")
            barImage = UIImage(named: "2")
            viewerController = segue.destination as? ImageViewerController
            let configuration = ImageViewerConfiguration(configurationClosure: nil)
            configuration.showCloseButton = false
            configuration.backgroundColor = .purple
            configuration.imageBlock = { (completion) in self.updateImage(completion) }
            viewerController.configuration = configuration
        }
    }
}

private extension EmbeddingViewController {
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        viewerController.reloadImage()
    }

    func updateImage(_ completion: ImageCompletion) {
        // switch images
        let image = fooImage
        fooImage = barImage
        barImage = image
        // set image
        completion(fooImage)
    }
}

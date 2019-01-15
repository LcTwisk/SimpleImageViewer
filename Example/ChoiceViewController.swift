//
//  ChoiceViewController.swift
//  Example
//
//  Created by Sebastian Westemeyer on 13.12.18.
//  Copyright © 2018 aFrogleap. All rights reserved.
//

import UIKit
import SimpleImageViewer

class ChoiceViewController: UITableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showSingleImage") {
            let destination = segue.destination as! ImageViewerController
            let configuration = ImageViewerConfiguration { config in
                config.image = UIImage(named: "2")
            }
            configuration.showCloseButton = false
            destination.configuration = configuration
        }
    }
}

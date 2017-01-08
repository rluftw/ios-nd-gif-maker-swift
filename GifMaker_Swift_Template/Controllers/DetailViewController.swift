//
//  DetailViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Xing Hui Lu on 1/7/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var gifImageView: UIImageView!
    var gif: Gif!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gifImageView.image = gif.gifImage
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareGif(sender: UIButton) {
        var itemsToShare = [Data]()
        itemsToShare.append((self.gif?.gifData)!)
        
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        activityVC.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityVC, animated: true, completion: nil)
    }
}

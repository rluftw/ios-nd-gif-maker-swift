//
//  PreviewViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Xing Hui Lu on 1/6/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

protocol PreviewViewControllerDelegate: class {
    func previewVC(preview: PreviewViewController, didSaveGif gif:Gif)
}

class PreviewViewController: UIViewController {

    @IBOutlet weak var gifImageView: UIImageView!
    var gif: Gif!
    weak var delegate: PreviewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gifImageView.image = gif.gifImage
    }
    

    @IBAction func shareGif(sender: AnyObject) {
        let animatedGif = NSData(contentsOf: gif.url)!
        let shareController = UIActivityViewController(activityItems: [animatedGif], applicationActivities: nil)
        shareController.completionWithItemsHandler = { (activityType, completed, returnedItems, error)->Void in
            guard completed else { return }
            
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        
        present(shareController, animated: true, completion: nil)
    }
    
    
    @IBAction func createAndSave(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
        delegate?.previewVC(preview: self, didSaveGif: gif)
    }
}

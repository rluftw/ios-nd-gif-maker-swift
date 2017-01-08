//
//  GifCell.swift
//  GifMaker_Swift_Template
//
//  Created by Xing Hui Lu on 1/7/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class GifCell: UICollectionViewCell {
    
    @IBOutlet weak var gifImageView: UIImageView!
    
    func configure(gif: Gif) {
        self.gifImageView.image = gif.gifImage
        
        print("cell configured")
    }
}

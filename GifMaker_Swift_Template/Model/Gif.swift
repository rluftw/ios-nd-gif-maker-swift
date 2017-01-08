//
//  Gif.swift
//  GifMaker_Swift_Template
//
//  Created by Xing Hui Lu on 1/7/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class Gif: NSObject, NSCoding {
    var url: URL!
    var rawVideoURL: URL!
    var caption: String?
    var gifImage: UIImage!
    var gifData: Data?
    
    init(url: URL, videoURL: URL, caption: String?) {
        
        self.url = url
        self.rawVideoURL = videoURL
        self.caption = caption
        gifImage = UIImage.gif(url: url.absoluteString)
    }
    
    required init?(coder aDecoder: NSCoder) {
        url = aDecoder.decodeObject(forKey: "gifURL") as! URL
        rawVideoURL = aDecoder.decodeObject(forKey: "videoURL") as! URL
        caption = aDecoder.decodeObject(forKey: "caption") as? String
        gifImage = aDecoder.decodeObject(forKey: "gifImage") as! UIImage
        gifData = aDecoder.decodeObject(forKey: "gifData") as? Data
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(url, forKey: "gifURL")
        aCoder.encode(rawVideoURL, forKey: "videoURL")
        aCoder.encode(caption, forKey: "caption")
        aCoder.encode(gifImage, forKey: "gifImage")
        aCoder.encode(gifData, forKey: "gifData")
    }
}

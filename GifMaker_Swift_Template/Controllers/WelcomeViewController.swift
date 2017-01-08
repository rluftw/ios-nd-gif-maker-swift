//
//  WelcomeViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Xing Hui Lu on 1/6/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit
import MobileCoreServices

class WelcomeViewController: UIViewController {

    @IBOutlet weak var gifImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserDefaults.standard.set(true, forKey: "WelcomeViewSeen")
        
        let proofOfConcept = UIImage.gif(name: "hotlineBling")
        gifImageView.image = proofOfConcept
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

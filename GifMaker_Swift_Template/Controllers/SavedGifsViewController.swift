//
//  SavedGifsVewController.swift
//  GifMaker_Swift_Template
//
//  Created by Xing Hui Lu on 1/7/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class SavedGifsViewController: UIViewController, PreviewViewControllerDelegate {
    
    @IBOutlet weak var emptyView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var savedGifs = [Gif]()
    let cellMargin: CGFloat = 12.0
    var gifsFilePath: String {
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsPath = directories[0]
        let gifsPath = documentsPath.appending("/savedGifs")
        return gifsPath
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let unarchivedGifs = NSKeyedUnarchiver.unarchiveObject(withFile: gifsFilePath) as? [Gif] {
            savedGifs = unarchivedGifs
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emptyView.isHidden = savedGifs.count != 0
        collectionView.reloadData()
    }

    func previewVC(preview: PreviewViewController, didSaveGif gif: Gif) {
        do {
            gif.gifData = try Data(contentsOf: gif.url)
            savedGifs.append(gif)
        } catch let error {
            print("error " + error.localizedDescription)
        }
        NSKeyedArchiver.archiveRootObject(savedGifs, toFile: gifsFilePath)

    }
    
    func showWelcome() {
        if UserDefaults.standard.bool(forKey: "showWelcome") {
            let welcomeVC = storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            navigationController?.pushViewController(welcomeVC, animated: true)
        }
    }
}

extension SavedGifsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - (cellMargin*2)) / 2.0
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GifCell", for: indexPath) as! GifCell
        cell.configure(gif: savedGifs[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedGifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gif = savedGifs[indexPath.item]
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.gif = gif
        detailVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        present(detailVC, animated: true, completion: nil)
    }
}

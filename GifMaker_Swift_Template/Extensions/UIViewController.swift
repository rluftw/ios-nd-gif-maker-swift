//
//  UIViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Xing Hui Lu on 1/6/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import AVFoundation

let frameCount = 16
let delayTime: Float = 0.2
let loopCount = 0

extension UIViewController {
    @IBAction func launchVideoCamera(sender: AnyObject) {
        let recordVideoController = UIImagePickerController()
        recordVideoController.sourceType = .camera
        recordVideoController.mediaTypes = [kUTTypeMovie as String]
        recordVideoController.allowsEditing = false
        recordVideoController.delegate = self
        
        present(recordVideoController, animated: true, completion: nil)
    }
}

extension UIViewController: UINavigationControllerDelegate {
    
}

extension UIViewController: UIImagePickerControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String

        if mediaType == kUTTypeMovie as String {
            let videoURL = info[UIImagePickerControllerMediaURL] as! URL
            let start = info["_UIImagePickerControllerVideoEditingStart"] as? NSNumber
            let end = info["_UIImagePickerControllerVideoEditingEnd"] as? NSNumber
            
            var duration: NSNumber?
            if let start = start {
                duration = NSNumber(value: end!.floatValue - start.floatValue)
            } else {
                duration = nil
            }
            
            cropVideoToSquare(rawVideoURL: videoURL, start: start, duration: duration)
        }
    }
    
    func convertVideoToGIF(videoURL: URL, start: NSNumber?, duration: NSNumber?) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
        
        var regift: Regift!
        if let start = start {            
            // trimmed
            regift = Regift(sourceFileURL: videoURL, destinationFileURL: nil, startTime: start.floatValue, duration: duration!.floatValue, frameRate: frameCount, loopCount: loopCount)
        }else {
            // untrimmed
            regift = Regift(sourceFileURL: videoURL, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
        }
        
        let gifURL = regift.createGif()
        let gif = Gif(url: gifURL!, videoURL: videoURL, caption: nil)
        
        displayGif(gif)
    }
    
    func displayGif(_ gif: Gif) {
        let gifEditorVC = storyboard?.instantiateViewController(withIdentifier: "GifEditorViewController") as! GifEditorViewController
        gifEditorVC.gif = gif
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(gifEditorVC, animated: true)
        }
    }
    
    func cropVideoToSquare(rawVideoURL: URL, start: NSNumber?, duration: NSNumber?) {
        
        // create the AVAsset and AVAssetTrack
        let videoAsset = AVAsset(url: rawVideoURL)
        let videoTrack = videoAsset.tracks(withMediaType: AVMediaTypeVideo)[0]
        
        // crop to square
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize(width: videoTrack.naturalSize.height, height: videoTrack.naturalSize.height)
        videoComposition.frameDuration = CMTimeMake(1, 30)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30))
        
        // rotate to portrait 
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        let t1 = CGAffineTransform(translationX: videoTrack.naturalSize.height, y: -(videoTrack.naturalSize.width - videoTrack.naturalSize.height)/2)
        let t2 = t1.rotated(by: CGFloat(M_PI_2))
        
        let finalTransform = t2
        
        transformer.setTransform(finalTransform, at: kCMTimeZero)
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
    
        let exporter = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality)
        exporter?.videoComposition = videoComposition
        let path = createPath()
        exporter?.outputURL = URL(fileURLWithPath: path)
        exporter?.outputFileType = AVFileTypeQuickTimeMovie;
    
        exporter?.exportAsynchronously(completionHandler: {
            let croppedURL = exporter?.outputURL
            
            self.convertVideoToGIF(videoURL: croppedURL!, start: start, duration: duration)
        })
    }
    
    func createPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0] as NSString
        let manager = FileManager.default
        var outputURL = documentsDirectory.appendingPathComponent("output") as NSString
        do {
            try manager.createDirectory(atPath: String(outputURL), withIntermediateDirectories: true, attributes: nil)
            outputURL = outputURL.appendingPathComponent("output.mov") as NSString
            print("output url: \(outputURL)")
            
            // remove existing file
            try manager.removeItem(atPath: String(outputURL))
        } catch let error {
            print("error: \(error.localizedDescription)")
        }
        
        return String(outputURL)
    }
    
    @IBAction func presentVideoOptions(sender: AnyObject) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            launchPhotoLibrary()
            return
        }
        
        let newGifActionSheet = UIAlertController(title: "Create a new Gif", message: nil, preferredStyle: .actionSheet)
        let recordVideo = UIAlertAction(title: "Record a Video", style: .default) { (action) in
            self.launchCamera()
        }
        let chooseFromExisting = UIAlertAction(title: "Choose From Existing", style: .default) { (action) in
            self.launchPhotoLibrary()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        newGifActionSheet.addAction(recordVideo)
        newGifActionSheet.addAction(chooseFromExisting)
        newGifActionSheet.addAction(cancel)
        newGifActionSheet.view.tintColor = UIColor(red: 1.0, green: 65/255.0, blue: 112/255.0, alpha: 1.0)
        present(newGifActionSheet, animated: true, completion: nil)
    }
    
    func launchPhotoLibrary() {
        launchPickerController(source: .photoLibrary)
    }
    
    func launchCamera() {
        launchPickerController(source: .camera)
    }
    
    func launchPickerController(source: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.allowsEditing = true
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
    }

}

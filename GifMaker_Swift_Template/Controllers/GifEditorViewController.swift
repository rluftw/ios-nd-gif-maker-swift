//
//  GifPreviewViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Xing Hui Lu on 1/6/17.
//  Copyright © 2017 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class GifEditorViewController: UIViewController {

    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var gifImageView: UIImageView!
    var gif: Gif!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gifImageView.image = gif.gifImage

        let defaultAttributes: [String: Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSStrokeWidthAttributeName: -4,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
        ]
        captionTextField.defaultTextAttributes = defaultAttributes
        captionTextField.textAlignment = .center
        captionTextField.attributedPlaceholder = NSAttributedString(string: "Add Caption", attributes: defaultAttributes)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subcribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubcribeToKeyboardNotifications()
    }
    
    // MARK: - preview Gif
    @IBAction func presentPreview(sender: AnyObject) {
        let previewVC = storyboard?.instantiateViewController(withIdentifier: "GifPreviewViewController") as! PreviewViewController
        gif.caption = captionTextField.text
        
        let regift = Regift(sourceFileURL: gif.rawVideoURL, destinationFileURL: nil, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
        
        let captionFont = captionTextField.font
        let gifURL = regift.createGif(caption: captionTextField.text, font: captionFont)!
        
        let newGif = Gif(url: gifURL, videoURL: gif.rawVideoURL, caption: captionTextField.text)
        previewVC.gif = newGif
        
        let savedGifVC = navigationController?.viewControllers[0] as! SavedGifsViewController
        previewVC.delegate = savedGifVC
        
        navigationController?.pushViewController(previewVC, animated: true)
    }
}

extension GifEditorViewController: UITextFieldDelegate {
    // MARK: - textfield delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Textfield began editing")
    }

    // MARK: - Observe and respond to keyboard notifications
    func subcribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubcribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: Notification) {
        if view.frame.origin.y >= 0 {
            view.frame.origin.y -= getKeyboardHeight(notification: notification)
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        if view.frame.origin.y < 0 {
            view.frame.origin.y += getKeyboardHeight(notification: notification)
        }
    }
    
    func getKeyboardHeight(notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardFrameEnd = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        let keyboardFrameEndRect = keyboardFrameEnd.cgRectValue
        return keyboardFrameEndRect.size.height
    }
}

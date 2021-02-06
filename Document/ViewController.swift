//
//  ViewController.swift
//  Document for opening new document when clicking + in the navigation bar
//
//  Created by Home on 5/4/19.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import Messages
import MessageUI

extension UIFont {
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
    
    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}


class ViewController: UIViewController, UITextViewDelegate, MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var charCount: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func SendMessages(_ sender: Any) {
        if MFMessageComposeViewController.canSendText() {
            let controller = MFMessageComposeViewController()
            controller.body = textView.text!
            controller.recipients = []
            controller.messageComposeDelegate = self
            
            self.present(controller, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //        textView.text = "Don't feel lonely"
        textView.textColor = UIColor(red: 0, green: 0.35, blue: 0, alpha: 1)
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont(name: "Courier New", size: 16.0)?.bold()
        
        textView.layer.cornerRadius = 10
        textView.isEditable = true
        
        textView.delegate = self
        charCount.text = "\(textView.text.count)"
        charCount.backgroundColor = UIColor.init(red: 0.9, green: 0.95, blue: 0.9, alpha: 1)
        charCount.borderStyle = UITextField.BorderStyle.roundedRect
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateTextView(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateTextView(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        navigationItem.title = "Ver 2.0"
    }
    
    @IBAction func DoneButtonTapped(_ sender: Any) {
        let fileName = charCount.text!
        if  fileName.count == 0 {
            showAlert(title: "Nil", message: "File not saved - name not set!")
            return
        }
        if  Int(fileName) != nil {
            showAlert(title: fileName, message: "File not saved - invalid filename(\(fileName))!")
            return
        }
        if  textView.text.count == 0 {
            showAlert(title: fileName, message: "File not saved - Empty file(\(fileName))!")
            return
        }
        
        let documentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        
        // Check for an already same name file
        do {
            _ = try String(contentsOf: fileURL)
            showAlert(title: fileName, message: "File already there! - will be overwriten!")
        } catch { }
        
        do {
            let data: Data = textView.text.data(using: String.Encoding.unicode)!
            try data.write(to: fileURL, options: .completeFileProtection)
        } catch let error as NSError {
            showAlert(title: "Error", message: error.localizedFailureReason!)
        }
        self.navigationController?.popToRootViewController(animated: true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.textView.resignFirstResponder()
    }

    func textViewDidChange(_ textView: UITextView) {
        charCount.text = "\(textView.text.count)"
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = UIColor.yellow
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = UIColor.clear
    }
    
    @objc func updateTextView(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardEndFrameScreenCoordinate = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardEndFrame = self.view.convert(keyboardEndFrameScreenCoordinate, to: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = UIEdgeInsets.zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardEndFrame.height, right: 0)
            textView.scrollIndicatorInsets = textView.contentInset
        }
        textView.scrollRangeToVisible(textView.selectedRange)
    }

    func showAlert(title: String, message: String, style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
/*
    func covert(str: String) -> String {
        var cString = str.cString(using: String.defaultCStringEncoding)!
        for index in 0...str.count-1 {
            if(cString[index] <= 127 && cString[index] >= 32) {
                cString[index] = 127 - cString[index] + 32
            }
        }
        return NSString(bytes: cString, length: str.count, encoding:String.Encoding.ascii.rawValue)! as String
    }*/
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        return textView.text.count + (text.count - range.length) <= 260
//    }
}

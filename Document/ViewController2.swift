//
//  ViewController2.swift
//  Document for showing file against list-item click
//
//  Created by Home on 5/13/19.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFile(file: navigationItem.title!)
        textView.textColor = UIColor(red: 0, green: 0.35, blue: 0, alpha: 1)
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont(name: "Courier New", size: 16.0)?.bold()
        
        textView.layer.cornerRadius = 10
        textView.isEditable = false
    }
    
    @IBAction func deleteItem(_ sender: Any) {
        let list:[URL] = FileManager.default.urls(for: .documentDirectory)!
        for index in list.indices {
            let url: URL = list[index]
            let name = url.lastPathComponent
            if( name.contains(navigationItem.title!)) {
                self.removeThisURL(url: url)
                break
            }
        }

        self.navigationController?.popToRootViewController(animated: true)
    }

    func removeThisURL(url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch  let error as NSError {
            showAlert(title: navigationItem.title!, message: error.localizedFailureReason!)
        }
    }
    
    func loadFile(file: String) {
        let documentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documentDirURL.appendingPathComponent(file)
        
        do {
            let readString = try String(contentsOf: fileURL, encoding: String.Encoding.unicode)
            textView.text = readString
        } catch let error as NSError {
            showAlert(title: file, message: error.localizedFailureReason!)
        }
    }

    func showAlert(title: String, message: String, style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

    func askingAlert(title: String, message: String, style: UIAlertController.Style = .alert) -> Bool {
        var resp:Bool = false
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let actionY = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
            resp = true
        }
        let actionN = UIAlertAction(title: "No", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(actionY)
        alertController.addAction(actionN)

        self.present(alertController, animated: true, completion: nil)
        return resp
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
    }
 */
}

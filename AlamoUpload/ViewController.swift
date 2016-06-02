//
//  ViewController.swift
//  AlamoUpload
//
//  Created by Adi Nugroho on 5/18/16.
//  Copyright © 2016 Adi Nugroho. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    
    let picker = UIImagePickerController()
    var pickedImagePath: NSURL?
    var pickedImageData: NSData?
    
    var localPath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.allowsEditing = false
        picker.delegate = self
    }
    
    @IBAction func onBtnOpenClicked(sender: UIButton) {
        presentViewController(picker, animated: true, completion: nil)
    }

    @IBAction func onBtnSubmitClicked(sender: UIButton) {
        guard let path = localPath else {
            return
        }
        
        Alamofire.upload(.POST, "http://192.168.0.234:3000"
            , multipartFormData: { formData in
                let filePath = NSURL(fileURLWithPath: path)
                formData.appendBodyPart(fileURL: filePath, name: "upload")
                formData.appendBodyPart(data: "Alamofire".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "test")
            }, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success:
                    print("SUCCESS")
                case .Failure(let error):
                    print(error)
                }
        })
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        imgView.image = image
        
        let documentDirectory: NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        
        let imageName = "temp"
        let imagePath = documentDirectory.stringByAppendingPathComponent(imageName)
        
        if let data = UIImageJPEGRepresentation(image, 80) {
            data.writeToFile(imagePath, atomically: true)
        }
        
        localPath = imagePath
        
        dismissViewControllerAnimated(true, completion: {
            
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
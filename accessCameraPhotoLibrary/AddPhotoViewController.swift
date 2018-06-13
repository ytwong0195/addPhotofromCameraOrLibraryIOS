//
//  ViewController.swift
//  accessCameraPhotoLibrary
//
//  Created by .  Wong Ying Tung on 6/12/18.
//  Copyright © 2018 ywong. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import Photos

class AddPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var newPic : Bool? //for decision to save new photo taken on camera
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var addPicLabel: UILabel! 
    @IBOutlet weak var addPicButton: UIButton! 
    
    @IBAction func addButtonTapped(_ sender: Any) {
        //display actionSheet alert style for user to choose between camera and photo library
        let pickImageAlert = UIAlertController(title: "Select Image From", message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) {(action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                self.present(imagePicker,animated: true,completion: nil)
                self.newPic = true
            }
        }
        let cameraRollAction = UIAlertAction(title:"Camera Roll", style:.default) {(action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                self.present(imagePicker,animated: true,completion: nil)
                self.newPic = false
            }
        }
        pickImageAlert.addAction(cameraAction)
        pickImageAlert.addAction(cameraRollAction)
        self.present(pickImageAlert, animated: true)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        if mediaType.isEqual(to: kUTTypeImage as String){
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            imageView.image = image
            //save newly taken photo to file 
            if newPic == true {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageError),nil)
                
            }
        }
        addPicLabel.isHidden = true //the label will disappear once user uploaded picture
        addPicButton.alpha = 0.5 //the button will turn half transparent after user upload picture
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func imageError(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafeRawPointer){
        if error != nil {
            let alert = UIAlertController(title: "Save Failed", message: "Failed to save image", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        
    }

}


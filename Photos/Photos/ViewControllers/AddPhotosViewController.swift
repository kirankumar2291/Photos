//
//  AddPhotosViewController.swift
//  Photos
//
//  Created by Kiran kumar on 03/10/18.
//  Copyright © 2018 Kiran kumar. All rights reserved.
//

import UIKit
import AVFoundation

class AddPhotosViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Button Action
    
    @IBAction func addPhotosButtonClicked(_ sender: UIButton) {
        showActionSheet()
    }
    
    func showActionSheet()
    {
        let actionSheet = UIAlertController(title: "", message: "Please select the source", preferredStyle: .actionSheet)
        let cameraButton = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.openCamera()
        }
        let galleryButton = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.openPhotosGallery()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cameraButton)
        actionSheet.addAction(galleryButton)
        actionSheet.addAction(cancelButton)
        
        actionSheet.popoverPresentationController?.sourceView = self.view
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status
            {
                case .denied:
                    self.showSettingsPermissionAlert()
                    break
                case .notDetermined:
                    self.showImagePickerForSourceType(source: .camera)
                    break
                case .authorized:
                    self.showImagePickerForSourceType(source: .camera)
                    break
                default:
                    break
            }
        }
        else
        {
            let alert = UIAlertController(title: "Alert!", message: "Camera is not available.", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(cancelButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openPhotosGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status
            {
                case .denied:
                    showSettingsPermissionAlert()
                    break
                case .notDetermined:
                    self.showImagePickerForSourceType(source: .photoLibrary)
                    break
                case .authorized:
                    self.showImagePickerForSourceType(source: .photoLibrary)
                    break
                default:
                    break
            }
        }
        else
        {
            let alert = UIAlertController(title: "Alert!", message: "Gallery is not available.", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(cancelButton)
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    func showSettingsPermissionAlert()
    {
        let alert = UIAlertController(title: "Unable to access the Camera.", message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showImagePickerForSourceType(source: UIImagePickerControllerSourceType)
    {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = source
        self.present(myPickerController, animated: true, completion: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AddPhotosViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            var imageName = GlobalMethods.currentTimeMillis()
            imageName = imageName.replacingOccurrences(of: ".", with: "")
            pickedImage.save(imageName, type: "jpg")
            let photo = PhotosObject()
            photo.imageName = imageName
            CoreDataAccessLayer.insertPhoto(photo: photo)
            dismiss(animated: true) {
                let alert = UIAlertController(title: "Success.", message: "Image Saved Successfully.", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

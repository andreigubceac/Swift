//
//  ImageImportController.swift
//  123DressMe
//
//  Created by Andrei Gubceac on 7/30/17.
//  Copyright © 2017 123DressMe. All rights reserved.
//

import UIKit
import AVFoundation

typealias ImageDelegateBlock = ((UIImage) -> Swift.Void)

class ImagePickerController: UIImagePickerController {
    var delegateBlock: ImageDelegateBlock? = nil
}

class ImageImportController: UIAlertController {
    var delegateBlock: ImageDelegateBlock? = nil

    class func imageImportSheet(_ title : String?, message : String?, completion: ImageDelegateBlock? = nil) -> ImageImportController {
        let imageImport = ImageImportController(title: title, message: message, preferredStyle: .actionSheet)
        imageImport.delegateBlock = completion
        return imageImport
    }
    
    func showDeleteButton(title: String = NSLocalizedString("Delete", comment: "Delete"), handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        addAction(UIAlertAction(title: NSLocalizedString(title, comment: title), style: .destructive, handler: handler))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let parentVctrl = presentingViewController ?? UIApplication.shared.keyWindow!.rootViewController!
        func presentImagePikcer(source type: UIImagePickerControllerSourceType) {
            let imagePicker = ImagePickerController()
            imagePicker.delegateBlock = delegateBlock
            imagePicker.sourceType = type
            imagePicker.delegate = parentVctrl
            parentVctrl.present(imagePicker, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
        addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil))
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            addAction(UIAlertAction(title: NSLocalizedString("Library", comment: "Library"), style: .default, handler: { (action) in
                presentImagePikcer(source: .photoLibrary)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            addAction(UIAlertAction(title: NSLocalizedString("Saved Photos", comment: "Saved Photos"), style: .default, handler: { (action) in
                presentImagePikcer(source: .savedPhotosAlbum)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            addAction(UIAlertAction(title: NSLocalizedString("Take Photo", comment: "Take Photo"), style: .default, handler: { (action) in
                let status = AVCaptureDevice.authorizationStatus(for: .video)
                if status == .authorized {
                    presentImagePikcer(source: .camera)
                }
                else if status == .denied {
                    _ = parentVctrl.presentAlertInfo(nil, message: NSLocalizedString("Access Denied from Settings", comment: "Access Denied from Settings"))
                }
                else if status == .restricted {
                    _ = parentVctrl.presentAlertInfo(nil, message: NSLocalizedString("Access Restricted", comment: "Access Restricted"))
                }
                else {
                    AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
                        if granted {
                            DispatchQueue.main.async {
                                presentImagePikcer(source: .camera)
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                _ = parentVctrl.presentAlertInfo(nil, message: NSLocalizedString("Not allowed from Settings", comment: "Not allowed from Settings"))
                            }
                        }
                    })
                }
            }))
        }
    }

}

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true) {
            if let pickerVctrl = picker as? ImagePickerController {
                if let image = (info[UIImagePickerControllerEditedImage] ?? info[UIImagePickerControllerOriginalImage]) as? UIImage {
                    pickerVctrl.delegateBlock?(image)
                }
            }
        }
    }
    
}

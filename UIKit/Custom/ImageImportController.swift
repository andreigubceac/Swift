//
//  ImageImportController.swift
//
//  Created by Andrei Gubceac.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import AVFoundation

typealias ActionDelegateBlock = ((ImageImportController, UIImagePickerController.SourceType) -> Swift.Void)
typealias ImageDelegateBlock = ((UIImage, UIImagePickerController.SourceType) -> Swift.Void)

class ImagePickerController: UIImagePickerController {
    var delegateBlock: ImageDelegateBlock? = nil
}

class ImageImportController: UIAlertController {
    var actionBlock: ActionDelegateBlock? = nil
    var delegateBlock: ImageDelegateBlock? = nil

    class func imageImportSheet(_ title : String?, message : String?, action: ActionDelegateBlock? = nil, completion: ImageDelegateBlock? = nil) -> ImageImportController {
        let imageImport = ImageImportController(title: title, message: message, preferredStyle: .actionSheet)
        imageImport.actionBlock     = action
        imageImport.delegateBlock   = completion
        return imageImport
    }
    
    func showDeleteButton(title: String = NSLocalizedString("Delete", comment: "Delete"), handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        addAction(UIAlertAction(title: NSLocalizedString(title, comment: title), style: .destructive, handler: handler))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let parentVctrl = presentingViewController ?? UIApplication.shared.keyWindow!.rootViewController!
        // Do any additional setup after loading the view.
        addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil))
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            addAction(UIAlertAction(title: NSLocalizedString("Library", comment: "Library"), style: .default, handler: { (action) in
                if self.actionBlock != nil {
                    self.actionBlock?(self, .photoLibrary)
                }
                else {
                    self.presentImagePikcer(fromVctrl: parentVctrl, source: .photoLibrary)
                }
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            addAction(UIAlertAction(title: NSLocalizedString("Saved Photos", comment: "Saved Photos"), style: .default, handler: { (action) in
                if self.actionBlock != nil {
                    self.actionBlock?(self, .savedPhotosAlbum)
                }
                else {
                    self.presentImagePikcer(fromVctrl: parentVctrl, source: .savedPhotosAlbum)
                }
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            addAction(UIAlertAction(title: NSLocalizedString("Take Photo", comment: "Take Photo"), style: .default, handler: { (action) in
                let status = AVCaptureDevice.authorizationStatus(for: .video)
                if status == .authorized {
                    if self.actionBlock != nil {
                        self.actionBlock?(self, .camera)
                    }
                    else {
                        self.presentImagePikcer(fromVctrl: parentVctrl, source: .camera)
                    }
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
                                if self.actionBlock != nil {
                                    self.actionBlock?(self, .camera)
                                }
                                else {
                                    self.presentImagePikcer(fromVctrl: parentVctrl, source: .camera)
                                }
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
    
    public func presentImagePikcer(fromVctrl: UIViewController, source type: UIImagePickerController.SourceType) {
        let imagePicker = ImagePickerController()
        imagePicker.delegateBlock = delegateBlock
        imagePicker.sourceType = type
        imagePicker.delegate = fromVctrl
        fromVctrl.present(imagePicker, animated: true, completion: nil)
    }

}

extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        picker.dismiss(animated: true) {
            if let pickerVctrl = picker as? ImagePickerController {
                if let image = (info[UIImagePickerController.InfoKey.editedImage] ?? info[UIImagePickerController.InfoKey.originalImage]) as? UIImage {
                    pickerVctrl.delegateBlock?(image, picker.sourceType)
                }
            }
        }
    }
    
}

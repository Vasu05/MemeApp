//
//  MemeExtension.swift
//  MemeApp
//
//  Created by vasu on 28/10/18.
//  Copyright © 2018 Vasu. All rights reserved.
//

import Foundation
import AVFoundation
import Photos

extension MemeHomePageVC{
    
 
    
    
    // MARK: Camera , Photos , File Saving Acesss Permission
    
    func cameraPermission()  {
        
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.openImagePickerController( mCameraBtn)
            
            // The user has previously granted access to the camera.
            break;
            
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.openImagePickerController(self.mCameraBtn)
                    
                    // self.setupCaptureSession()
                }
            }
            break;
        case .denied:
            showDialog(title: "Error", desc: "Provide Camera Acess Permission")
            print("no camera permission ")  // The user has previously denied access.
            return
        case .restricted:
            showDialog(title: "Error", desc: "Provide Camera Acess Permission")
            
            print("no camera permission ") // The user can't grant access due to restrictions.
            return
        }
        
        
    }
    
    func photoPermission()  {
        switch PHPhotoLibrary.authorizationStatus() {
            
        case .notDetermined:
            print("NotDetermined")
            PHPhotoLibrary.requestAuthorization { (status:PHAuthorizationStatus) -> Void in
                print("photos permission granted")
                self.openImagePickerController(self.mAlbumsBtn)
            }
            break
            
        case .authorized:
            print("PHAuthorizationStatus.Authorized")
            print("photos permission granted")
            self.openImagePickerController(mAlbumsBtn)
            break
            
            
        case .restricted:
            print("PHAuthorizationStatus.Restricted")
            break
        case .denied:
            showDialog(title: "Photos", desc: "Provide Photos Acess Permission")
            
            print("PHAuthorizationStatus.Denied")
            
            break
            
        }
    }
    
    
    //MARK :KEYBOARD
    
    func getKeyBoardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyBoardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyBoardSize.cgRectValue.height
        
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if mBottomTextField.isFirstResponder{
            view.frame.origin.y -= getKeyBoardHeight(notification)
            
        }
    }
    
    func keyboardWillHide()  {
        view.frame.origin.y = 0
    }
    
    func suscriberToKeyBoardNotification()  {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func unsuscriberToKeyBoardNotification()  {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    
    
    
    
    func showDialog(title:String,desc:String)  {
        
        let alert = UIAlertController(title: title, message: desc, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "OK", style:.default ))
        present(alert,animated: true)
    }
    
    
    func generateMemedImage() -> UIImage {
        
        
        UIGraphicsBeginImageContext(self.mMemedView.frame.size)
        mMemedView.drawHierarchy(in: self.mMemedView.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    func save() {
        
        memedImage = generateMemedImage()
        
        _ = MemeModel(mTopTextField.text!, mBottomTextField.text!,mImageView.image!, memedImage!)
    }
    
}

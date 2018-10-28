//
//  ViewController.swift
//  MemeApp
//
//  Created by vasu on 24/10/18.
//  Copyright © 2018 Vasu. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class MemeHomePageVC: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate ,UINavigationControllerDelegate{

    @IBOutlet weak var mImageView: UIImageView!
    
    @IBOutlet weak var mTopTextField: UITextField!
    
    @IBOutlet weak var mBottomTextField: UITextField!
    
    @IBOutlet weak var mCameraBtn: UIButton!
    @IBOutlet weak var mAlbumsBtn: UIButton!
    @IBOutlet weak var mShareBtn: UIButton!
    @IBOutlet weak var mDownloadBtn: UIButton!
    @IBOutlet weak var mMemedView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mTopTextField.delegate = self
        mBottomTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        mCameraBtn.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        self.suscriberToKeyBoardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.unsuscriberToKeyBoardNotification()
    }
    
    // MARK: Camera , Photos , File Saving Acesss Permission
    
    func cameraPermission()  {
        
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
               self.openImagePickerController(mCameraBtn)
                
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
            self.openImagePickerController(self.mAlbumsBtn)
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
    
    
    
    func configureUI()  {
        let mMemeTextAttributes :[NSAttributedString.Key:Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor :UIColor.clear,
            NSAttributedString.Key.font:UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!
        ];
        
        mTopTextField.defaultTextAttributes = mMemeTextAttributes
        mBottomTextField.defaultTextAttributes = mMemeTextAttributes
        
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
    
    // MARK: TextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.keyboardWillHide()
        return true;
    }
    
    
    
    
    
    // MARK: ButtonPressedMethod
    
    @IBAction func cameraBtnPressed(_ sender: Any) {
       
        self.cameraPermission()
        
    }
    @IBAction func shareBtnPressed(_ sender: Any) {
        
        
        if let image = mImageView.image{
            
            let items = [image]
            
            let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
            self.present(activityController,animated: true,completion: nil)
        }
        else{
            showDialog(title: "Error", desc: "Please add image to view")
        }
        
       
        
    }
    
    @IBAction func albumsBtnPressed(_ sender: Any) {
        
        self.photoPermission()
    }
    
    
    
    func openImagePickerController(_ buttonType:UIButton) -> Void {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = buttonType.isEqual(mCameraBtn) ? .camera:.photoLibrary
        present(imagePicker,animated:  true,completion: nil)
    }
    
    //MARK: ImagePickerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            mImageView.image = image
            mShareBtn.isEnabled = true
        }
    }
    
    func generateMemedImage() -> UIImage {
        
        
        UIGraphicsBeginImageContext(self.mMemedView.frame.size)
        mMemedView.drawHierarchy(in: self.mMemedView.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    
    @IBAction func  saveImage(_ sender: Any)  {
        
        if  mImageView.image != nil{
            let memedImage = generateMemedImage()
        UIImageWriteToSavedPhotosAlbum(memedImage,self ,#selector(image(_:didFinishSavingWithError:contextInfo:)),nil)
            
        }else{
            showDialog(title: "Error", desc: "Please add image to view")
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if  error == nil  {
            showDialog(title: "Success", desc: "Image saved successfully ! ")
        }else{
            showDialog(title: "Error", desc: "Error Occured while saving photos ! ")

        }
    }
    
    
    func showDialog(title:String,desc:String)  {
        
        let alert = UIAlertController(title: title, message: desc, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "OK", style:.default ))
        present(alert,animated: true)
    }
    
}


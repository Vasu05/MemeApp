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
    
    var memedImage :UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mTopTextField.delegate = self
        mBottomTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        mCameraBtn.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        suscriberToKeyBoardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsuscriberToKeyBoardNotification()
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
    
    
    
  
    
    // MARK: TextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        keyboardWillHide()
        return true;
    }
    
    
    
    
    
    // MARK: ButtonPressedMethod
    
    @IBAction func cameraBtnPressed(_ sender: Any) {
       
        cameraPermission()
        
    }
    @IBAction func shareBtnPressed(_ sender: Any) {
        
        
        if let image = mImageView.image{
            
            let items = [image]
            
            let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
            
            activityController.completionWithItemsHandler = {
                (type,completed,items,error) in
                
                if error==nil{
                    self.save()
                }
                
            }
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
    
    
    
    
    @IBAction func  saveImage(_ sender: Any)  {
        
        if  mImageView.image != nil{
            memedImage = self.generateMemedImage()
        UIImageWriteToSavedPhotosAlbum(memedImage,self ,#selector(image(_:didFinishSavingWithError:contextInfo:)),nil)
            
        }else{
            showDialog(title: "Error", desc: "Please add image to view")
        }
    }
    
  
}


//
//  MemeHomePageVC.swift
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
    
   // @IBOutlet weak var mCameraBtn: UIButton!
  //  @IBOutlet weak var mAlbumsBtn: UIButton!
    @IBOutlet weak var mShareBtn: UIButton!
    @IBOutlet weak var mCancelBtn: UIButton!
    
    @IBOutlet weak var mMemedView: UIView!
    
    @IBOutlet weak var mCameraBtn: UIBarButtonItem!
    
    @IBOutlet weak var mAlbumsBtn: UIBarButtonItem!
    
    @IBOutlet weak var mToolbar: UIToolbar!
    var memedImage :UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(mTopTextField)
        configureUI(mBottomTextField)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        mCameraBtn.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        suscriberToKeyBoardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsuscriberToKeyBoardNotification()
    }
    
    
    
    func configureUI(_ textField:UITextField)  {
        
        let mMemeTextAttributes :[NSAttributedString.Key:Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor :UIColor.white,
            NSAttributedString.Key.font:UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
            NSAttributedString.Key.strokeWidth: -3
        ]
        
        textField.defaultTextAttributes = mMemeTextAttributes
        textField.textAlignment = .center
        textField.borderStyle = .none
        textField.delegate = self
        
    }
    
    
    
  
    
    // MARK: TextFieldDelegate
   
    
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
                
                if  completed{
                   
                    self.showDialog(title: "Image", desc: "Image Saved Successfuly!")
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
    
    @IBAction func cancelBtnPressed(_ sender:Any){
        mImageView.image = nil
        mTopTextField.text = ""
        mBottomTextField.text = ""
    }
    
    
    func openImagePickerController(_ buttonType:UIBarButtonItem) -> Void {
        
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
    
    
    
   
    
  
}


//
//  ViewController.swift
//  MemeApp
//
//  Created by vasu on 24/10/18.
//  Copyright © 2018 Vasu. All rights reserved.
//

import UIKit

class MemeHomePageVC: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate ,UINavigationControllerDelegate{

    @IBOutlet weak var mImageView: UIImageView!
    
    @IBOutlet weak var mTopTextField: UITextField!
    
    @IBOutlet weak var mBottomTextField: UITextField!
    
    @IBOutlet weak var mCameraBtn: UIButton!
    @IBOutlet weak var mAlbumsBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        mTopTextField.delegate = self
        mBottomTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        mCameraBtn.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    
    
    // MARK: TextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true;
    }
    
    // MARK: ButtonPressedMethod
    
    @IBAction func cameraBtnPressed(_ sender: Any) {
       
        self.openImageViewController(mCameraBtn)
        
    }
    @IBAction func shareBtnPressed(_ sender: Any) {
        
        
    }
    
    @IBAction func albumsBtnPressed(_ sender: Any) {
        
        self.openImageViewController(mAlbumsBtn)
    }
    
    
    
    func openImageViewController(_ buttonType:UIButton) -> Void {
        
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
        }
    }
}


//
//  LoginExtensionVC.swift
//  ChatApp
//
//  Created by Aboubakrine Niane on 07/02/2018.
//  Copyright © 2018 Aboubakrine Niane. All rights reserved.
//

import UIKit

extension LoginVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    
    @objc func selectTapOnProfileImageView(){
        let imagePicker = UIImagePickerController.init()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            setProfileImage(image: editedImage)
        }else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            setProfileImage(image: originalImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    

}

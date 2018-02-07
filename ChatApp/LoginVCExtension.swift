//
//  LoginVCExtension.swift
//  ChatApp
//
//  Created by Aboubakrine Niane on 07/02/2018.
//  Copyright © 2018 Aboubakrine Niane. All rights reserved.
//

import UIKit
import FirebaseAuth


extension LoginVC {
    
     func setupViewForms() {
        view.addSubview(inputViews)
        
        NSLayoutConstraint.activate([
            inputViews.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputViews.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            inputViews.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            inputViews.heightAnchor.constraint(equalToConstant: 150)
            ])
        
        let formStack = UIStackView.init(arrangedSubviews: [nameField,emailField,passwordField])
        formStack.distribution = .fillEqually
        formStack.spacing = 1
        formStack.axis = .vertical
        formStack.translatesAutoresizingMaskIntoConstraints = false
        _stackForm = formStack
        inputViews.addSubview(formStack)
        NSLayoutConstraint.activate([
            formStack.topAnchor.constraint(equalTo: inputViews.topAnchor),
            formStack.leadingAnchor.constraint(equalTo: inputViews.leadingAnchor),
            formStack.trailingAnchor.constraint(equalTo: inputViews.trailingAnchor),
            formStack.bottomAnchor.constraint(equalTo: inputViews.bottomAnchor)
            ])
        
    }
    
     func setupRegisterButton() {
        view.addSubview(registerButton)
        NSLayoutConstraint.activate([
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.widthAnchor.constraint(equalTo: inputViews.widthAnchor),
            registerButton.topAnchor.constraint(equalTo: inputViews.bottomAnchor, constant : 16),
            registerButton.heightAnchor.constraint(equalToConstant: 44)
            ])
    }
    
     func setupProfileImage() {
        view.addSubview(profileImage)
        NSLayoutConstraint.activate([
            profileImage.widthAnchor.constraint(equalToConstant: 100),
            profileImage.heightAnchor.constraint(equalToConstant: 100),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -24)
            ])
    }
    
     func setTextFieldsDelegate() {
        emailField.delegate = self
        passwordField.delegate = self
        nameField.delegate = self
    }
    
     func setupLoginRegisterControls() {
        view.addSubview(loginRegisterSegmentedControl)
        NSLayoutConstraint.activate([
            loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputViews.widthAnchor),
            loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 34),
            loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputViews.topAnchor, constant: -16)
            ])
    }
    
    @objc  func handleLoginRegister() {
        let title = NSAttributedString.init(string: loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)!, attributes: [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17),
            NSAttributedStringKey.foregroundColor : UIColor.white
            ])
        registerButton.setAttributedTitle(title, for: .normal)
        
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            _stackForm.removeArrangedSubview(nameField)
        }else {
            _stackForm.insertArrangedSubview(nameField, at: 0)
        }
    }
    
    @objc func performLoginOrRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 1 {
            handleRegister()
        }else {
            handleLogin()
        }
    }
    
     func handleLogin(){
        guard let email = emailField.text , let password = passwordField.text else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                print(error ?? "No error")
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
     func handleRegister() {
        
        guard let email = emailField.text , let password = passwordField.text , let name = nameField.text
            else {
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user : User?, error) in
            
            if error != nil {
                print(error ?? "No error")
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let userReferences = Database.database().reference(fromURL: "https://chatapp-9eb9e.firebaseio.com/").child("users").child(uid)
            let values = ["name":name,"email":email,"password":password]
            userReferences.updateChildValues(values, withCompletionBlock: { (error, userReferences) in
                if error != nil {
                    print(error ?? "No error")
                }
                
                self.dismiss(animated: true, completion: nil)
            })
            
            
            
        }
    }
    
}

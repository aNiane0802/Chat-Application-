//
//  LoginVC.swift
//  ChatApp
//
//  Created by Aboubakrine Niane on 04/02/2018.
//  Copyright © 2018 Aboubakrine Niane. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginVC: UIViewController , UITextFieldDelegate {
    
    
    private var _stackForm = UIStackView()
    private let loginRegisterSegmentedControl : UISegmentedControl = {
       let segmentedControl = UISegmentedControl.init(items: ["Login","Register"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.tintColor = UIColor.white
        segmentedControl.addTarget(self, action: #selector(handleLoginRegister), for: .valueChanged)
        return segmentedControl
    }()
    
    private let inputViews : UIView = {
        let viewForm = UIView.init()
        viewForm.backgroundColor = UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        viewForm.translatesAutoresizingMaskIntoConstraints = false
        viewForm.layer.cornerRadius = 5
        viewForm.clipsToBounds = true
        return viewForm
    }()
    
    private let nameField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = UITextBorderStyle.roundedRect
        return textField
    }()
    
    private let registerButton : UIButton = {
       let button = UIButton.init(type: .system)
        let title = NSAttributedString.init(string: "Register", attributes: [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17),
            NSAttributedStringKey.foregroundColor : UIColor.white
            ])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = UIColor.init(red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(performLoginOrRegister), for: .touchUpInside)
        return button
    }()
    
    private let emailField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = UITextBorderStyle.roundedRect
        return textField
    }()
    
    private let passwordField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.isSecureTextEntry = true 
        return textField
    }()
    
    private let profileImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.init(red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 2.5
        imageView.layer.borderColor = UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1).cgColor
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
        setupViewForms()
        setupRegisterButton()
        setupLoginRegisterControls()
        setupProfileImage()
        setTextFieldsDelegate()
        
        
    }
    
    @objc private func performLoginOrRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 1 {
            handleRegister()
        }else {
            handleLogin()
        }
    }
    
    private func handleLogin(){
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
    
    private func handleRegister() {
        
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
    
    private func setupViewForms() {
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
    
    private func setupRegisterButton() {
        view.addSubview(registerButton)
        NSLayoutConstraint.activate([
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.widthAnchor.constraint(equalTo: inputViews.widthAnchor),
            registerButton.topAnchor.constraint(equalTo: inputViews.bottomAnchor, constant : 16),
            registerButton.heightAnchor.constraint(equalToConstant: 44)
            ])
    }
    
    private func setupProfileImage() {
        view.addSubview(profileImage)
        NSLayoutConstraint.activate([
            profileImage.widthAnchor.constraint(equalToConstant: 100),
            profileImage.heightAnchor.constraint(equalToConstant: 100),
            profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImage.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -24)
            ])
    }
    
    private func setTextFieldsDelegate() {
        emailField.delegate = self
        passwordField.delegate = self
        nameField.delegate = self
    }
    
    private func setupLoginRegisterControls() {
        view.addSubview(loginRegisterSegmentedControl)
        NSLayoutConstraint.activate([
            loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputViews.widthAnchor),
            loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 34),
            loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputViews.topAnchor, constant: -16)
            ])
    }
    
    @objc private func handleLoginRegister() {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

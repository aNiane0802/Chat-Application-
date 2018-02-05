//
//  LoginVC.swift
//  ChatApp
//
//  Created by Aboubakrine Niane on 04/02/2018.
//  Copyright © 2018 Aboubakrine Niane. All rights reserved.
//

import UIKit

class LoginVC: UIViewController , UITextFieldDelegate {
    
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
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
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
        setupProfileImage()
        setTextFieldsDelegate()
    }
    
    @objc func handleRegister() {
        
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
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
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
            profileImage.bottomAnchor.constraint(equalTo: inputViews.topAnchor, constant: -40)
            ])
    }
    
    private func setTextFieldsDelegate() {
        emailField.delegate = self
        passwordField.delegate = self
        nameField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

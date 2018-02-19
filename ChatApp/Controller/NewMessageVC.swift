//
//  NewMessageVC.swift
//  ChatApp
//
//  Created by Aboubakrine Niane on 19/02/2018.
//  Copyright © 2018 Aboubakrine Niane. All rights reserved.
//

import UIKit

class NewMessageVC: UIViewController {

    private let sendButton : UIButton = {
        let button = UIButton.init(type: UIButtonType.system)
        button.setTitle("SEND", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.08601888021, green: 0.3047497225, blue: 1, alpha: 1)
        return button 
    }()
    
    private let messageArea : UITextField = {
        let textField =  UITextField()
        textField.placeholder = "  Enter message..."
        textField.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = #colorLiteral(red: 0.887162745, green: 0.887162745, blue: 0.887162745, alpha: 1)
        textField.textColor = UIColor.darkText
        textField.borderStyle = UITextBorderStyle.roundedRect
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFormsViews()
    }
    
    @objc func sendMessage() {
        
    }
    
    func setFormsViews() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            containerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            containerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 60)
            ])
        
        containerView.addSubview(sendButton)
        NSLayoutConstraint.activate([
            sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            sendButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 60)
            ])
        
        containerView.addSubview(messageArea)
        NSLayoutConstraint.activate([
            messageArea.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            messageArea.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            messageArea.topAnchor.constraint(equalTo: containerView.topAnchor),
            messageArea.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8)
            ])
        
    }
    
    

}

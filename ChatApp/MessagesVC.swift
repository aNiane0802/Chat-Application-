//
//  MessagesVC.swift
//  ChatApp
//
//  Created by Aboubakrine Niane on 04/02/2018.
//  Copyright © 2018 Aboubakrine Niane. All rights reserved.
//

import UIKit

class MessagesVC: UITableViewController {
    
    private let nameField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        return textField
    }()
    
    private let emailField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        return textField
    }()
    
    private let passwordField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Logout", style: .plain, target: self, action: #selector(backToLoginPage))
    
    }
    
    @objc func backToLoginPage() {
        present(LoginVC().self, animated: true, completion: nil)
    }
    
    
    
    
}

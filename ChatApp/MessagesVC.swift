//
//  MessagesVC.swift
//  ChatApp
//
//  Created by Aboubakrine Niane on 04/02/2018.
//  Copyright © 2018 Aboubakrine Niane. All rights reserved.
//

import UIKit
import FirebaseAuth

class MessagesVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Logout", style: .plain, target: self, action: #selector(backToLoginPage))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title : "New Message", style: .plain, target: self, action: #selector(sendNewMessage))
        
        if Auth.auth().currentUser == nil {
            performSelector(onMainThread: #selector(backToLoginPage), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func backToLoginPage() {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch let error  {
            print(error)
        }
        present(LoginVC().self, animated: true, completion: nil)
    }
    
    @objc func sendNewMessage() {
        
    }
}

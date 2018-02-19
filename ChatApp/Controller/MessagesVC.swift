//
//  MessagesVC.swift
//  ChatApp
//
//  Created by Aboubakrine Niane on 04/02/2018.
//  Copyright © 2018 Aboubakrine Niane. All rights reserved.
//  Handle the problem of the title View

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MessagesVC: UITableViewController {
    
    private var _users = [Any]()
    
    private var profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Logout", style: .plain, target: self, action: #selector(backToLoginPage))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title : "New Message", style: .plain, target: self, action: #selector(sendNewMessage))
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        handleFirstVCTopPresent()
       // setupViewsInNavBar()
        
    }
    
    func handleFirstVCTopPresent() {
        if let uid = Auth.auth().currentUser?.uid {
            getUserName(uid: uid)
        }else {
            performSelector(onMainThread: #selector(backToLoginPage), with: nil, waitUntilDone: false)
        }
    }
    
    private func getUserName(uid : String)  {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            guard let values = snapshot.value as? [String : Any] else {
                return
            }
            
            guard let name = values["name"] as? String else {
                print("Enable to query the database for the name ")
                return
            }
           self.navigationItem.title = name
            
        })
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
        present(UINavigationController.init(rootViewController: ContactsVC()), animated: true, completion: nil)
    }
    
    
    func setupViewsInNavBar() {
        
        let containerView = UIView.init()
        containerView.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 44),
            profileImageView.heightAnchor.constraint(equalToConstant: 44)
            ])
    }
    
}

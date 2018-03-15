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
    private let cellID = "cellId"
    private var _messages = [Message]()
    private var _lastMessagePerUser = [String:Any]()
    
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
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellID)
       
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
            self._messages.removeAll()
            self._lastMessagePerUser.removeAll()
            self.getMessagesForCurrentUser()
            
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
        let contactsVC = ContactsVC()
        contactsVC.setMessagesReference(messagesVC: self)
        present(UINavigationController.init(rootViewController: contactsVC), animated: true, completion: nil)
    }
    
    private func getMessagesForCurrentUser() {
        
        guard let currentUserUid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let eferenceForUsersMessages = Database.database().reference().child("usersMessages").child(currentUserUid)
        eferenceForUsersMessages.observe(.childAdded, with: { (snapshot) in
            
            let messageKey = snapshot.key
            
            let referenceForUsersMessages = Database.database().reference().child("messages").child(messageKey)
            referenceForUsersMessages.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let values = snapshot.value as? [String:Any] else {
                    return
                }
                
                guard let messageText = values["text"] as? String , let receiver = values["receiver"] as? String , let sender = values["sender"] as? String , let timeStamp = values["timeStamp"] as? TimeInterval else {
                    return
                }
                
                
                let message = Message.init(content: messageText, senderUid: sender, receiverUid: receiver, time: timeStamp)
                let chatPartenerUID = message.getChatPartenerUid()
                self._lastMessagePerUser[chatPartenerUID] = message
                
                self._messages = Array(self._lastMessagePerUser.values) as! [Message] // What does it do ?
                self._messages.sort(by: { (message1, message2) -> Bool in
                    if message1.time > message2.time{
                        return true
                    }else {
                        return false
                    }
                    
                })
                
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }, withCancel: nil)
            
        }, withCancel: nil)
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? ContactCell {
            let message = _messages[indexPath.row]
            
            guard let uid = Auth.auth().currentUser?.uid else {
                return ContactCell()
            }
            
            var reference = Database.database().reference()
            if uid == message.receiverUid{
                reference = reference.child("users").child(message.senderUid)
            }else {
                reference = reference.child("users").child(message.receiverUid)
            }
            
            reference.observe(.value, with: { (snapShot) in
                
                guard let values = snapShot.value as? [String:Any] else {
                    return
                }
                
                guard let name = values["name"] as? String , let profileImageUrl = values["profileImageURL"] as? String else {
                    return
                }
                
                cell.setUserInformations(name: name, email: message.content!)
                let dateFormatter = DateFormatter.init()
                dateFormatter.dateFormat = "HH:mm:ss"
                dateFormatter.timeStyle = DateFormatter.Style.short
                let date = Date.init(timeIntervalSince1970: message.time)
                cell.setTimeLabel(time: dateFormatter.string(from: date))
                cell.setUserProfileImage(profileImageURL: profileImageUrl)
                
            }, withCancel: nil)
            
            return cell
        }
        return ContactCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = _messages[indexPath.row]
        let receiverUid = message.getChatPartenerUid()
        
        let reference = Database.database().reference().child("users").child(receiverUid)
        
        reference.observeSingleEvent(of: .value, with: { (snapshot) in
           
            if let values = snapshot.value as? [String:Any] {
                
                guard let name = values["name"] as? String , let email = values["email"] as? String , let profileImageUrl = values["profileImageURL"] as? String else {
                    return
                }
               let receiver = Contact.init(name: name, email: email, profileImageURL: profileImageUrl, uid: receiverUid)
                let chatController = ChatController()
                chatController.view.backgroundColor = .white
                chatController.setReceiver(receiver: receiver)
                self.navigationController?.pushViewController(chatController, animated: true)
 
            }  
        }, withCancel: nil)

        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
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

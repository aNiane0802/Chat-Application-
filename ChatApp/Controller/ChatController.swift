 //
//  NewMessageVC.swift
//  ChatApp
//
//  Created by Aboubakrine Niane on 19/02/2018.
//  Copyright © 2018 Aboubakrine Niane. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


 class ChatController: UIViewController , UITextFieldDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    private var _receiver = Contact(){
        didSet{
            navigationItem.title = _receiver.name
        }
    }
    
    private let cellID = "cellID"
    private var _messages = [Message]()
    
    // Collection views need a UICollectionViewFlowLayout object to be instanciated correctly
    private var _messagesCollectionView : UICollectionView = {
       let collectionView = UICollectionView.init(frame: CGRect.init(), collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true 
        return collectionView
        
    }()

    private let sendButton : UIButton = {
        let button = UIButton.init(type: UIButtonType.system)
        button.setTitle("SEND", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.2537977431, blue: 0.4723718762, alpha: 1)
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
        messageArea.delegate = self
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        setFormsViews()
        _messagesCollectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellID)
        _messagesCollectionView.dataSource = self
        _messagesCollectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        observeMessages()// Why here and not in the viewDidLoad ? The value of receiver has not been set yet in the view did Load
       
    }
    
    @objc func sendMessage() {
        guard let senderUid = Auth.auth().currentUser?.uid , let messageText = messageArea.text else {
            return
        }
        let timeStamp = NSDate.init().timeIntervalSince1970
        
        let values = ["text":messageText,"sender":senderUid,"receiver":_receiver.uid,"timeStamp":timeStamp] as [String:Any]
        let reference = Database.database().reference().child("messages").childByAutoId()
        reference.updateChildValues(values)
        
        let referenceForSenderMessages = Database.database().reference().child("usersMessages").child(senderUid)
        let valuesForUsersMessages =  [reference.key:1] as [String:Any]
        referenceForSenderMessages.updateChildValues(valuesForUsersMessages)
        
        let referenceForReceiverMesages = Database.database().reference().child("usersMessages").child(_receiver.uid)
        referenceForReceiverMesages.updateChildValues(valuesForUsersMessages)
    }
    
    func setFormsViews() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -8),
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
        
        view.addSubview(_messagesCollectionView)
        NSLayoutConstraint.activate([
            _messagesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            _messagesCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            _messagesCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            _messagesCollectionView.bottomAnchor.constraint(equalTo: containerView.topAnchor)
            ])
        
    }
    
    func observeMessages() {
        let reference = Database.database().reference().child("usersMessages").child(_receiver.uid)
        reference.observe(.childAdded, with: { (snapshot) in
            let messageID = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageID)
            messagesRef.observe(.value, with: { (snapshot) in
            
                guard let values = snapshot.value as? [String:Any] else {
                    return
                }
                
                guard let messageText = values["text"] as? String , let receiver = values["receiver"] as? String , let sender = values["sender"] as? String , let timeStamp = values["timeStamp"] as? TimeInterval else {
                    return
                }
                
                
                let message = Message.init(content: messageText, senderUid: sender, receiverUid: receiver, time: timeStamp)
                if message.getChatPartenerUid() == self._receiver.uid {
                    self._messages.append(message)
                    DispatchQueue.main.async {
                        self._messagesCollectionView.reloadData()
                    }
                    
                }
                
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    //MARK: TextField Delegate methods 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func setReceiver(receiver : Contact) {
        _receiver = receiver
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? ChatMessageCell {
            cell.backgroundColor = .red
            let message = _messages[indexPath.row]
            cell.setText(text: message.content!)
            return cell

        }
        return ChatMessageCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: view.frame.width, height: 80)
    }
}

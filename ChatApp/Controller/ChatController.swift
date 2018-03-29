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

    internal var _receiver = Contact(){
        didSet{
            navigationItem.title = _receiver.name
        }
    }
    
    internal let cellID = "cellID"
    
    
    lazy var _containerView : UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    
    
    // Collection views need a UICollectionViewFlowLayout object to be instanciated correctly
    internal var _messagesCollectionView : UICollectionView = {
        let collectionView = UICollectionView.init(frame: CGRect.init(), collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        return collectionView
        
    }()
    
    internal let sendButton : UIButton = {
        let button = UIButton.init(type: UIButtonType.system)
        button.setTitle("SEND", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.2537977431, blue: 0.4723718762, alpha: 1)
        return button
    }()
    
    internal let messageArea : UITextField = {
        let textField =  UITextField()
        textField.placeholder = "  Enter message..."
        textField.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = #colorLiteral(red: 0.887162745, green: 0.887162745, blue: 0.887162745, alpha: 1)
        textField.textColor = UIColor.darkText
        textField.borderStyle = UITextBorderStyle.roundedRect
        return textField
    }()
    
    // Unable to work with the inputAccessoryView . Some of the things have to check up later
    /*
    override var inputAccessoryView: UIView?{
        get{
            return _containerView
        }
    }
  */
    
    
    lazy var _messages = [Message]()
    internal lazy  var containerBottomAnchor =  NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        setFormsViews()
        setupMessagesCollectionView()
        addObserverToKeyboard()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        observeMessages()// Why here and not in the viewDidLoad ? The value of receiver has not been set yet in the view did Load
       
    }
   
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        _messagesCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    @objc func sendMessage() {
        guard let senderUid = Auth.auth().currentUser?.uid , let messageText = messageArea.text else {
            return
        }
        let timeStamp = NSDate.init().timeIntervalSince1970
        
        let values = ["text":messageText,"sender":senderUid,"receiver":_receiver.uid,"timeStamp":timeStamp] as [String:Any]
        let reference = Database.database().reference().child("messages").childByAutoId()
        reference.updateChildValues(values)
        
        let referenceForSenderMessages = Database.database().reference().child("usersMessages").child(senderUid).child(_receiver.uid)
        let valuesForUsersMessages =  [reference.key:1] as [String:Any]
        referenceForSenderMessages.updateChildValues(valuesForUsersMessages)
        
        let referenceForReceiverMesages = Database.database().reference().child("usersMessages").child(_receiver.uid).child(senderUid)
        referenceForReceiverMesages.updateChildValues(valuesForUsersMessages)
        
        messageArea.text = ""
    }
    
    fileprivate func setupMessagesCollectionView() {
        _messagesCollectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellID)
        _messagesCollectionView.dataSource = self
        _messagesCollectionView.delegate = self
        _messagesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        _messagesCollectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        _messagesCollectionView.keyboardDismissMode = .onDrag
    }
    
    
    func observeMessages() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let reference = Database.database().reference().child("usersMessages").child(uid).child(_receiver.uid)
        reference.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let values = snapshot.value as? [String:Any] else {
                    return
                }
                
                guard let receiver = values["receiver"] as? String , let sender = values["sender"] as? String , let text = values["text"] as? String , let time = values["timeStamp"] as? TimeInterval else {
                    return
                }
                
                let message = Message(content: text, senderUid: sender, receiverUid: receiver, time: time)
                if message.getChatPartenerUid() == self._receiver.uid {
                    DispatchQueue.main.async {
                        self._messages.append(message)
                        self._messagesCollectionView.reloadData()
                    }
                }
            
            })
            
        }, withCancel: nil)
    }
    
    public func setReceiver(receiver : Contact) {
        _receiver = receiver
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? ChatMessageCell {
            
            guard let currentUserUid = Auth.auth().currentUser?.uid else { return ChatMessageCell() }
            
            let message = _messages[indexPath.row]
            cell.setText(text: message.content!)
            cell.bubbleWidthConstraint.constant = estimatedFrameForText(text: message.content!).width + 36
            
            if message.receiverUid == currentUserUid {
                cell.changeBubbleViewColor(color: #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1))
                cell.changeTextViewColor(color: UIColor.black)
                cell.setupForReceivedMessages(profileImageUrl: _receiver.profileImageURL)
            }else {
                cell.changeBubbleViewColor(color: #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1))
                cell.changeTextViewColor(color: .white)
                cell.setupForSentMessages()
            }
            return cell

        }
        return ChatMessageCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height = CGFloat.init(80)
        
        if let text = _messages[indexPath.item].content{
            let estimatedFrame = estimatedFrameForText(text: text)
            height = estimatedFrame.height + 36
        }
        return CGSize.init(width: _messagesCollectionView.frame.width, height: height)
    }
    
    
    //Check every object and methods . Related to typography , Check chapter typography to understand better
    private func estimatedFrameForText(text: String) -> CGRect{
        
        let size = CGSize(width: 205, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18, weight: .medium)], context: nil)
    }
    
    func addObserverToKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide , object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleKeyboardWillShow(notification : Notification){
        guard let userInfo = notification.userInfo else {
            return
        }
        
        guard let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect , let keyboardDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        containerBottomAnchor.constant -= keyboardFrame.height - 8
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }

    }
    
    @objc func handleKeyboardWillHide(notification : Notification){
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let keyboardDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        self.containerBottomAnchor.constant = -8
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
}

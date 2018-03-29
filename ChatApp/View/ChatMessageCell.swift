//
//  ChatMessageCell.swift
//  ChatApp
//
//  Created by Aboubakrine Niane on 14/03/2018.
//  Copyright © 2018 Aboubakrine Niane. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    lazy var bubbleWidthConstraint = NSLayoutConstraint()
    lazy var bubbleRightAnchor = NSLayoutConstraint()
    lazy var bubbleLeftAnchor = NSLayoutConstraint()
    
    private let _messageTextView : UITextView = {
       let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor.clear
        textView.textColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return textView
    }()
    
    
    private let _profileImageView : UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.backgroundColor = .blue
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let _bubbleView : UIView = {
       let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.clipsToBounds = true 
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        addSubview(_bubbleView)
        bubbleWidthConstraint = _bubbleView.widthAnchor.constraint(equalToConstant: 210)
        bubbleLeftAnchor = _bubbleView.leftAnchor.constraint(equalTo: _profileImageView.rightAnchor, constant: 8)
        bubbleRightAnchor = _bubbleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)
        NSLayoutConstraint.activate([
            bubbleRightAnchor,
            bubbleWidthConstraint,
            _bubbleView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            _bubbleView.heightAnchor.constraint(equalTo: heightAnchor)
            
            ])
        
        addSubview(_messageTextView)
        NSLayoutConstraint.activate([
            _messageTextView.centerXAnchor.constraint(equalTo: _bubbleView.centerXAnchor),
            _messageTextView.widthAnchor.constraint(equalTo: _bubbleView.widthAnchor, constant: -8),
            _messageTextView.topAnchor.constraint(equalTo: _bubbleView.topAnchor, constant: 4),
            _messageTextView.bottomAnchor.constraint(equalTo: _bubbleView.bottomAnchor, constant: -4)
            
            ])
        
        addSubview(_profileImageView)
        NSLayoutConstraint.activate([
            _profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            _profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            _profileImageView.widthAnchor.constraint(equalToConstant: 32),
            _profileImageView.heightAnchor.constraint(equalToConstant: 32)
            ])
        
        _profileImageView.layer.cornerRadius = 16
        
    }
    
    func setText(text : String ){
        _messageTextView.text = text 
    }
    
    func changeBubbleViewColor(color : UIColor){
        _bubbleView.backgroundColor = color
    }
    
    func changeTextViewColor(color: UIColor){
        _messageTextView.textColor = color 
    }
    
    
    func setupForReceivedMessages(profileImageUrl : String){
        _profileImageView.loadImageUsingCacheWithURL(profileImageURL: profileImageUrl)
        _profileImageView.isHidden = false
        bubbleLeftAnchor.isActive = true
        bubbleRightAnchor.isActive = false
    }
    
    func setupForSentMessages() {
        _profileImageView.isHidden = true
        bubbleRightAnchor.isActive = true
        bubbleLeftAnchor.isActive = false
    }
    
}

//
//  ChatMessageCell.swift
//  ChatApp
//
//  Created by Aboubakrine Niane on 14/03/2018.
//  Copyright © 2018 Aboubakrine Niane. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    private let _messageTextView : UITextView = {
       let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.text = "Test"
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        addSubview(_messageTextView)
        NSLayoutConstraint.activate([
            _messageTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            _messageTextView.widthAnchor.constraint(equalToConstant: self.frame.width/2),
            _messageTextView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            _messageTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
            
            ])
        
    }
    
    func setText(text : String ){
        _messageTextView.text = text 
    }
    
}

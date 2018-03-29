//
//  ChatControllerExtension.swift
//  ChatApp
//
//  Created by Aboubakrine Niane on 24/03/2018.
//  Copyright © 2018 Aboubakrine Niane. All rights reserved.
//

import UIKit

extension ChatController {
    
    
    func setFormsViews() {
        view.addSubview(_containerView)
        
        containerBottomAnchor = _containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -8)
        
        NSLayoutConstraint.activate([
            containerBottomAnchor,
            _containerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            _containerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            _containerView.heightAnchor.constraint(equalToConstant: 60)
            ])
        
        _containerView.addSubview(sendButton)
        NSLayoutConstraint.activate([
            sendButton.trailingAnchor.constraint(equalTo: _containerView.trailingAnchor),
            sendButton.bottomAnchor.constraint(equalTo: _containerView.bottomAnchor),
            sendButton.topAnchor.constraint(equalTo: _containerView.topAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 60)
            ])
        
        _containerView.addSubview(messageArea)
        NSLayoutConstraint.activate([
            messageArea.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            messageArea.bottomAnchor.constraint(equalTo: _containerView.bottomAnchor),
            messageArea.topAnchor.constraint(equalTo: _containerView.topAnchor),
            messageArea.leadingAnchor.constraint(equalTo: _containerView.leadingAnchor, constant: 8)
            ])
        
        view.addSubview(_messagesCollectionView)
        NSLayoutConstraint.activate([
            _messagesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            _messagesCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            _messagesCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            _messagesCollectionView.bottomAnchor.constraint(equalTo: _containerView.topAnchor)
            ])
        
    }
}

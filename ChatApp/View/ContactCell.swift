//
//  ContactCell.swift
//  ChatApp
//
//  Created by Aboubakrine Niane on 11/02/2018.
//  Copyright © 2018 Aboubakrine Niane. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    private let emailField : UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.tintColor = UIColor.lightGray
        return label
    }()
    
    private let nameField : UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    
    private let profileImageView : UIImageView  = {
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        return profileImageView
    }()
    
    func setupSubViews(){
        addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            profileImageView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -8),
            profileImageView.widthAnchor.constraint(equalTo: self.heightAnchor, constant: -8)
            ])
        
        profileImageView.layer.cornerRadius = (self.frame.height-8)/2
        
        let stackViewContactInfos = UIStackView.init(arrangedSubviews: [nameField,emailField])
        stackViewContactInfos.translatesAutoresizingMaskIntoConstraints = false
        stackViewContactInfos.distribution = .fillEqually
        stackViewContactInfos.axis = .vertical
        
        addSubview(stackViewContactInfos)
        NSLayoutConstraint.activate([
            stackViewContactInfos.rightAnchor.constraint(equalTo: self.rightAnchor),
            stackViewContactInfos.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8),
            stackViewContactInfos.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackViewContactInfos.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -8)
            ])
    }
    
    func setUserInformations(name : String,email : String){
        emailField.text = email
        nameField.text = name
    }
    
    func setUserProfileImage(profileImageURL : String){
        profileImageView.loadImageUsingCacheWithURL(profileImageURL: profileImageURL)
    }
}

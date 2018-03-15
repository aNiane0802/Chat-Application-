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
        profileImageView.layer.cornerRadius = 75/2
        return profileImageView
    }()
    
    private let timeLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupSubViews(){
        addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 75),
            profileImageView.widthAnchor.constraint(equalTo: self.heightAnchor, constant: -8)
            ])
        
        
        
        
        addSubview(nameField)
        NSLayoutConstraint.activate([
            nameField.leftAnchor.constraint(equalTo: profileImageView.rightAnchor,constant:16),
            nameField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            nameField.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/2),
            nameField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
            ])
        
        addSubview(emailField)
        NSLayoutConstraint.activate([
            emailField.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            emailField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            emailField.heightAnchor.constraint(equalTo: nameField.heightAnchor),
            emailField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7)
            ])
        
        addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: -13),
            timeLabel.leadingAnchor.constraint(equalTo: nameField.trailingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            timeLabel.heightAnchor.constraint(equalToConstant: 22)
            ])
        
        
        
    }
    
    func setUserInformations(name : String,email : String){
        emailField.text = email
        nameField.text = name
    }
    
    func setUserProfileImage(profileImageURL : String){
        profileImageView.loadImageUsingCacheWithURL(profileImageURL: profileImageURL)
    }
    
    func setTimeLabel(time: String) {
        timeLabel.text = time 
    }
}

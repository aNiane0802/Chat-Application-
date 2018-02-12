//
//  ContactsVC.swift
//  ChatApp
//
//  Created by Aboubakrine Niane on 07/02/2018.
//  Copyright © 2018 Aboubakrine Niane. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ContactsVC: UITableViewController {
    
    private var _users = [Contact]()
    private let cellID = "cellID"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellID)
        getUsers()
    }
    
    func setupNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(handleBackButton))
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func getUsers() {
        Database.database().reference().child("users").observe(DataEventType.childAdded, with: { (snapShot) in
            
            guard let values = snapShot.value as? [String : Any] else {
                return
            }
            
            if let email = values["email"] as? String , let name = values["name"] as? String  , let profileImageURL = values["profileImageURL"]as? String {
                
                let contact = Contact(name : name , email : email , profileImageURL : profileImageURL)
                self._users.append(contact)
                self.tableView.reloadData()
            }
 
        }) { (error) in
            
            print(error)
            
        }
        
    }
    
    @objc func handleBackButton() {
        dismiss(animated: true, completion: nil )
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? ContactCell{
            
            if  let name = _users[indexPath.row].name , let email = _users[indexPath.row].email {
                cell.setupSubViews()
                if let profileImageURL = _users[indexPath.row].profileImageURL {
                    let url = URL.init(string: profileImageURL)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, reponse, error) in
                        if error != nil{
                            print(error ?? "No error message to display")
                        }else {
                            print(reponse ?? "No reponse message to display" )
                        }
                        if let profileImage = UIImage.init(data: data!){
                            DispatchQueue.main.async {
                                cell.updateCell(image: profileImage, name: name, email: email)
                            }
                        }
                    }).resume()
                }
                return cell
            }
        }
        
        
        return ContactCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }

}

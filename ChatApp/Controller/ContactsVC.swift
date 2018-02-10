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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
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
            
            if let email = values["email"] as? String , let name = values["name"] as? String {
                let contact = Contact(name : name , email : email)
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
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: self.cellID)
        
        cell.textLabel?.text = _users[indexPath.row].name
        cell.detailTextLabel?.text = _users[indexPath.row].email
        
        return cell
    }


}


//
//  Extensions.swift
//  ChatApp
//
//  Created by Aboubakrine Niane on 12/02/2018.
//  Copyright © 2018 Aboubakrine Niane. All rights reserved.
//

import UIKit

private var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithURL(profileImageURL : String){
        
        if let profileImage = imageCache.object(forKey: profileImageURL as AnyObject) as? UIImage{
            self.image = profileImage
        }else {
            let url = URL.init(string: profileImageURL)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, reponse, error) in
                if error != nil{
                    print(error ?? "No error message to display")
                    }
                if let profileImage = UIImage.init(data: data!){
                    DispatchQueue.main.async {
                        imageCache.setObject(profileImage, forKey: profileImageURL as AnyObject)
                        self.image = profileImage
                    }
                }
            }).resume()
        }
    }
}

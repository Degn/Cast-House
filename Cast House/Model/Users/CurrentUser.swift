//
//  CurrentUser.swift
//  Cast House
//
//  Created by Simon Degn on 18/10/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

struct CurrentUserData {
    static var profileImage = UIImage()
    static var id: String = ""
    static var image_url: String = ""
    static var name: String = ""
}

class CurrentUser: NSObject {
   
    func isLoggedIn() -> Bool {
        
        // Check if user is logged in
        let userId = Auth.auth().currentUser?.uid
        return userId != nil
    }
    
    
    func getUserInfo() {
        // Download user object from firestore by the id from the auth.
        
        let db = Firestore.firestore()
        CurrentUserData.id = (Auth.auth().currentUser?.uid)!
        db.collection("users").document(CurrentUserData.id).getDocument(completion: { (user, error) in
            if user != nil {
                CurrentUserData.image_url = user!["image_url"] as! String
                CurrentUserData.name = user!["name"] as! String
                
                self.getProfileImage(completion: { (image) in NotificationCenter.default.post(name:Notification.Name(rawValue:"CurrentUserDataUpdated"), object: nil)
                    CurrentUserData.profileImage = image
                })
            }
        })
    }
    
    func getProfileImage(completion: @escaping (_ result: UIImage) -> Void) {
        // Download async profile image from URL
        if CurrentUserData.image_url != "" {
            DispatchQueue.global().async {
                let url = URL(string: CurrentUserData.image_url)
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async(execute: {
                    CurrentUserData.profileImage = UIImage(data: data!)!
                    completion(CurrentUserData.profileImage)
                })
            }
        }
    }
}

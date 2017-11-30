//
//  NotificationObject.swift
//  Cast House
//
//  Created by Simon Degn on 29/11/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import UIKit
import Firebase

class NotificationObject: NSObject {
    
    var id: String!
    var type: String!
    var text: String?
    var sender_id: String!
    var sender_image: UIImage?

    func updateInfo(document: DocumentSnapshot) {
        id = document.documentID
        type = document["type"] as! String
        text = document["text"] as? String
        sender_id = document["sender"] as! String
    }
    
    func updateImage(urlString: String) {
        
        // TODO: missing function for updating the image...
    }
}

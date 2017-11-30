//
//  EpisodeObject.swift
//  Cast House
//
//  Created by Simon Degn on 29/11/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import UIKit
import Firebase

class EpisodeObject: NSObject {
    
    var id = String()
    var title = String()
    var link = String()
    var author = String()
    var descriptionText = String()
    var image_url = String()
    var image = UIImage()
    var lang = String()
    
    func updateInfo(document: DocumentSnapshot, updateImage: Bool) {
        id = document.documentID
        title = ""
        link = ""
        author = ""
        descriptionText = ""
        image_url = ""
        lang = ""
        
        if document["title"] != nil {
            title = document["title"] as! String
        }
        
        if document["link"] != nil {
            link = document["link"] as! String
        }
        
        if document["author"] != nil {
            author = document["author"] as! String
        }
        
        if document["description"] != nil {
            descriptionText = document["description"] as! String
        }
        
        if document["image"] != nil {
            image_url = document["image"] as! String
        }
        
        if document["lang"] != nil {
            lang = document["lang"] as! String
        }
    }
    
    
    func getImage(completion: @escaping (_ result: UIImage) -> Void) {
            if self.image_url != "" {
                let url = URL(string: self.image_url)
                let data = try? Data(contentsOf: url!)
                self.image = UIImage(data: data!)!
                completion(self.image)
            }
    }
    
    func updateImage(urlString: String) {
        
    }
}

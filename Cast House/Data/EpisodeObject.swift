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
    
    var id: String!
    var title: String!
    var link: String!
    var author: String!
    var descriptionText: String?
    var image_url: String?
    var image: UIImage?
    
    func updateInfo(document: DocumentSnapshot, updateImage: Bool) {
        id = document.documentID
        
        // Populate this EpisodeObject with data from document.
        title = document["title"] as! String
        link = document["link"] as! String
        author = document["author"] as! String
        descriptionText = document["description"] as? String
        image_url = document["image"] as? String
    }
    
    
    func getImage(completion: @escaping (_ result: UIImage) -> Void) {
        // Download image from image_url if it exists - when completed, then return the image.
        
        if self.image_url != "" {
            DispatchQueue.global().async {
                let url = URL(string: self.image_url!)
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async(execute: {
                    self.image = UIImage(data: data!)!
                    completion(self.image!)
                })
            }
        }
    }
    
    func updateImage(urlString: String) {
        // TODO: missing function for updating the image...
    }
}

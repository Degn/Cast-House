//
//  ShowObject.swift
//  Cast House
//
//  Created by Simon Degn on 28/11/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import UIKit
import Firebase

class ShowObject: NSObject {
    
    var id = String()
    var title = String()
    var author = String()
    var descriptionText = String()
    var episodesCount = Int()
    var explicit = String() // Yes / No
    var image_url = String()
    var image = UIImage()
    var lang = String()
    
    func updateInfo(document: DocumentSnapshot, updateImage: Bool) {
        id = document.documentID
        title = document["title"] as! String
        author = document["author"] as! String
        descriptionText = document["description"] as! String
        episodesCount = document["episodes_count"] as! Int
        explicit = "\(String(describing: document["explicit"]))" // Yes / No
        image_url = document["image"] as! String
        lang = document["lang"] as! String
    }
    
    
    func getInfoFromRef(ref: DocumentReference, rowIndex: Int, completion: @escaping (_ result: Int) -> Void) {
        ref.getDocument { (document, error) in
            if document != nil {
                self.updateInfo(document: document!, updateImage: true)
                completion(rowIndex)
            }
        }
    }
    
    
    func getImage(completion: @escaping (_ result: UIImage) -> Void) {
        if self.image_url != "" {
            DispatchQueue.global().async {
                let url = URL(string: self.image_url)
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async(execute: {
                    self.image = UIImage(data: data!)!
                    completion(self.image)
                })
            }
        }
    }
    
    
    func updateImage(urlString: String) {
        
    }
}

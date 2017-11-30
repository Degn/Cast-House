//
//  SearchObject.swift
//  Cast House
//
//  Created by Simon Degn on 20/11/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import Foundation

struct SearchObjectShow {
    private let json: [String: AnyObject]
    
    init(json: [String: AnyObject]) {
        self.json = json
    }
    var title: String? { return json["title"] as? String }
    var imageUrlString: String? { return json["image"] as? String }
    
    var title_highlighted: String? {
        return "" // SearchResults.getHighlightResult(json, path: "title")?.value
    }
    
    var summary: String? { return json["summary"] as? String }
    var author: String? { return json["author"] as? String }

}

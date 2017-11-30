//
//  DetailPublisherViewController.swift
//  Cast House
//
//  Created by Simon Degn on 17/11/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import UIKit
import Firebase

class DetailPublisherViewController: UIViewController {
    
    var container: DetailContainerViewController?
    var showTableView = UITableView()
    var showBG = UIView()
    var showSubscribeButton = UIButton()
    var showCoverImageView = UIImageView()
    var showDescriptionLabel = UILabel()
    var showAuthorLabel = UILabel()
    
    override func viewDidLoad() {
        
        // Scrollview
        showTableView.frame = self.view.bounds
        self.view.addSubview(showTableView)
        
        // BG
        showBG.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        showTableView.tableHeaderView = showBG
        
    }
    
    func setDetail(showObject: ShowObject) {
        self.showCoverImageView.image = showObject.image
        self.showAuthorLabel.text = showObject.author
    }
    
    
    @objc private func subscribe(_ sender: UIButton?) {
        print("subscribe!!!")
    }
}


//
//  DetailEpisodeViewController.swift
//  Cast House
//
//  Created by Simon Degn on 19/11/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import UIKit
import Firebase

class DetailEpisodeViewController: UIViewController {
    
    var container: DetailContainerViewController?
    var showTableView = UITableView()
    var showBG = UIView()
    var showCoverImageView = UIImageView()
    var showDescriptionLabel = UILabel()

    
    override func viewDidLoad() {
        
        // Scrollview
        showTableView.frame = self.view.bounds
        self.view.addSubview(showTableView)
        
        // BG
        showBG.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        showTableView.tableHeaderView = showBG
        
        // Cover image view
        showCoverImageView.frame = CGRect(x: self.view.frame.size.width/4, y: 16.0, width: self.view.frame.size.width/2, height: self.view.frame.size.width/2)
        showCoverImageView.layer.cornerRadius = self.view.frame.size.width/4
        showCoverImageView.clipsToBounds = true
        showCoverImageView.contentMode = .scaleAspectFill
        showBG.addSubview(showCoverImageView)
        
        
        // Description label
        showDescriptionLabel.numberOfLines = 0
        showDescriptionLabel.font = UIFont(name: "AsapCondensed-Medium", size: 15.0)
        showDescriptionLabel.textColor = UIColor(red: (160/255.0), green: (160/255.0), blue: (160/255.0), alpha: 1.0)
        
        updateDescriptionLabel(text: "")
        showBG.addSubview(showDescriptionLabel)
        
    }
    
    func setDetail(episodeObject: EpisodeObject) {
        
        self.showCoverImageView.image = episodeObject.image
        updateDescriptionLabel(text: (episodeObject.descriptionText))
    }
    
    
    func updateDescriptionLabel(text: String) {
        showDescriptionLabel.frame = CGRect(x: 16.0, y: self.view.frame.size.width/2 + 48.0, width: self.view.frame.size.width - 48.0, height: 0)
        
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6.0
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        showDescriptionLabel.attributedText = attributedString;
        showDescriptionLabel.sizeToFit()
    }
}


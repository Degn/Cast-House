//
//  SearchResultTableViewCell.swift
//  Cast House
//
//  Created by Simon Degn on 20/11/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import UIKit
import AFNetworking

class SearchResultTableViewCell: UITableViewCell {
    
    var searchResultTitleLabel = UILabel()
    var searchResultImageview = UIImageView()
    var searchResultSummaryLabel = UILabel()
    var searchResultAuthorLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "SearchResultCell")
        
        searchResultImageview.frame = CGRect(x: 20, y: 25, width: 60, height: 60)
        searchResultImageview.backgroundColor = UIColor(red: (249/255.0), green: (249/255.0), blue: (249/255.0), alpha: 1.0)
        searchResultImageview.layer.cornerRadius = 30.0
        searchResultImageview.contentMode = .scaleAspectFill
        searchResultImageview.clipsToBounds = true
        self.addSubview(searchResultImageview)
        
        searchResultTitleLabel.frame = CGRect(x: 100, y: 0, width: self.frame.size.width-80, height: 40)
        searchResultTitleLabel.font = UIFont(name: "AsapCondensed-Medium", size: 18)
        searchResultTitleLabel.textColor = UIColor(red: (17/255.0), green: (17/255.0), blue: (17/255.0), alpha: 1.0)
        self.addSubview(searchResultTitleLabel)
        
        searchResultSummaryLabel.frame = CGRect(x: 100, y: 30, width: self.frame.size.width-80, height: 70)
        searchResultSummaryLabel.font = UIFont(name: "AsapCondensed-Medium", size: 14)
        searchResultSummaryLabel.textColor = UIColor(red: (200/255.0), green: (200/255.0), blue: (200/255.0), alpha: 1.0)
        searchResultSummaryLabel.numberOfLines = 3
        self.addSubview(searchResultSummaryLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//
//  CHFeedCoverItemView.swift
//  Cast House
//
//  Created by Simon Degn on 08/11/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import UIKit

class FeedItemsModuleItem: UICollectionViewCell {

    let coverItemImageView = UIImageView()
    let itemTitleLabel = UILabel()
    let itemAuthorLabel = UILabel()

    var coverItemBoxViewHeight = 0.0
    var coverItemBoxViewWidth = 0.0
    var coverItemsLimit = 0
    var id = String()
    var bgView = UIView()
    
    func buildItem(labelType: String) {
        
        self.bgView.frame = CGRect(x: 0,
                            y: 0,
                            width: coverItemBoxViewWidth,
                            height: coverItemBoxViewHeight)
        self.bgView.backgroundColor = .yellow
        self.addSubview(bgView)
        
        coverItemImageView.frame = CGRect(x: 0.0, y: 0.0, width: Double(self.frame.size.width), height: Double(self.frame.size.width))
        coverItemImageView.clipsToBounds = true
        coverItemImageView.backgroundColor = UIColor.init(red: (240/255.0),
                                                          green: (240/255.0),
                                                          blue: (240/255.0),
                                                          alpha: 1.0)
        coverItemImageView.layer.cornerRadius = 6.0
        coverItemImageView.clipsToBounds = true
        bgView.addSubview(coverItemImageView)
        
        if labelType == "titleAndAuthor" {
            
            itemTitleLabel.font = UIFont(name: "AsapCondensed-Medium", size: 22.0)
            itemTitleLabel.textColor = UIColor(red: (17/255.0), green: (17/255.0), blue: (17/255.0), alpha: 1.0)
            itemTitleLabel.numberOfLines = 1
            itemTitleLabel.frame = CGRect(x: 8.0,
                                      y: Double(self.frame.size.width)+6.0,
                                      width: Double(self.frame.size.width)-8.0,
                                      height: 30.0)
            bgView.addSubview(itemTitleLabel)
            
            itemAuthorLabel.font = UIFont(name: "AsapCondensed-Medium", size: 14.0)
            itemAuthorLabel.textColor = UIColor(red: (180/255.0), green: (180/255.0), blue: (180/255.0), alpha: 1.0)
            itemAuthorLabel.numberOfLines = 1
            itemAuthorLabel.frame = CGRect(x: 8.0,
                                       y: Double(self.frame.size.width) + 28.0,
                                       width: Double(self.frame.size.width)-8.0,
                                       height: 30.0)
            bgView.addSubview(itemAuthorLabel)
            
        } else if labelType == "titleOnly" {
            
            itemTitleLabel.font = UIFont(name: "AsapCondensed-Medium", size: 14.0)
            itemTitleLabel.textColor = UIColor(red: (17/255.0), green: (17/255.0), blue: (17/255.0), alpha: 1.0)
            itemTitleLabel.numberOfLines = 2
            itemTitleLabel.frame = CGRect(x: 0,
                                      y: Double(self.frame.size.width),
                                      width: Double(self.frame.size.width),
                                      height: 36.0)
            bgView.addSubview(itemTitleLabel)
        }
    }
}

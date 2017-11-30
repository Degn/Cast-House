//
//  CHFeedCoverItemsView.swift
//  Cast House
//
//  Created by Simon Degn on 08/11/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import UIKit

class FeedItemsModule: UIView {

    var feedView: FeedViewController?
    let coverItemsBGView = UIView()
    let coverItemsLabel = UILabel()
    var coverItemsScrollView: UICollectionView?

    var coverItemBoxViewHeight = 0.0
    var coverItemBoxViewWidth = 0.0
    var coverItemsLimit = 0
    var padding = 0.0
    
    
    public func build(title: String, showModuleLabel: Bool) {
        
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: coverItemBoxViewWidth-padding*2, height: coverItemBoxViewHeight-padding*2)
        layout.sectionInset = UIEdgeInsets(top: CGFloat(padding), left: CGFloat(padding), bottom: CGFloat(padding), right: CGFloat(padding))
        layout.scrollDirection = .horizontal
        
        coverItemsScrollView = UICollectionView(frame: CGRect(x: 0.0, y: 0.0, width: Double(self.frame.size.width), height: coverItemBoxViewHeight), collectionViewLayout: layout)
        coverItemsScrollView!.delegate = feedView
        coverItemsScrollView!.dataSource = feedView
        coverItemsScrollView!.register(FeedItemsModuleItem.self, forCellWithReuseIdentifier: "FeedItemCell")
        
        coverItemsBGView.clipsToBounds = true
        self.addSubview(coverItemsBGView)
        
        if showModuleLabel {
            coverItemsLabel.frame = CGRect(x: 16.0,
                                           y: 4.0,
                                           width: Double(self.frame.size.width),
                                           height: 32.0)
            coverItemsLabel.textColor = .black // feedView.root.themeColor1
            coverItemsLabel.font = UIFont(name: "AsapCondensed-Medium", size: 18.0)
            coverItemsLabel.text = title
            self.addSubview(coverItemsLabel)
            
            
            coverItemsScrollView?.frame = CGRect(x: 0.0,
                                                y: Double(coverItemsLabel.frame.size.height),
                                                width: Double(self.frame.size.width),
                                                height: Double(coverItemBoxViewHeight))
            
            coverItemsBGView.frame = CGRect(x: 0.0,
                                            y: 0.0,
                                            width: Double(self.frame.size.width),
                                            height: coverItemBoxViewHeight + Double(coverItemsLabel.frame.size.height))

        } else {
            coverItemsScrollView?.frame = CGRect(x: 0.0,
                                                y: 0.0,
                                                width: Double(self.frame.size.width),
                                                height: coverItemBoxViewHeight)
        }
        
        coverItemsScrollView?.clipsToBounds = false
        coverItemsScrollView?.isPagingEnabled = false
        coverItemsScrollView?.backgroundColor = .clear
        coverItemsScrollView?.showsHorizontalScrollIndicator = false
        
        self.addSubview(coverItemsScrollView!)
    }
}

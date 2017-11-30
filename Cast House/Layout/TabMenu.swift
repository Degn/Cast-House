//
//  TabMenu.swift
//  Cast House
//
//  Created by Simon Degn on 24/11/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import UIKit

var selectedTab = [UIButton]()
var blackLabels = [UILabel]()
var whiteLabels = [UILabel]()
var blackLabelViews = [UIView]()
var whiteLabelViews = [UIView]()

class TabMenu: UIView {

    var currentTabIndex = 0
    var tabs = [UIButton]()
    var titles = ["Your podcasts", "Notifications",  "A third one", nil]
    var selectionIndicator = UIView()
    var profileView: ProfileViewController?

    func numberOfTabs(number: Int) {
        selectionIndicator.frame = CGRect(x: 0.0,
                                          y: 4.0,
                                          width: (self.frame.size.width / CGFloat(number)),
                                          height: self.frame.size.height-8.0)
        selectionIndicator.backgroundColor = .black
        selectionIndicator.layer.cornerRadius = 4.0
        selectionIndicator.clipsToBounds = true
        self.addSubview(selectionIndicator)
        

        for i in 1...number {
            let xOffset = ((self.frame.size.width) / CGFloat(number)) * CGFloat(i-1)
            
            
            // Set the black labels
            let blackLabelView = UIView()
            blackLabelView.clipsToBounds = true
            blackLabelView.frame = CGRect(x: xOffset,
                                      y: 0.0,
                                      width: (self.frame.size.width / CGFloat(number)),
                                      height: self.frame.size.height)
            blackLabelViews.append(blackLabelView)
            self.addSubview(blackLabelView)
            
            
            let blackLabel = UILabel()
            blackLabel.text = "\(titles[i-1]!)"
            blackLabel.textAlignment = .center
            blackLabel.font = UIFont(name: "AsapCondensed-Medium", size: 15)
            blackLabel.frame = CGRect(x: 0.0,
                                      y: 0.0,
                                      width: (self.frame.size.width / CGFloat(number)),
                                      height: blackLabelView.frame.size.height)
            blackLabels.append(blackLabel)
            blackLabelView.addSubview(blackLabel)
            
            // Set the white labels
            let whiteLabelView = UIView()
            whiteLabelView.clipsToBounds = true
            whiteLabelView.frame = CGRect(x: xOffset,
                                          y: 0.0,
                                          width: (self.frame.size.width / CGFloat(number)),
                                          height: self.frame.size.height)
            whiteLabelViews.append(whiteLabelView)
            self.addSubview(whiteLabelView)
            
            let whiteLabel = UILabel()
            whiteLabel.text = "\(titles[i-1]!)"
            whiteLabel.textColor = .white
            whiteLabel.textAlignment = .center
            whiteLabel.font = UIFont(name: "AsapCondensed-Medium", size: 15)
            whiteLabel.frame = CGRect(x: 0.0,
                                      y: 0.0,
                                      width: (self.frame.size.width / CGFloat(number)),
                                      height: whiteLabelView.frame.size.height)
            whiteLabels.append(whiteLabel)
            whiteLabelView.addSubview(whiteLabel)
            
            
            // Set the tab button
            let tab = UIButton()
            tab.tag = i
            tab.frame = CGRect(x: xOffset,
                               y: 0,
                               width: (self.frame.size.width / CGFloat(number)),
                               height: self.frame.size.height)
            tab.addTarget(self, action: #selector(tabClick), for: .touchUpInside)
            tabs.append(tab)
            self.addSubview(tab)
        }
    }
    
    
    func moveSelectedIndicator(x: CGFloat, width: CGFloat, animated: Bool) {
        
        // Moving the selected indicator
        var moveX = selectionIndicator.frame.origin.x
        let xTranslated = self.frame.size.width / ((width-32) / x)
        
        if xTranslated <= 0.0 {
            moveX = 0.0
        } else {
            moveX = (xTranslated)/(CGFloat(tabs.count))
        }

        currentTabIndex = Int(((xTranslated) / self.frame.size.width) + 0.5)
        
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.selectionIndicator.frame.origin.x = moveX
            })
        } else {
            selectionIndicator.frame.origin.x = moveX
        }
        
        
        // Moving the selected indicator
        for i in 1...tabs.count {
            let xOffset = ((self.frame.size.width) / CGFloat(tabs.count)) * CGFloat(i-1)
            let whiteLabelView = whiteLabelViews[i-1]
            let whiteLabel = whiteLabels[i-1]
            
            if (xOffset <= self.selectionIndicator.frame.origin.x) {
                if (xOffset + whiteLabelView.frame.size.width >= self.selectionIndicator.frame.origin.x) {
                    
                    whiteLabelView.frame.origin.x = self.selectionIndicator.frame.origin.x
                    whiteLabel.frame.origin.x = -1 * (whiteLabelView.frame.origin.x - (self.frame.size.width / CGFloat(tabs.count)) * CGFloat(i-1))
                } else {
                    whiteLabel.frame.origin.x = self.frame.size.width
                }
            } else {
                whiteLabel.frame.origin.x = self.frame.size.width
            }
            
            let selectionTabRight = (self.selectionIndicator.frame.origin.x + self.selectionIndicator.frame.size.width)
            let tabLeft = ((self.frame.size.width / CGFloat(tabs.count)) * CGFloat(i-1))
            let tabRight = ((self.frame.size.width / CGFloat(tabs.count)) * CGFloat(i-1)) + (self.frame.size.width / CGFloat(tabs.count))

            if selectionTabRight >= tabLeft {
                if selectionTabRight <= tabRight {
                    whiteLabel.frame.origin.x = 0
                    whiteLabelView.frame.size.width = (selectionTabRight - tabLeft)
                }
            }
        }
    }
    
    @objc func tabClick(_ sender: UIButton?) {
        print("click \(sender!.tag)")
        profileView!.scrollToList(listIndex: sender!.tag-1)
    }
}

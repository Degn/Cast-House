//
//  DetailRootViewController.swift
//  Cast House
//
//  Created by Simon Degn on 18/11/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import UIKit

class DetailRootViewController: UIViewController, UITableViewDelegate {

    var root: RootViewController?
    var detailRootScrollView = UIScrollView()
    var detailViews = [DetailContainerViewController]()
    var currentDetailViewIndex = 0
    var maxDetailViewIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Root Scroll View
        detailRootScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        detailRootScrollView.backgroundColor = .clear
        detailRootScrollView.contentSize = CGSize(width: (1 * self.view.frame.size.width), height: self.view.frame.size.height)
        detailRootScrollView.contentOffset = CGPoint(x: 0, y: 0)
        detailRootScrollView.isPagingEnabled = true
        detailRootScrollView.alwaysBounceHorizontal = true
        detailRootScrollView.delegate = self
        detailRootScrollView.showsHorizontalScrollIndicator = false
        detailRootScrollView.clipsToBounds = false
        self.view.addSubview(detailRootScrollView)
        
    }
    
    
    func setDetail(typeOfDetailItem: String, parameter: Any?, animated: Bool) {
        
        maxDetailViewIndex += 1
        currentDetailViewIndex = maxDetailViewIndex

        let container = DetailContainerViewController()
        container.detailRoot = self
        container.view.frame = CGRect(x: 8.0 + (self.view.frame.width * CGFloat(currentDetailViewIndex - 1)), y: 20.0, width: self.view.frame.width-16.0, height: self.view.frame.height-28.0)
        detailRootScrollView.addSubview(container.view)
        self.addChildViewController(container)
        detailViews.append(container)
        
        // FIXME: Do a switch below...
        
        if typeOfDetailItem == "show" {
            container.setShowDetail(showObject: parameter as! ShowObject)
        } else if typeOfDetailItem == "publisher" {
            container.setPublisherDetail(showObject: parameter as! ShowObject)
        } else if typeOfDetailItem == "episode" {
            container.setEpisodeDetail(episodeObject: parameter as! EpisodeObject)
        }
        
        detailRootScrollView.contentSize = CGSize(width: CGFloat(maxDetailViewIndex) * CGFloat(self.view.frame.size.width), height: self.view.frame.size.height)
        
        if (currentDetailViewIndex < 1) {
            currentDetailViewIndex = 1
            // TODO: Hacky but I cannot see why it goes from 1 to 0 in this func...
        }
        
        if animated {
            // Animating in or out
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.detailRootScrollView.contentOffset.x = (self.view.frame.width * CGFloat(self.currentDetailViewIndex-1))
            }, completion: nil)
        } else {
            // Immediately show / hide
            detailRootScrollView.contentOffset.x = (self.view.frame.width * CGFloat(currentDetailViewIndex-1))
        }
    }
    
    
    func goBack() {
        if currentDetailViewIndex > 0 {
            
            currentDetailViewIndex -= 1
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.detailRootScrollView.contentOffset.x = (self.view.frame.width * CGFloat(self.currentDetailViewIndex))
            }, completion: nil)


            maxDetailViewIndex -= 1
            
        } else {
            currentDetailViewIndex = 0
            maxDetailViewIndex = 0
            removeDetailView(at: -1)
            root?.exitDetailMode()
        }
    }
    
    
    func removeDetailView(at: Int) {
        
        print("----- \(maxDetailViewIndex-1) ")
        for dv in detailViews {
            print(dv)
        }
        print("-----")
        
        if at != -1 {
            let dv = detailViews[at]
            dv.view.isHidden = true
            detailRootScrollView.bringSubview(toFront: dv.view)
            dv.view.removeFromSuperview()
            dv.removeFromParentViewController()
            detailViews.remove(at: at)
            
            detailRootScrollView.contentSize = CGSize(width: CGFloat(maxDetailViewIndex) * CGFloat(self.view.frame.size.width), height: self.view.frame.size.height)

        } else {
            for dv in detailViews {
                dv.view.isHidden = true
                detailRootScrollView.bringSubview(toFront: dv.view)
                dv.view.removeFromSuperview()
                dv.removeFromParentViewController()
            }
            
            detailRootScrollView.contentSize = CGSize(width: CGFloat(maxDetailViewIndex) * CGFloat(self.view.frame.size.width), height: self.view.frame.size.height)

            detailViews.removeAll()
        }
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let i = Int((scrollView.contentOffset.x + (0.5 * scrollView.frame.size.width)) / scrollView.frame.size.width)
        currentDetailViewIndex = i
        
        if scrollView.contentOffset.x < 0 {
            print("\(scrollView.contentOffset.x)")
            fadeOutDetailRoot(x: scrollView.contentOffset.x)
        } else {
            root?.detailRootView.view.isUserInteractionEnabled = true
            root?.baseView.isUserInteractionEnabled = false
        }
        
    }

    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if currentDetailViewIndex < maxDetailViewIndex-1 {
            for i in currentDetailViewIndex+1...maxDetailViewIndex-1 {

                maxDetailViewIndex -= 1
                removeDetailView(at: i)
            }
        }
    }
    
    
    func fadeOutDetailRoot(x: CGFloat) {
        let percentageOut = (100 / ((self.view.frame.width / 2) / x)) * -1
        
        if (percentageOut < 100) {
            root?.baseView.layer.cornerRadius = 6.0
            root?.baseView.clipsToBounds = true
            root?.baseView.transform = CGAffineTransform(scaleX: 0.7 + (0.3/100)*percentageOut, y: 0.7 + (0.3/100)*percentageOut)
            root?.detailRootView.view.transform = CGAffineTransform(scaleX: 1.0 - (0.4/100)*percentageOut, y: 1.0 - (0.4/100)*percentageOut)
            root?.baseView.alpha = 1.0 / (100/percentageOut)
            root?.detailRootView.view.alpha = 1.0 - 1.0 / (100/percentageOut)
            root?.detailRootView.view.isUserInteractionEnabled = false
            root?.baseView.isUserInteractionEnabled = true
            
            if (percentageOut > 60) {
                detailRootScrollView.setContentOffset(detailRootScrollView.contentOffset, animated: false)
                currentDetailViewIndex = 0
                maxDetailViewIndex = 0
                removeDetailView(at: -1)
                root?.exitDetailMode()
                print("i'm out!")
                detailRootScrollView.isScrollEnabled = false
                detailRootScrollView.isScrollEnabled = true

            }
        }
    }
}

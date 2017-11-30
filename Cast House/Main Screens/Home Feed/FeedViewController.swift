//
//  FeedViewController.swift
//  Cast House
//
//  Created by Simon Degn on 12/10/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let scrollView = UIScrollView()
    let padding = 16.0
    var root: RootViewController?
    var allModuleItems = [Int: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        scrollView.frame = self.view.bounds
        scrollView.contentSize = CGSize(width: self.view.frame.width,
                                        height: self.view.frame.height*2)
        self.view.addSubview(scrollView)
        
        setItemModule(moduleId: 1, labelType: "titleAndAuthor", coverItemsLimit: 5,
                      coverItemBoxViewWidth: Double(Int(self.view.frame.size.width * 2.5/3.0)),
                      coverItemBoxViewHeight: Double(Int(self.view.frame.size.width * 2.5/3.0)),
                      yPosition: 0.0,
                      title: "")
        
        setItemModule(moduleId: 2, labelType: "titleOnly", coverItemsLimit: 10,
                      coverItemBoxViewWidth: Double(Int(self.view.frame.size.width * 1.0/3.0)),
                      coverItemBoxViewHeight: Double(Int(self.view.frame.size.width * 1.0/3.0)),
                      yPosition: Double(Int(self.view.frame.size.width * 2.5/3.0)) + 75.0,
                      title: "Trending right now")
        
        setItemModule(moduleId: 3, labelType: "titleOnly", coverItemsLimit: 10,
                      coverItemBoxViewWidth: Double(Int(self.view.frame.size.width * 1.0/3.0)),
                      coverItemBoxViewHeight: Double(Int(self.view.frame.size.width * 1.0/3.0)),
                      yPosition: Double(Int(self.view.frame.size.width * 3.5/3.0)) + 90.0 * 1 + 75,
                      title: "Natural History")
    }
    
    func setItemModule(moduleId: Int, labelType: String, coverItemsLimit: Int, coverItemBoxViewWidth: Double, coverItemBoxViewHeight: Double, yPosition: Double, title: String) {
        
        let coverItemsModule = FeedItemsModule()
        coverItemsModule.feedView = self
        coverItemsModule.frame = CGRect(x: 0.0,
                                        y: yPosition,
                                        width: Double(self.view.frame.size.width),
                                        height: coverItemBoxViewHeight)
        coverItemsModule.coverItemBoxViewHeight = coverItemBoxViewHeight
        coverItemsModule.coverItemBoxViewWidth = coverItemBoxViewWidth
        coverItemsModule.padding = padding
        coverItemsModule.coverItemsLimit = coverItemsLimit
        
        
        if moduleId == 1 {
            let db = Firestore.firestore()
            db.collection("shows")
                .whereField("lang", isEqualTo: "da")
                .limit(to: coverItemsLimit).getDocuments() { (querySnapshot, err) in
                    
                    self.allModuleItems[moduleId] = self.convertSnapshotToModuleItems(querySnapshot: querySnapshot!)
                    coverItemsModule.build(title: title, showModuleLabel: false)
                    coverItemsModule.coverItemsScrollView?.tag = moduleId
            }
            scrollView.addSubview(coverItemsModule)
        } else if moduleId == 2 {
            let db = Firestore.firestore()
            db.collection("shows")
                .whereField("lang", isEqualTo: "fr")
                .limit(to: coverItemsLimit).getDocuments() { (querySnapshot, err) in
                    
                    self.allModuleItems[moduleId] = self.convertSnapshotToModuleItems(querySnapshot: querySnapshot!)
                    coverItemsModule.build(title: title, showModuleLabel: true)
                    coverItemsModule.coverItemsScrollView?.tag = moduleId
            }
            scrollView.addSubview(coverItemsModule)
            
        } else if moduleId == 3 {
            let db = Firestore.firestore()
            db.collection("shows")
                .whereField("lang", isEqualTo: "en")
                .limit(to: coverItemsLimit).getDocuments() { (querySnapshot, err) in
                    
                    self.allModuleItems[moduleId] = self.convertSnapshotToModuleItems(querySnapshot: querySnapshot!)
                    coverItemsModule.build(title: title, showModuleLabel: true)
                    coverItemsModule.coverItemsScrollView?.tag = moduleId
            }
            scrollView.addSubview(coverItemsModule)
            
        }
    }
    
    
    func convertSnapshotToModuleItems(querySnapshot: QuerySnapshot) -> [Int: Any] {
        
        var currentIndex = 0
        var tmpModuleItems = [Int: Any]()
        
        for document in querySnapshot.documents {
            
            let itemObject = ShowObject()
            itemObject.updateInfo(document: document, updateImage: true)
            tmpModuleItems[currentIndex] = itemObject
            
            currentIndex += 1
        }
        
        return tmpModuleItems
    }
    
    
    func getShowImage(urlString: String, moduleIndex: Int, itemIndex: Int, completion: @escaping ([String: Any]) -> ())  {
        DispatchQueue.global().async {
            let url = URL(string: urlString)
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async(execute: {
                if data != nil {
                    var obj = [String: Any]()
                    obj["image"] = UIImage(data: data!)!
                    obj["moduleIndex"] = moduleIndex
                    obj["itemIndex"] = itemIndex
                    completion(obj)
                }
            })
        }
    }
    
    @objc private func itemSelected(_ sender: UIButton?) {
        
        let moduleId = (sender?.tag)! / 1000
        let itemId = (sender?.tag)! % 1000
        
        let moduleObject: [Int: Any] = allModuleItems[moduleId] as! [Int : Any]
        let itemObject = moduleObject[itemId]
        
        print("item \(itemId) in module \(moduleId)")
        
        if itemObject != nil {
            root?.enterDetailMode(typeOfDetailItem: "show", parameter: itemObject)
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let moduleId = collectionView.tag
        let itemId = indexPath.row
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedItemCell",
                                                      for: indexPath) as! FeedItemsModuleItem
        
        cell.buildItem(labelType: "titleAndAuthor")
        
        let items = allModuleItems[moduleId] as! [Int: ShowObject]
        let itemShowObject = items[itemId]!
        let image = itemShowObject.image
        
        cell.itemTitleLabel.text = itemShowObject.title
        cell.itemAuthorLabel.text = itemShowObject.author
        
        cell.coverItemImageView.cancelImageDownloadTask()
        
        if image == nil {
            // cell.coverItemImageView.setImageWith(NSURL(string: doc["image"]! as! String)! as URL)
        } else {
            cell.coverItemImageView.image = image
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let items = allModuleItems[collectionView.tag] as! [Int: Any]
        return items.count
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let collectionView = scrollView as! UICollectionView
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellSize = flowLayout.itemSize.width
        
        targetContentOffset.pointee = scrollView.contentOffset
        var factor: CGFloat = 0.8
        if velocity.x < 0 {
            factor = -factor
        }
        
        let row = (Int(scrollView.contentOffset.x / CGFloat(cellSize) + factor)) > 0 ? Int(scrollView.contentOffset.x / CGFloat(cellSize) + factor) : 0
        
        let indexPath = IndexPath(row: row, section: 0)
        
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        
        // TODO: make a smoother animation - calculate a offset animation instead of the 'scrollToItem' from the velocity of the function.... Math is king here
        // Also the indexPath is calculated above but there is no max, so it will eventually go out of bounds..
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let moduleId = collectionView.tag
        let itemId = indexPath.row
        
        var items = allModuleItems[moduleId] as! [Int: Any] // The dictionary of all modules
        let showObject = items[itemId] as! ShowObject

        var image = showObject.image
        
        /*
        if image == nil {
            // Find image from cell..
            let cell = collectionView.cellForItem(at: indexPath) as! FeedItemsModuleItem
            image = cell.coverItemImageView.image
            showObject["image"] = image
            
            // Set found image into the items dictionary
            items[itemId] = showObject
            allModuleItems[moduleId] = items
        }
        */
        
        root!.enterDetailMode(typeOfDetailItem: "show", parameter: showObject)
        
    }
}


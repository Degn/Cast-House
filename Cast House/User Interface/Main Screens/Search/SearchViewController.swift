//
//  SearchViewController.swift
//  Cast House
//
//  Created by Simon Degn on 12/10/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import UIKit
import AlgoliaSearch
import AFNetworking

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var root: RootViewController?

    let query = Query()
    var searchResults = [SearchObjectShow]()
    var searchResultObjects = [Int: Any]()
    let searchResultTableView = UITableView()
    let searchDefaultView = UIScrollView()

    var searchId = 0
    var displayedSearchId = -1
    var loadedPage: UInt = 0
    var nbPages: UInt = 0
    var index: Index!
    var categories = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: (249/255.0), green: (249/255.0), blue: (249/255.0), alpha: 1.0)
        
        searchResultTableView.frame = self.view.frame
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self
        searchResultTableView.tableFooterView = UIView()
        searchResultTableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "SearchResultCell")
        searchResultTableView.separatorColor = UIColor(red: (230/255.0), green: (230/255.0), blue: (230/255.0), alpha: 1.0)
        searchResultTableView.separatorStyle = .singleLine
        searchResultTableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        self.view.addSubview(searchResultTableView)
        
        categories = ["Arts", "Business", "Comedy", "Education", "Games & Hobbies", "Government & Organizations", "Health", "Music", "News & Politics", "Religion & Spirituality", "Science & Medicine", "Society & Culture", "Sports & Recreation", "Technology"]
        searchDefaultView.frame = self.view.frame
        searchDefaultView.backgroundColor = .white
        searchDefaultView.isUserInteractionEnabled = false
        searchDefaultView.alpha = 0.0
        searchDefaultView.delegate = self
        
        var i = 0
        var height:CGFloat = 0.0
        for cat in categories {
            let categoryButton = UIButton()
            categoryButton.setTitle(cat, for: .normal)
            categoryButton.frame = CGRect(x: CGFloat(2*padding),
                                          y: CGFloat(4*padding)+CGFloat(36.0 * CGFloat(i)),
                                          width: (14.0 * CGFloat(cat.count)),
                                          height: 36.0)
            categoryButton.titleLabel?.font = UIFont(name: "AsapCondensed-Medium", size: 22)
            categoryButton.setTitleColor(UIColor.black, for: .normal)
            categoryButton.contentHorizontalAlignment = .left;
            categoryButton.tag = i
            categoryButton.addTarget(self, action: #selector(categoryButtonClick), for: .touchUpInside)
            searchDefaultView.addSubview(categoryButton)
            i += 1
        }
        height = (CGFloat(CGFloat(8*padding)+CGFloat(36.0 * CGFloat(i))) > searchDefaultView.frame.height) ?  CGFloat(CGFloat(8*padding)+CGFloat(36.0 * CGFloat(i))) : searchDefaultView.frame.height + 1.0

        searchDefaultView.contentSize = CGSize(width: searchDefaultView.contentSize.width, height: height)
        
        self.view.addSubview(searchDefaultView)

        let client = Client(appID: "Z57TUL1XZJ", apiKey: "c8d820498f6f59be8b584e9a340e8434")
        
        index = client.index(withName: "cast_house_shows")
        query.hitsPerPage = 15
        query.attributesToRetrieve = ["title", "image", "summary", "author"]
        query.attributesToHighlight = ["title"]
        
        updateSearchResults(searchText: "")
    }

    
    func updateSearchResults(searchText: String) {
        
        if searchText == "" {
            if searchResultTableView.isUserInteractionEnabled {
                searchDefaultView.isUserInteractionEnabled = true
                searchResultTableView.isUserInteractionEnabled = false
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.searchDefaultView.alpha = 1.0
                    self.searchResultTableView.alpha = 0.0
                })
            }
        } else {
            if searchDefaultView.isUserInteractionEnabled {
                searchDefaultView.isUserInteractionEnabled = false
                searchResultTableView.isUserInteractionEnabled = true
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.searchDefaultView.alpha = 0.0
                    self.searchResultTableView.alpha = 1.0
                })
            }
            
            query.query = searchText
            
            let curSearchId = searchId
            index.search(query) { (data, error) in
                if (curSearchId <= self.displayedSearchId) || (error != nil) {
                    return // Newest query already displayed or error
                }
                self.displayedSearchId = curSearchId
                self.loadedPage = 0 // Reset loaded page
                
                // Decode JSON
                guard let hits = data!["hits"] as? [[String: AnyObject]] else { return }
                guard let nbPages = data!["nbPages"] as? UInt else { return }
                self.nbPages = nbPages
                var tmp = [SearchObjectShow]()
                for hit in hits {
                    tmp.append(SearchObjectShow(json: hit))
                }
                // Reload view with the new data
                self.searchResults = tmp
                self.searchResultTableView.reloadData()
                
                // Go to top again..
                if self.searchResultTableView.numberOfRows(inSection: 0) != 0 {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.searchResultTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
            
            self.searchId += 1
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 110.0;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath as IndexPath) as! SearchResultTableViewCell

        let result = searchResults[indexPath.row]
        if result.title != nil {
            self.searchResultObjects[indexPath.row] = result.title!.slugify
            
            cell.selectionStyle = .none
            cell.searchResultTitleLabel.text = result.title
            cell.searchResultSummaryLabel.text = result.summary
            
            cell.searchResultImageview.image = nil
            cell.tag = indexPath.row
            
            cell.searchResultImageview.cancelImageDownloadTask()
            if result.imageUrlString != nil {
                cell.searchResultImageview.setImageWith(NSURL(string: result.imageUrlString!)! as URL)
            }
        }
        
        if (indexPath.row + 5) >= searchResults.count {
            loadMore()
        }
        return cell
    }
    
    
    func loadMore() {
        if loadedPage + 1 >= nbPages {
            return // All pages already loaded
        }
        
        let nextQuery = Query(copy: query)
        nextQuery.page = loadedPage + 1
        index.search(nextQuery) { (data, error) in
            if (nextQuery.query != self.query.query) || (error != nil) {
                return // Query has changed
            }
            self.loadedPage = nextQuery.page!
            
            // Decode JSON
            guard let hits = data!["hits"] as? [[String: AnyObject]] else { return }
            var tmp = [SearchObjectShow]()
            for hit in hits {
                tmp.append(SearchObjectShow(json: hit))
            }
            
            // Display the new loaded page
            self.searchResults.append(contentsOf: tmp)
            self.searchResultTableView.reloadData()
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        root!.menu.topMenuSearchView.topMenuSearchBar.resignFirstResponder()
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.searchResultObjects[indexPath.row] != nil {
            print((self.searchResultObjects[indexPath.row] as Any))
            let key = (self.searchResultObjects[indexPath.row] as! String)
        
            
            let cell = tableView.cellForRow(at: indexPath) as! SearchResultTableViewCell
            
            var image = UIImage()
            if cell.searchResultImageview.image != nil {
                image = cell.searchResultImageview.image!
            }
            
            
            let showObject = ShowObject()
            showObject.id = key
            showObject.image = image
            
            root!.enterDetailMode(typeOfDetailItem: "show", parameter: showObject)
        }
    }
    
    @objc func categoryButtonClick(sender: UIButton?) {
        updateSearchResults(searchText: categories[sender!.tag])
        root!.menu.topMenuSearchView.topMenuSearchBar.text = categories[sender!.tag]
    }
}

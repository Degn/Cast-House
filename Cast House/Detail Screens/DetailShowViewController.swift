//
//  DetailShowViewController.swift
//  Cast House
//
//  Created by Simon Degn on 16/11/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import UIKit
import Firebase
import AFNetworking

var showTableView = UITableView()
let maxEpisodesRound = 20
var currentPage = 0
var lastDoc: DocumentSnapshot?

class DetailShowViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var container: DetailContainerViewController?
    var showBG = UIView()
    var showBGLower = UIView()
    var showBGLowerFade = UIView()
    var showBGLowerSolid = UIView()
    var showSubscribeButton = UIButton()
    var showReadMoreButton = UIButton()
    var showCoverImageView = UIImageView()
    var showDescriptionLabel = UILabel()
    var showEpisodesLabel = UILabel()
    var showAuthorLabel = UILabel()
    var showEpisodesCountLabel = UILabel()
    var showEpisodesTitleLabel = UILabel()
    var showSubscribersCountLabel = UILabel()
    var showSubscribersTitleLabel = UILabel()
    var showLanguageLabel = UILabel()
    var showLanguageTitleLabel = UILabel()
    var showLastUpdateLabel = UILabel()
    var showLastUpdateTitleLabel = UILabel()
    var showExplicitLabel = UILabel()
    var showExplicitTitleLabel = UILabel()
    var showCategoryLabel = UILabel()
    var showCategoryTitleLabel = UILabel()
    var showAuthorButton = UIButton()
    var episodesArray = [EpisodeObject]()
    var showDescriptionHeight = 0.0
    let gl = CAGradientLayer()
    let refreshControl = UIRefreshControl()
    var key = String()
    
    var authorName = String()
    
    override func viewDidLoad() {
        
        // Table view
        showTableView.frame = CGRect(x: 0, y: 0, width: (container?.view.frame.size.width)!, height: (container?.view.frame.size.height)!-50)
        showTableView.delegate = self
        showTableView.dataSource = self
        showTableView.tag = 78
        showTableView.showsVerticalScrollIndicator = false
        showTableView.register(DetailShowEpisodeViewCell.self, forCellReuseIdentifier: "EpisodeCell")
        
        showTableView.separatorColor = UIColor(red: (230/255.0), green: (230/255.0), blue: (230/255.0), alpha: 1.0)
        showTableView.separatorStyle = .singleLine
        showTableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Loading")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        showTableView.refreshControl = refreshControl
        self.view.addSubview(showTableView)
        
        // BG
        showBG.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        showBG.clipsToBounds = true
        showTableView.tableHeaderView = showBG
        
        // Cover image view
        showCoverImageView.frame = CGRect(x: 16.0, y: 0.0, width: self.view.frame.size.width - 48.0, height: self.view.frame.size.width - 48.0)
        showCoverImageView.layer.cornerRadius = 6.0
        showCoverImageView.clipsToBounds = true
        showCoverImageView.contentMode = .scaleAspectFill
        showBG.addSubview(showCoverImageView)
        
        // Author
        showAuthorLabel.frame = CGRect(x: 16.0, y: self.view.frame.size.width - 40.0, width: self.view.frame.size.width - 166.0, height: 46.0)
        showAuthorLabel.font = UIFont(name: "AsapCondensed-Medium", size: 18.0)
        showAuthorLabel.numberOfLines = 2
        showAuthorLabel.textColor = UIColor(red: (17/255.0), green: (17/255.0), blue: (17/255.0), alpha: 1.0)
        showBG.addSubview(showAuthorLabel)
        
        // Author button
        showAuthorButton.frame = CGRect(x: 16.0, y: self.view.frame.size.width - 40.0, width: self.view.frame.size.width - 166.0, height: 46.0)
        showAuthorButton.backgroundColor = .clear
        showAuthorButton.addTarget(self, action: #selector(authorButtonClick(_:)), for: .touchUpInside)
        showBG.addSubview(showAuthorButton)
        
        // Subscribe button
        showSubscribeButton.frame = CGRect(x: self.view.frame.size.width - 132.0, y: self.view.frame.size.width - 35.0, width: 100, height: 36)
        showSubscribeButton.titleLabel?.font = UIFont(name: "AsapCondensed-Medium", size: 16.0)
        showSubscribeButton.setTitleColor(.white, for: .normal)
        showSubscribeButton.setTitle("Subscribe", for: .normal)
        showSubscribeButton.backgroundColor = UIColor.init(red: 17/255.0, green: 17/255.0, blue: 17/255.0, alpha: 1.0)
        showSubscribeButton.addTarget(self, action: #selector(subscribe(_:)), for: .touchUpInside)
        showBG.addSubview(showSubscribeButton)
        
        // Description label
        showDescriptionLabel.numberOfLines = 0
        showDescriptionLabel.font = UIFont(name: "AsapCondensed-Medium", size: 15.0)
        showDescriptionLabel.textColor = UIColor(red: (160/255.0), green: (160/255.0), blue: (160/255.0), alpha: 1.0)

        updateDescriptionLabel(text: "")
        showBG.addSubview(showDescriptionLabel)
        
        // BG LOWER - Lower part of the header (beneath the description)
        showBGLower.frame = CGRect(x: 16.0,
                                   y: showDescriptionLabel.frame.size.height + showDescriptionLabel.frame.origin.y + 16.0,
                                   width: self.view.frame.size.width - 48.0,
                                   height: 95.0)
        showBG.addSubview(showBGLower)
        
        showBG.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: showBGLower.frame.origin.y + showBGLower.frame.size.height)
        
        showBGLowerFade.frame = CGRect(x: 0,
                                       y: 0,
                                       width: showBGLower.frame.size.width,
                                       height: 35)
        
        showBGLowerFade.layer.bounds = showBGLowerFade.frame;
        
        gl.colors = [UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0).cgColor, UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor]
        gl.startPoint = CGPoint(x: 0.5, y: 0.0)
        gl.endPoint = CGPoint(x: 0.5, y: 1.0)
        gl.frame = showBGLowerFade.frame
        showBGLowerFade.layer.addSublayer(gl)
        showBGLowerFade.layer.masksToBounds = true;
        
        showBGLower.addSubview(showBGLowerFade)
        
        showBGLowerSolid.frame = CGRect(x: 0,
                                        y: showBGLowerFade.frame.size.height,
                                        width: showBGLower.frame.size.width,
                                        height: showBGLower.frame.size.height - showBGLowerFade.frame.size.height)
        showBGLowerSolid.backgroundColor = .white
        showBGLower.addSubview(showBGLowerSolid)
        
        // Read more label
        showReadMoreButton.frame = CGRect(x: 0.0, y: showDescriptionLabel.frame.origin.y + 35, width: showBGLower.frame.size.width, height: 50)
        showReadMoreButton.titleLabel?.font = UIFont(name: "AsapCondensed-Medium", size: 15.0)
        showReadMoreButton.setTitleColor(UIColor.init(red: 17/255.0, green: 17/255.0, blue: 17/255.0, alpha: 1.0), for: .normal)
        showReadMoreButton.setTitle("More Info", for: .normal)
        showReadMoreButton.addTarget(self, action: #selector(readMore(_:)), for: .touchUpInside)
        showBG.addSubview(showReadMoreButton)
        
        
        
        // OBS: Episodes label - static thing!!!!!
        showEpisodesLabel.font = UIFont(name: "AsapCondensed-Medium", size: 18.0)
        showEpisodesLabel.text = "Episodes:"
        showEpisodesLabel.textColor = UIColor(red: (17/255.0), green: (17/255.0), blue: (17/255.0), alpha: 1.0)
        showEpisodesLabel.frame = CGRect(x: 0,
                                         y: 65,
                                         width: showBGLower.frame.size.width,
                                         height: 30)
        showBGLower.addSubview(showEpisodesLabel)
        
    }
    
    
    func addInfoItem(position: Int, title: String, description: String) {
        
        let titleLabel = UILabel()
        let descriptionLabel = UILabel()
        let yOffset = (showDescriptionLabel.frame.height + showDescriptionLabel.frame.origin.y) + 20

        // Title label
        titleLabel.font = UIFont(name: "AsapCondensed-Medium", size: 20.0)
        titleLabel.text = "32"
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(red: (160/255.0), green: (160/255.0), blue: (160/255.0), alpha: 1.0)
        titleLabel.frame = CGRect(x: CGFloat(position-1) * (showBG.frame.size.width/3), y: yOffset , width: (showBG.frame.size.width/3), height: 25)
        showBG.addSubview(titleLabel)
        
        // Description label
        descriptionLabel.font = UIFont(name: "AsapCondensed-Medium", size: 13.0)
        descriptionLabel.text = "Episodes"
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = UIColor(red: (200/255.0), green: (200/255.0), blue: (200/255.0), alpha: 1.0)
        descriptionLabel.frame = CGRect(x: CGFloat(position-1) * (showBG.frame.size.width/3), y: yOffset + 25, width: (showBG.frame.size.width/3), height: 25)
        showBG.addSubview(descriptionLabel)
        
    }
    
    
    func setDetailFromShowObject(showObject: ShowObject) {
        
        authorName = showObject.author
        if (showObject.image != nil) {
            self.showCoverImageView.image = showObject.image
        }
        
        self.showAuthorLabel.text = showObject.author
        
        showEpisodesCountLabel.text = "\(showObject.episodesCount)"
        
        updateDescriptionLabel(text: showObject.descriptionText)
        currentPage = 0
        populateEpisodes(key: showObject.id, offsetDoc: nil)
    }
    
    /*
    func setDetailFromDictionary(showObject: ShowObject) {
        
        let doc = dictionary["document"] as! [String: Any]
        authorName = doc["author"] as! String
        if (dictionary["image"] != nil) {
            let img = dictionary["image"] as! UIImage
            self.showCoverImageView.image = img
        }
        self.showAuthorLabel.text = doc["author"] as? String
        
        if doc["episodes_count"] != nil {
            showEpisodesCountLabel.text = "\(String(describing: doc["episodes_count"]!))"
        }
        
        updateDescriptionLabel(text: (doc["description"] as? String)!)
        key = dictionary["key"] as! String  // doc.documentID
        currentPage = 0
        populateEpisodes(key: key, offsetDoc: nil)
    }
    */
    
    
    func populateEpisodes(key: String, offsetDoc: DocumentSnapshot?) {
        
        if offsetDoc == nil {
            episodesArray.removeAll()
            let db = Firestore.firestore()
            db.collection("episodes/\(key)/show_episodes")
                .order(by: "pub_date", descending: true)
                .limit(to: maxEpisodesRound).getDocuments() { (querySnapshot, err) in
                    var tmpLastDoc: DocumentSnapshot?
                    
                    for document in querySnapshot!.documents {
                        var episodeObject = EpisodeObject()
                        episodeObject.updateInfo(document: document, updateImage: true)
                        self.episodesArray.append(episodeObject)
                        tmpLastDoc = document
                    }
                    
                    lastDoc = tmpLastDoc

                    currentPage += 1
                    
                    showTableView.reloadData()
                    showTableView.refreshControl?.endRefreshing()
            }
        } else {
            let db = Firestore.firestore()
            db.collection("episodes/\(key)/show_episodes")
                .order(by: "pub_date", descending: true)
                .start(atDocument: offsetDoc!)
                .limit(to: maxEpisodesRound).getDocuments() { (querySnapshot, err) in
                    var tmpLastDoc: DocumentSnapshot?
                    
                    for document in querySnapshot!.documents {
                        var episodeObject = EpisodeObject()
                        episodeObject.updateInfo(document: document, updateImage: true)
                        self.episodesArray.append(episodeObject)
                        tmpLastDoc = document
                    }
                    
                    lastDoc = tmpLastDoc
                    
                    currentPage += 1
                    
                    showTableView.reloadData()
                    showTableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    
    @objc func refresh(refreshControl: UIRefreshControl) {
        populateEpisodes(key: key, offsetDoc: nil)
        print("bump")
    }
    
    
    func updateDescriptionLabel(text: String) {
        showDescriptionLabel.frame = CGRect(x: 16.0, y: self.view.frame.size.width + 28.0, width: self.view.frame.size.width - 48.0, height: 0)
        
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6.0
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        showDescriptionLabel.attributedText = attributedString;
        showDescriptionLabel.sizeToFit()
        
        // Place episodes
        showDescriptionHeight = Double(CGFloat(showDescriptionLabel.frame.size.height))
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let episodeObject: EpisodeObject = episodesArray[indexPath.row]
        
        let image: UIImage = showCoverImageView.image!
        
        if episodeObject.image != nil {
            // image = episodeObject.image as! UIImage
        }
        
        let detailRoot: DetailRootViewController = container!.detailRoot!
        detailRoot.setDetail(typeOfDetailItem: "episode", parameter: episodeObject, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodesArray.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 110.0;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath as IndexPath) as! DetailShowEpisodeViewCell
        cell.selectionStyle = .none
        
        cell.episodePlayButton.tag = indexPath.row
        cell.episodePlayButton.addTarget(self, action: #selector(playButtonClick), for: .touchUpInside)
        
        if episodesArray.count <= indexPath.row {
            return cell
        }
        
        var episodeObject = episodesArray[indexPath.row] as! EpisodeObject
        if episodesArray.count > indexPath.row {
            
            if episodeObject.title != nil {
                cell.episodeTitleLabel.text = episodeObject.title
            }
            
            if episodeObject.descriptionText != nil {
                let attributedString = NSMutableAttributedString(string: episodeObject.descriptionText)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 5.0
                attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
                cell.episodeDescriptionLabel.attributedText = attributedString;
            }
            
            if (episodeObject.image == nil) {
                if (episodeObject.image_url != nil) {
                    let url = URL(string: episodeObject.image_url)
                    if (episodeObject.image_url != "") {
                       
                        cell.episodeImageview.cancelImageDownloadTask()
                        if url != nil {
                            cell.episodeImageview.setImageWith(url!)
                            episodeObject.image = cell.episodeImageview.image!
                            showTableView.reloadRows(at: [indexPath], with: .none)
                        }
                        
                    } else {
                        // The is an empty image in the doc
                        cell.episodeImageview.image = self.showCoverImageView.image
                        var obj = self.episodesArray[indexPath.row]
                        obj.image = cell.episodeImageview.image!
                    }
                } else {
                    // There is no image in the doc
                    cell.episodeImageview.image = self.showCoverImageView.image
                    var obj = self.episodesArray[indexPath.row]
                    obj.image = cell.episodeImageview.image!
                }
            } else {
                // The image is already loaded and saved in the object
                let originalImage: UIImage = episodeObject.image
                cell.episodeImageview.image = originalImage
            }
        }
        
        // Check if it's time to load a page more..
        if indexPath.row == currentPage*maxEpisodesRound - 1 {
            // it's the last known row
            print("load more")
            populateEpisodes(key: key, offsetDoc: lastDoc!)
        }
        
        return cell
    }
    
    
    @objc private func subscribe(_ sender: UIButton?) {
        print("subscribe!!!")
    }
    
    
    @objc private func readMore(_ sender: UIButton?) {
        UIView.animate(withDuration: 0.3) {
            self.gl.colors = [UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0).cgColor, UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0).cgColor]
            self.showBGLowerSolid.backgroundColor = .clear
            self.showReadMoreButton.alpha = 0.0
            self.showBGLower.frame.origin.y = (self.showDescriptionLabel.frame.height + self.showDescriptionLabel.frame.origin.y) + 50
            self.showBG.frame.size.height = self.showBGLower.frame.origin.y + self.showBGLower.frame.size.height
            showTableView.tableHeaderView = self.showBG
        }
        
        addInfoItem(position: 1, title: "hahah", description: "lillemand")
        addInfoItem(position: 2, title: "hahah2", description: "lillemand2")
        addInfoItem(position: 3, title: "hahah2", description: "lillemand2")

    }
    
    
    @objc private func playButtonClick(_ sender: UIButton?) {
        if episodesArray.count > (sender?.tag)! {
            let image: UIImage = showCoverImageView.image!
            
            // TODO: Atm, it's only passing the cover image and not the episode image to the player...
            
            var episodeObject = episodesArray[(sender?.tag)!]
            episodeObject.image = image
            container?.detailRoot?.root?.openPlayer(episodeObject: episodeObject)
        }
    }
    
    
    @objc private func authorButtonClick(_ sender: UIButton?) {
        let detailRoot: DetailRootViewController = container!.detailRoot!
        let p: [String: Any] = ["document": ["title": authorName]]
        detailRoot.setDetail(typeOfDetailItem: "publisher", parameter: p, animated: true)
    }
}




//
//  ProfileViewController.swift
//  Cast House
//
//  Created by Simon Degn on 12/10/2017.
//  Copyright © 2017 Simon Degn. All rights reserved.
//

import UIKit
import Firebase

let padding = 16.0
let tabMenu = TabMenu()
let listsViewContainer = UIScrollView()
let profileImageView = UIImageView()
var profileImageCircleChart = CAShapeLayer()
var viewPanGesture  = UIPanGestureRecognizer()
var listViewPanGesture  = UIPanGestureRecognizer()
var a = CGFloat(0)
var subscripedPodcasts = [ShowObject]()
var notifications = [NotificationObject]()

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var root: RootViewController?

    var subscriptionsTableView = UITableView()
    var notificationsTableView = UITableView()

    let currentUser = CurrentUser()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: (249/255.0), green: (249/255.0), blue: (249/255.0), alpha: 1.0)
    
        viewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(viewDragged))
        self.view.addGestureRecognizer(viewPanGesture)
        
        listViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(listDragged))
        listsViewContainer.addGestureRecognizer(listViewPanGesture)

        // Profile view
        let profileContentBox = ContentBox()
        profileContentBox.frame = CGRect(x: padding, y: padding, width: Double(self.view.frame.size.width)-padding*2, height: 88.0 + padding*2)
        profileContentBox.backgroundColor = .white
        self.view.addSubview(profileContentBox)
        
        // Colored circle BG
        let profileImageColorBG = UIView()
        profileImageColorBG.frame = CGRect(x: 0, y: 0, width: 94.0, height: 94.0)
        profileImageColorBG.layer.cornerRadius = 47
        profileImageColorBG.clipsToBounds = true
        profileImageColorBG.layer.bounds = profileImageColorBG.frame;
        
        // Colored circle
        let gl = CAGradientLayer()
        gl.colors = [UIColor.themeColor1.cgColor, UIColor.themeColor2.cgColor]
        gl.startPoint = CGPoint(x: 0.5, y: 1.0)
        gl.endPoint = CGPoint(x: 1.0, y: 0.5)
        gl.frame = profileImageColorBG.frame
        profileImageColorBG.layer.addSublayer(gl)
        profileImageColorBG.layer.masksToBounds = true;
        profileContentBox.addSubview(profileImageColorBG)
        
        // Profile Image View
        profileImageView.frame = CGRect(x: padding, y: padding, width: 88.0, height: 88.0)
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = UIColor.init(red: (249/255.0), green: (249/255.0), blue: (249/255.0), alpha: 1.0)
        profileImageView.layer.borderWidth = 3.0
        profileImageView.layer.borderColor = UIColor.white.cgColor
        
    NotificationCenter.default.addObserver(forName:Notification.Name(rawValue:"CurrentUserDataUpdated"),
                       object:nil, queue:nil) {
                        notification in
                        profileImageView.image = CurrentUserData.profileImage
        }
        
        profileContentBox.addSubview(profileImageView)
        profileImageColorBG.center = profileImageView.center
        
        // White (inverted) circle
        let path = CGMutablePath()
        let centerPoint = profileImageView.center
        path.addArc(center: centerPoint, radius: 45.0, startAngle: CGFloat(Double.pi) * 1.5, endAngle: CGFloat(Double.pi) * 0.8, clockwise: true)
        profileImageCircleChart.path = path
        profileImageCircleChart.strokeColor = UIColor.white.cgColor
        profileImageCircleChart.lineWidth = 5.0
        profileImageCircleChart.fillColor = nil
        profileContentBox.layer.addSublayer(profileImageCircleChart)
        
        // Name label
        let nameLabel = UILabel()
        nameLabel.text = "Simon Degn"
        nameLabel.textColor = UIColor(red: (17/255.0), green: (17/255.0), blue: (17/255.0), alpha: 1.0)
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont(name: "AsapCondensed-Medium", size: 22)
        nameLabel.frame = CGRect(x: CGFloat(padding) * CGFloat(2.0) + profileImageView.frame.size.width,
                                 y: CGFloat(padding),
                                 width: (self.view.frame.size.width - CGFloat(padding) * CGFloat(2.0) + profileImageView.frame.size.width),
                                 height: CGFloat(25.0))
        profileContentBox.addSubview(nameLabel)
        
        // Name label
        let tabMenuBG = UIView()
        tabMenuBG.frame = CGRect(x: padding, y: (Double(profileContentBox.frame.origin.y) + Double(profileContentBox.frame.size.height) + Double(padding)), width: Double(self.view.frame.size.width)-padding*2 , height: 40.0)
        tabMenuBG.backgroundColor = .white
        self.view.addSubview(tabMenuBG)
        
        // Tab menu
        tabMenu.profileView = self
        print(tabMenu.profileView!)
        tabMenu.frame = CGRect(x: padding + 8.0, y: (Double(profileContentBox.frame.origin.y) + Double(profileContentBox.frame.size.height) + Double(padding)), width: Double(self.view.frame.size.width)-padding*2 - 16.0, height: 40.0)
        tabMenu.backgroundColor = .white
        tabMenu.numberOfTabs(number: 2)
        self.view.addSubview(tabMenu)
        
        // Lists view container
        listsViewContainer.frame = CGRect(x: padding,
                                               y: (Double(tabMenu.frame.origin.y) + Double(tabMenu.frame.size.height) + Double(padding)),
                                               width: Double(self.view.frame.size.width)-padding*2,
                                               height: (Double(self.view.frame.size.height) - ((Double(tabMenu.frame.origin.y) + Double(tabMenu.frame.size.height)) + Double(padding))) - 70)
        listsViewContainer.backgroundColor = .red
        listsViewContainer.clipsToBounds = true
        self.view.addSubview(listsViewContainer)
        
        // Your podcasts (subscriptions)
        subscriptionsTableView.frame = CGRect(x: 0.0, y: 0.0, width: listsViewContainer.frame.size.width, height:  listsViewContainer.frame.size.height)
        subscriptionsTableView.dataSource = self
        subscriptionsTableView.delegate = self
        subscriptionsTableView.register(ProfilePodcastCell.self, forCellReuseIdentifier: "ProfilePodcastCell")
        subscriptionsTableView.tag = 1
        subscriptionsTableView.tableFooterView = UIView()
        listsViewContainer.addSubview(subscriptionsTableView)
        getSubscribedPodcasts(offset: 0)
        
        // Notifications
        notificationsTableView.frame = CGRect(x: listsViewContainer.frame.size.width, y: 0.0, width: listsViewContainer.frame.size.width, height:  listsViewContainer.frame.size.height)
        notificationsTableView.dataSource = self
        notificationsTableView.delegate = self
        notificationsTableView.register(ProfileNotificationCell.self, forCellReuseIdentifier: "ProfileNotificationCell")
        notificationsTableView.tag = 2
        notificationsTableView.tableFooterView = UIView()
        listsViewContainer.addSubview(notificationsTableView)
        getNotifications(offset: 0)
    }
    
    
    @objc func viewDragged(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        // TODO: do something more smooth than the native 'animated: true' thing and catch the missing x-dist and calc a transition.
        
        switch sender.state {
        case .began:
            break
        case .changed:
            root?.rootScroolView.contentOffset = CGPoint(x: CGFloat((root?.rootScroolView.contentOffset.x)!) - CGFloat(translation.x), y: (root?.rootScroolView.contentOffset.y)!)
            break
        case .ended:
            if (root?.rootScroolView.contentOffset.x)! < (self.view.frame.size.width / 10) {
                root?.rootScroolView.setContentOffset(CGPoint(x: 0, y: (root?.rootScroolView.contentOffset.y)!), animated: true)
            } else {
                root?.rootScroolView.setContentOffset(CGPoint(x: self.view.frame.size.width, y: (root?.rootScroolView.contentOffset.y)!), animated: true)
            }
            break
            
        case .cancelled:
            root?.rootScroolView.contentOffset = CGPoint(x: CGFloat((root?.rootScroolView.contentOffset.x)!) - CGFloat(translation.x), y: (root?.rootScroolView.contentOffset.y)!)
            break
            
        default:
            root?.rootScroolView.contentOffset = CGPoint(x: CGFloat((root?.rootScroolView.contentOffset.x)!) - CGFloat(translation.x), y: (root?.rootScroolView.contentOffset.y)!)

            break
        }
    }
    
    
    
    @objc func listDragged(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.view)
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        var minMovement = self.view.frame.size.width / 10
        let moveDiff = listsViewContainer.contentOffset.x - a

        // TODO: do something more smooth than the native 'animated: true' thing and catch the missing x-dist and calc a transition.
        
        switch sender.state {
        case .began:
            a = CGFloat(tabMenu.currentTabIndex) * listsViewContainer.frame.size.width
            break
            
        case .changed:
            
            let potentialX = listsViewContainer.contentOffset.x - CGFloat(translation.x)
            
            if (potentialX >= listsViewContainer.frame.size.width * CGFloat(tabMenu.tabs.count-1))  {
                
                    // listsViewContainer is maxed out so instead it pushes the root to the right.
                    listsViewContainer.contentOffset.x = listsViewContainer.frame.size.width * CGFloat(tabMenu.tabs.count-1)
                    root?.rootScroolView.contentOffset.x = root!.rootScroolView.contentOffset.x - CGFloat(translation.x)
                
            } else if (root!.rootScroolView.contentOffset.x > CGFloat(0.0)) {
                
                // listsViewContainer is maxed out so instead it pushes the root to the left.
                listsViewContainer.contentOffset.x = listsViewContainer.frame.size.width * CGFloat(tabMenu.tabs.count-1)
                root?.rootScroolView.contentOffset.x = root!.rootScroolView.contentOffset.x - CGFloat(translation.x)
                
            } else {
                
                // listsViewContainer is not maxed out so we push it.
                listsViewContainer.contentOffset.x = potentialX
            }
            
            tabMenu.moveSelectedIndicator(x: listsViewContainer.contentOffset.x, width: self.view.frame.size.width, animated: false)
            break
            
        case .ended:
            
            // Gesture has ended: let's return...
            // let a = CGFloat(tabMenu.currentTabIndex) * listsViewContainer.frame.size.width
            
            print("\(listsViewContainer.contentOffset.x) - \(a)")
            
            if moveDiff >= 0 {
                // Attempting to go right
                
                if (moveDiff < minMovement) {
                    // Return to 0 after failing scroll forward attempt.
                    listsViewContainer.setContentOffset(CGPoint(x: a, y: (listsViewContainer.contentOffset.y)), animated: true)
                    tabMenu.moveSelectedIndicator(x: a, width: self.view.frame.size.width, animated: true)
                    
                } else if (moveDiff >= minMovement) {
                    
                    // Complete scrolling forward.
                    listsViewContainer.setContentOffset(CGPoint(x: a + listsViewContainer.frame.size.width, y: (listsViewContainer.contentOffset.y)), animated: true)
                    tabMenu.moveSelectedIndicator(x: a + listsViewContainer.frame.size.width, width: self.view.frame.size.width, animated: true)
                }
            } else {
                // Attempting to go left
                minMovement = -1.0 * minMovement
                if (moveDiff > minMovement || a == 0) {
                    // Return to 0 after failing scroll forward attempt.
                    listsViewContainer.setContentOffset(CGPoint(x: a, y: (listsViewContainer.contentOffset.y)), animated: true)
                    tabMenu.moveSelectedIndicator(x: a, width: self.view.frame.size.width, animated: true)
                    
                } else if (moveDiff <= minMovement) {
                    
                    // Complete scrolling forward.
                    listsViewContainer.setContentOffset(CGPoint(x: a - listsViewContainer.frame.size.width, y: (listsViewContainer.contentOffset.y)), animated: true)
                    tabMenu.moveSelectedIndicator(x: a - listsViewContainer.frame.size.width, width: self.view.frame.size.width, animated: true)
                }
            }
            
            if (root?.rootScroolView.contentOffset.x)! < (self.view.frame.size.width / 10) {
                root?.rootScroolView.setContentOffset(CGPoint(x: 0, y: (root?.rootScroolView.contentOffset.y)!), animated: true)
            } else {
                root?.rootScroolView.setContentOffset(CGPoint(x: self.view.frame.size.width, y: (root?.rootScroolView.contentOffset.y)!), animated: true)
            }
            break
            
        case .cancelled:
            listsViewContainer.contentOffset = CGPoint(x: CGFloat((listsViewContainer.contentOffset.x)) - CGFloat(translation.x), y: (listsViewContainer.contentOffset.y))
            break
            
        default:
            
            break
        }
    }
   
    
    public func scrollToList(listIndex: Int) {
        
        listsViewContainer.setContentOffset(CGPoint(x: CGFloat(listsViewContainer.frame.size.width * CGFloat(listIndex)), y: (listsViewContainer.contentOffset.y)), animated: true)
        
        tabMenu.moveSelectedIndicator(x: CGFloat((listsViewContainer.frame.size.width - CGFloat(padding*2))  * CGFloat(listIndex)), width: listsViewContainer.frame.size.width, animated: true)
    }
    
    
    func getSubscribedPodcasts(offset: Int) {
        let limit = 20
        let db = Firestore.firestore()
        db.collection("subscriptions/\(CurrentUserData.id)/shows").limit(to: limit).getDocuments() { (querySnapshot, err) in
            for document in querySnapshot!.documents {
                let showObject = ShowObject()
                subscripedPodcasts.append(showObject)
                showObject.getInfoFromRef(ref: document["show_reference"] as! DocumentReference, rowIndex: subscripedPodcasts.count-1, completion: { response in
                    let ip = IndexPath.init(row: response, section: 0)
                    self.subscriptionsTableView.reloadRows(at: [ip], with: .none)
                    showObject.getImage(completion: { (image) in
                        self.subscriptionsTableView.reloadRows(at: [ip], with: .none)
                    })
                })
                // TODO: it needs to put in the image in the subscripedPodcasts after loading..
            }
            self.subscriptionsTableView.reloadData()
        }
    }
    
    
    func getNotifications(offset: Int) {
        let limit = 20
        let db = Firestore.firestore()
        db.collection("notifications/\(CurrentUserData.id)/notifications").limit(to: limit).getDocuments() { (querySnapshot, err) in
            for document in querySnapshot!.documents {
                let notification = NotificationObject()
                notification.updateInfo(document: document)
                notifications.append(notification)
            }
            self.notificationsTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            let showObject = subscripedPodcasts[indexPath.row]
            root!.enterDetailMode(typeOfDetailItem: "show", parameter: showObject)
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let showObject = subscripedPodcasts[indexPath.row]
            let cell = ProfilePodcastCell()
            cell.profilePodcastCellTitleLabel.text = showObject.title
            cell.profilePodcastCellSummaryLabel.text = showObject.descriptionText
            cell.profilePodcastCellAuthorLabel.text = showObject.author
            cell.profilePodcastCellImageview.image = showObject.image
            cell.selectionStyle = .none
            return cell
        } else if tableView.tag == 2 {
            let notification = notifications[indexPath.row]
            let cell = ProfileNotificationCell()
            cell.profileNotificationCellTextLabel.text = "\(notification.text)"
            cell.selectionStyle = .none
            return cell
        }
        let cell = ProfilePodcastCell()
        print("ERROR: no tableview.tag...")
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return subscripedPodcasts.count
        } else if tableView.tag == 2 {
            return notifications.count
        } else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView.tag == 1 {
            return 110.0
        } else if tableView.tag == 2 {
            return 80.0
        } else {
            return 0
        }
    }
}

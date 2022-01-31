//
//  HomeViewController.swift
//  PetWorld
//
//  Created by joseph on 2020/5/21.
//  Copyright © 2020 joseph_Eagles. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
   

    var tableView: UITableView!
    let loadingview = UIView()
    var cellHeights: [IndexPath : CGFloat] = [:]
    
    var refershcontroller : UIRefreshControl!
    var posts = [Post]()
    var fetchingMore = false
    var endReached = false
    let leadingScreensForBatching:CGFloat = 3.0
    
    var seeNewPostsButton:SeeNewPostsButton!
    var seeNewPostsButtonTopAnchor:NSLayoutConstraint!
    
    var lastUploadedPostID:String?
    
    
  

    var image : UIImage?
    
   
    var oldPostsQuery:DatabaseQuery {
        var queryRef:DatabaseQuery
        let lastPost = posts.last
        if lastPost != nil {
            let lastTimestamp = lastPost!.CreateDate.timeIntervalSince1970 * 1000
            queryRef = postsRef.queryOrdered(byChild: "timestamp").queryEnding(atValue: lastTimestamp)
        } else {
            queryRef = postsRef.queryOrdered(byChild: "timestamp")
        }
        return queryRef
    }
    
    var newPostsQuery:DatabaseQuery {
        var queryRef:DatabaseQuery
        let firstPost = posts.first
        if firstPost != nil {
            let firstTimestamp = firstPost!.CreateDate.timeIntervalSince1970 * 1000
            queryRef = postsRef.queryOrdered(byChild: "timestamp").queryStarting(atValue: firstTimestamp)
        } else {
            queryRef = postsRef.queryOrdered(byChild: "timestamp")
        }
        return queryRef
    }
    

    var postsRef : DatabaseReference {
        return Database.database().reference().child("posts")
    }
    var Hometablecell : HomePostTableViewCell!
    
     //let  userid = Auth.auth().currentUser?.uid
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        listenForNewPosts()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        stopListeningForNewPosts()
    }

    //MARK:- View did appear
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create table view on the view did load
        tableView = UITableView(frame: view.bounds, style: .plain)
        let cellNib = UINib(nibName: "HomePostTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "postcell")
        tableView.register(LoadCell.self, forCellReuseIdentifier: "loadingCell")
        
        view.addSubview(tableView)
        
        
        // set the navigation title to the current user
      
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 39, height: 39))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "logo.png")
        imageView.image = image
        navigationItem.titleView = imageView
        
        //setloadingScreeen()
        
        // settting the taeble lay out
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        // update  table from firebase datastore
        //observePosts()
        beginBatchFetch()
        
        var layoutGuide:UILayoutGuide!
        
        if #available(iOS 11.0, *) {
            layoutGuide = view.safeAreaLayoutGuide
        } else {
            // Fallback on earlier versions
            layoutGuide = view.layoutMarginsGuide
        }
        refershcontroller = UIRefreshControl()
        if #available(iOS 10, *){
        tableView.refreshControl = refershcontroller
        }
        else {
            
            tableView.addSubview(refershcontroller)
        }
        refershcontroller.addTarget(self, action: #selector(handleRefersh), for: .valueChanged)
        seeNewPostsButton = SeeNewPostsButton()
        view.addSubview(seeNewPostsButton)
        seeNewPostsButton.translatesAutoresizingMaskIntoConstraints = false
        seeNewPostsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        seeNewPostsButtonTopAnchor = seeNewPostsButton.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: -44)
        seeNewPostsButtonTopAnchor.isActive = true
        seeNewPostsButton.heightAnchor.constraint(equalToConstant: 42.0).isActive = true
        seeNewPostsButton.widthAnchor.constraint(equalToConstant: seeNewPostsButton.button.bounds.width).isActive = true
        
        seeNewPostsButton.button.addTarget(self, action: #selector(handleRefersh), for: .touchUpInside)
 
    }
    
    
   // spinner for tableview datasource
    
    
    
    
    // stoping spinner
    
 
    
    func toggleSeeNewPostsButton(hidden:Bool) {
        if hidden {
            // hide it
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.seeNewPostsButtonTopAnchor.constant = -44.0
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            // show it
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.seeNewPostsButtonTopAnchor.constant = 12
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc func handleRefersh () {
        
        print("refersh me " )
         toggleSeeNewPostsButton(hidden: true)
       
        newPostsQuery.queryLimited(toFirst: 20).observeSingleEvent(of: .value, with: { snapshot in
            var tempPosts = [Post]()
            
            let firstPost = self.posts.first
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let data = childSnapshot.value as? [String:Any],
                    let post = Post.parse(childSnapshot.key, data),
                    childSnapshot.key != firstPost?.id {
                    
                    tempPosts.insert(post, at: 0)
                }
            }
            
            self.posts.insert(contentsOf: tempPosts, at: 0)
            
            let newIndexPaths = (0..<tempPosts.count).map { i in
                return IndexPath(row: i, section: 0)
            }
            
            self.refershcontroller.endRefreshing()
            self.tableView.insertRows(at: newIndexPaths, with: .top)
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            
          //  self.listenForNewPosts()
            
        })
    }
    /// Observe the post
    
    func fetchPosts(completion:@escaping (_ posts:[Post])->()) {
       // let postsRef = Database.database().reference().child("posts")
       
       
        oldPostsQuery.queryLimited(toLast: 5).observeSingleEvent(of: .value, with: { snapshot in
            var tempPosts = [Post]()
            let lastPost = self.posts.last
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let data = childSnapshot.value as? [String:Any],
                    let post = Post.parse(childSnapshot.key, data) , childSnapshot.key != lastPost?.id {
                      
                        tempPosts.insert(post, at: 0)
                    }
            
                
            }
            
            return completion(tempPosts)
        })
        }
    
    

//    @IBAction func logoutbuttonpressed(_ sender: UIBarButtonItem) {
//        
//        do {
//            try Auth.auth().signOut()
//            
//            //navigationController?.popToRootViewController(animated: true)
//             self.dismiss(animated: true, completion: nil)
//        } catch let signOutError as NSError {
//            
//            print ("Error signing out: %@", signOutError)
//        }
//    }
//    
    // Table view Data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
       
        return 2
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return posts.count
        case 1:
            return fetchingMore ? 1 : 0
        default:
            return 0
        }
      
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postcell", for: indexPath) as! HomePostTableViewCell
            cell.setPost(post: posts[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadCell
            cell.spinner.startAnimating()
            return cell
        }

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height * leadingScreensForBatching {
            
            if !fetchingMore && !endReached {
                beginBatchFetch()
            }
        }
    }
    
    //Mark:- Fectch A post
    
    func beginBatchFetch() {
        fetchingMore = true
        self.tableView.reloadSections(IndexSet(integer: 1), with: .fade)
        
        fetchPosts { newPosts in
            self.posts.append(contentsOf: newPosts)
            self.fetchingMore = false
            self.endReached = newPosts.count == 0
            
            UIView.performWithoutAnimation {
                self.tableView.reloadData()
                 self.listenForNewPosts()
                
            }
        }
    }
    
    
    //Mark:- Post Listner
    
    var postListenerHandle:UInt?
    
    func listenForNewPosts() {
        
        guard !fetchingMore else { return }
        
        // Avoiding duplicate listeners
        stopListeningForNewPosts()
        
        postListenerHandle = newPostsQuery.observe(.childAdded, with: { snapshot in
            
            if snapshot.key != self.posts.first?.id,
                let data = snapshot.value as? [String:Any],
                let post = Post.parse(snapshot.key, data) {
                
                self.stopListeningForNewPosts()
                
                if snapshot.key == self.lastUploadedPostID {
                    self.handleRefersh()
                    self.lastUploadedPostID = nil
                } else {
                    self.toggleSeeNewPostsButton(hidden: false)
                }
            }
        })
    }
    
    func stopListeningForNewPosts() {
        if let handle = postListenerHandle {
            newPostsQuery.removeObserver(withHandle: handle)
            postListenerHandle = nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newPostNavBar = segue.destination as? UINavigationController,
            let newPostVC = newPostNavBar.viewControllers[0] as? AddPostViewController {
            
            newPostVC.delegate = self
        }
    }
}
extension HomeViewController: NewPostVCDelegate {
    func didUploadPost(withID id: String) {
        self.lastUploadedPostID = id
    }
}




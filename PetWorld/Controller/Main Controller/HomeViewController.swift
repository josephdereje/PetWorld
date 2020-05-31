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
    
    var image : UIImage?
    
    var posts = [Post]()
    
    var data : DatabaseReference? 
    var Hometablecell : HomePostTableViewCell!
    
     let  userid = Auth.auth().currentUser?.uid
 
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: view.bounds, style: .plain)
        let cellNib = UINib(nibName: "HomePostTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "postcell")
        view.addSubview(tableView)
        let user = Auth.auth().currentUser
        let Emailuser = user?.email
        
        navigationItem.title = Emailuser
        
        tableView.separatorStyle = .none
        //tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
        observePosts()
        // Do any additional setup after loading the view.
    }
   
    
    
    
    /// Observe the post
    
    func observePosts() {
        let postsRef = Database.database().reference().child("posts")
        
        postsRef.observe(.value, with: { snapshot in
            
            var tempPosts = [Post]()
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let author = dict["author"] as? [String:Any],
                    let uid = author["uid"] as? String,
                    let username = author["username"] as? String,
                    let photoURL = author["photoURL"] as? String,
                    let url = URL(string:photoURL),
                    let text = dict["text"] as? String,
                    let timestamp = dict["timestamp"] as? Double {
                    
                    let userProfile = UserProfile(uid: uid, username: username, photoURL: url)
                    let post = Post(id: childSnapshot.key, author: userProfile, text: text, timestamp:timestamp)
                    tempPosts.append(post)
                }
            }
            
            self.posts = tempPosts
            self.tableView.reloadData()
            
        })
    }
    

    @IBAction func logoutbuttonpressed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            
            //navigationController?.popToRootViewController(animated: true)
             self.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            
            print ("Error signing out: %@", signOutError)
        }
    }
    
    // Table view Data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postcell", for: indexPath) as! HomePostTableViewCell
       cell.setPost(post: posts[indexPath.row])
        
        return cell
    
    }

}

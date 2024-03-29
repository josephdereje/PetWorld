//
//  HomePostTableViewCell.swift
//  PetWorld
//
//  Created by joseph on 2020/5/23.
//  Copyright © 2020 joseph_Eagles. All rights reserved.
//

import UIKit

class HomePostTableViewCell: UITableViewCell {

    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var timeDisplay: UILabel!
    @IBOutlet weak var currentuserName: UILabel!
    @IBOutlet weak var userProfileimage: UIImageView!
    @IBOutlet weak var textDescription: UILabel!
//  var spinner  = UIActivityIndicatorView()
//    let spinnerimage = UIImageView()
    let ind = UIView()
    override func awakeFromNib() {
    
        super.awakeFromNib()
        // Initialization code
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        userProfileimage.layer.cornerRadius =  userProfileimage.bounds.height/2
         userProfileimage.clipsToBounds = true
        
         postImage.contentMode = .scaleAspectFill
       
//        spinner = UIActivityIndicatorView(style: .white)
//        spinner.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        
        
       
        
    }
    

    weak var post : Post?
    
    
    func setPost(post: Post) {
        
        self.post = post
        self.userProfileimage.image = nil
        self.postImage.image = nil
        let ind = spinner(frame:CGRect(x: 0, y: 0, width: 50, height: 50) ,image: UIImage(named: "activity_image")!)
       
    
        
        ImageAdd.getImage(withURL: post.author.photoURL) { image , url in
            guard let _post = self.post else { return }
            self.addSubview(ind)
            ind.startAnimating()
            if _post.author.photoURL.absoluteString == url.absoluteString {
                
              ind.stopAnimating()
                self.userProfileimage.image = image
            }
            else
            {
               
               
                //
                print("no image found ")
            }
           
        }
        ImageAdd.getImage(withURL: post.postimage.PostphotoURL, completion: { (image, url) in
            guard let _post = self.post else { return }
            self.addSubview(ind)
            ind.startAnimating()
            if _post.postimage.PostphotoURL.absoluteString == url.absoluteString {
                
                ind.stopAnimating()
                self.postImage.image = image
            }
            else
            {
                ind.startAnimating()
                
                print("no image found ")
            }
            
        })
        
        currentuserName.text = post.author.username
        textDescription.text = post.text
         
         timeDisplay.text =  post.CreateDate.calenderTimeSinceNow()
        
        
    }
    
    
    
}

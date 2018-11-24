//
//  UserVC.swift
//  party
//
//  Created by John Leonardo on 11/23/18.
//  Copyright © 2018 John Leonardo. All rights reserved.
//

import UIKit
import YXWaveView
import SwiftMessages
import Firebase

class UserVC: UIViewController {
    
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postsLbl: UILabel!
    @IBOutlet weak var followersLbl: UILabel!
    @IBOutlet weak var followingLbl: UILabel!
    @IBOutlet weak var verifiedImg: UIImageView!
    @IBOutlet weak var crownImg: UIImageView!
    @IBOutlet weak var originalImg: UIImageView!
    @IBOutlet weak var spotifyImg: UIImageView!
    
    let defaults = UserDefaults.standard
    
    var userId: String = ""
    var userImg: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //badges hidden by default
        verifiedImg.isHidden = true
        crownImg.isHidden = true
        originalImg.isHidden = true
        spotifyImg.isHidden = true
        
        //style follow btn
        followBtn.layer.cornerRadius = 10.0
        
        //set up wave view
        let frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 150)
        let waterView = YXWaveView(frame: frame, color: UIColor.white)
        
        //set up avatar view
        let avatarFrame = CGRect(x: 0, y: 0, width: 80, height: 80)
        let avatarView = UIImageView(frame: avatarFrame)
        avatarView.layer.cornerRadius = avatarView.bounds.height/2
        avatarView.layer.masksToBounds = true
        avatarView.layer.borderColor  = UIColor.white.cgColor
        avatarView.layer.borderWidth = 2
        avatarView.layer.contents = userImg.cgImage
        
        //add OverView
        waterView.addOverView(avatarView)
        waterView.backgroundColor = UIColor(red:0.99, green:0.00, blue:0.33, alpha:1.0)
        waterView.waveHeight = 7
        self.view.addSubview(waterView)
        
        //add observer to water view
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.topTapped))
        waterView.addGestureRecognizer(tap)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.topTapped))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        waterView.addGestureRecognizer(swipeDown)
        
        //start wave view
        waterView.start()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //download user data
        self.downloadUserData()
    }
    
    @objc func topTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func downloadUserData() {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        userRef.getDocument { (snap, error) in
            if error != nil {
                //error, handle
                print(error?.localizedDescription)
            } else {
                //set name and status of user's own account
                let name = snap?.get("name") as! String
                let username = snap?.get("username") as! String
                let posts = snap?.get("posts") as! Int
                let followers = snap?.get("followers") as! Int
                let following = snap?.get("following") as! Int
                self.nameLbl.text = name
                self.usernameLbl.text = "@" + username
                self.postsLbl.text = "\(posts)"
                self.followersLbl.text = "\(followers)"
                self.followingLbl.text = "\(following)"
                
                if followers >= 1000 && posts >= 1000 {
                    self.crownImg.isHidden = false
                }
                
                if let _ = snap?.get("verified") {
                    self.verifiedImg.isHidden = false
                }
                
                if let _ = snap?.get("original") {
                    self.originalImg.isHidden = false
                }
                
                if let _ = snap?.get("spotify") {
                    self.spotifyImg.isHidden = false
                }
            }
        }
    }


}

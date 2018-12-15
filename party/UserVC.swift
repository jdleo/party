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
import AVFoundation
import SAConfettiView

class UserVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, PostCellDelegate {
    
    
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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    let defaults = UserDefaults.standard
    
    var posts: [[String: Any]] = []
    
    let imageCache = NSCache<NSString, UIImage>()
    
    var userId: String = ""
    var userImg: UIImage!
    
    var isFollowing = false
    
    //let screenHeight = UIScreen.main.bounds.height
    //let scrollViewContentHeight = 800 as CGFloat
    //let scrollViewContentWidth = UIScreen.main.bounds.width

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.bounces = false
        
        //link up tableview
        tableView.delegate = self
        tableView.dataSource = self
        
        //register custom nibs
        tableView.register(UINib(nibName: "TextPostCell", bundle: nil), forCellReuseIdentifier: "TextPostCell")
        tableView.register(UINib(nibName: "SongPostCell", bundle: nil), forCellReuseIdentifier: "SongPostCell")
        tableView.register(UINib(nibName: "PhotoPostCell", bundle: nil), forCellReuseIdentifier: "PhotoPostCell")
        tableView.register(UINib(nibName: "PollPostCell", bundle: nil), forCellReuseIdentifier: "PollPostCell")
        tableView.register(UINib(nibName: "FoodPostCell", bundle: nil), forCellReuseIdentifier: "FoodPostCell")
        tableView.register(UINib(nibName: "TVPostCell", bundle: nil), forCellReuseIdentifier: "TVPostCell")
        
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
        
        //download User's posts
        let db = Firestore.firestore()
        db.collection("posts").document(self.userId).collection("posts").order(by: "created_at", descending: true).limit(to: 50).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //format and append data to posts array
                    var data = document.data()
                    data["id"] = document.documentID
                    self.posts.append(data)
                }
                self.tableView.reloadData()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        let postType = post["type"] as! String
        
        if postType == "song" {
            let preview = post["preview"] as! String
            
            if preview != "null" {
                self.playSound(soundUrl: preview)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        let type = post["type"] as! String
        
        if type == "textpost" {
            return 200
        } else if type == "photo" {
            return 400
        } else if type == "poll" {
            return 290
        }
        
        return 130
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //download user data
        self.downloadUserData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //reference to current post in table view
        let post = posts[indexPath.row]
        let postType = post["type"] as! String
        
        if postType == "textpost" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextPostCell", for: indexPath) as! TextPostCell
            cell.delegate = self
            cell.postId = post["id"] as! String
            cell.bodyLbl.text = post["body"] as! String
            
            let timestamp = post["created_at"] as! Timestamp
            //MMM d, h:mm a
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, h:mm a"
            dateFormatter.timeZone = TimeZone.current
            cell.dateLabel.text = "\(dateFormatter.string(from: timestamp.dateValue()))"
            
            return cell
        } else if postType == "song" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SongPostCell", for: indexPath) as! SongPostCell
            let timestamp = post["created_at"] as! Timestamp
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, h:mm a"
            dateFormatter.timeZone = TimeZone.current
            cell.dateLbl.text = "\(dateFormatter.string(from: timestamp.dateValue()))"
            
            let artist = post["artist"] as! String
            let track = post["track"] as! String
            cell.artistLbl.text = artist
            cell.trackLbl.text = track
            
            let imageLink = post["image"] as! String
            
            cell.albumImg.image = nil
            cell.tag = indexPath.row
            
            let url = URL(string: imageLink)
            
            if let cachedImage = imageCache.object(forKey: url?.absoluteString as! NSString) {
                cell.albumImg.image = cachedImage
            } else {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    DispatchQueue.main.async {
                        if cell.tag == indexPath.row {
                            cell.albumImg.image = UIImage(data: data!)
                            self.imageCache.setObject(UIImage(data: data!)!, forKey: url?.absoluteString as! NSString)
                        }
                    }
                }
            }
            
            return cell
        } else if postType == "photo" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoPostCell", for: indexPath) as! PhotoPostCell
            cell.delegate = self
            let timestamp = post["created_at"] as! Timestamp
            let photoId = post["photoId"] as! String
            cell.postId = post["id"] as! String
            cell.postImg.image = nil
            cell.tag = indexPath.row
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, h:mm a"
            dateFormatter.timeZone = TimeZone.current
            cell.dateLbl.text = "\(dateFormatter.string(from: timestamp.dateValue()))"
            
            let storage = Storage.storage().reference()
            // Create a reference to the file you want to download
            let picRef = storage.child("photos/\(self.userId)/\(photoId)")
            
            if let cachedImage = imageCache.object(forKey: photoId as NSString) {
                cell.postImg.image = cachedImage
            } else {
                // Download in memory with a maximum allowed size of 5MB (5 * 1024 * 1024 bytes)
                picRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                    if let error = error {
                        // Uh-oh, an error occurred!
                    } else {
                        // Data for "images/island.jpg" is returned
                        if cell.tag == indexPath.row {
                            cell.postImg.image = UIImage(data: data!)
                            self.imageCache.setObject(UIImage(data: data!)!, forKey: photoId as NSString)
                        }
                    }
                }
            }
            return cell
        } else if postType == "poll" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PollPostCell", for: indexPath) as! PollPostCell
            return cell
        } else if postType == "food" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FoodPostCell", for: indexPath) as! FoodPostCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TVPostCell", for: indexPath) as! TVPostCell
            return cell
        }
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
    
    @IBAction func attemptFollow(_ sender: Any) {
        if self.isFollowing {
            //user is already following
            let db = Firestore.firestore()
            
            //set data for following
            if let uid = Auth.auth().currentUser?.uid {
                db.collection("following").document(uid).collection("following").document(self.userId).delete() { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        self.followBtn.setTitle("Follow", for: .normal)
                        self.isFollowing = false
                    }
                }
            }
        } else {
            //user is not already following
            let db = Firestore.firestore()
            
            //set data for following
            if let uid = Auth.auth().currentUser?.uid {
                db.collection("following").document(uid).collection("following").document(self.userId).setData([
                    "time": Timestamp.init()
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        self.followBtn.setTitle("Following ✓", for: .normal)
                        self.isFollowing = true
                    }
                }
            }
        }
    }
    
    
    //helper function to play .mp3 file
    func playSound(soundUrl: String) {
        var player: AVPlayer!
        let url = URL.init(string: soundUrl)
        do {
            let playerItem: AVPlayerItem = AVPlayerItem(url: url!)
            player = AVPlayer(playerItem: playerItem)
            player.play()
        }catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func react1(_ sender: TextPostCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        print("tapped 😍")
    }
    
    func react2(_ sender: TextPostCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        print("tapped 😎")
    }
    
    func react3(_ sender: TextPostCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        print("tapped 😡")
    }
    
    func react4(_ sender: TextPostCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        print("tapped 😔")
    }
    
    func react5(_ sender: TextPostCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        print("tapped 😂")
    }
    
    func react6(_ sender: TextPostCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        print("tapped 😉")
    }
    
    func react1(_ sender: PhotoPostCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        print("tapped 😍")
    }
    
    func react2(_ sender: PhotoPostCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        print("tapped 😍")
    }
    
    func react3(_ sender: PhotoPostCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        print("tapped 😍")
    }
    
    func react4(_ sender: PhotoPostCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        print("tapped 😍")
    }
    
    func react5(_ sender: PhotoPostCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        print("tapped 😍")
    }
    
    func react6(_ sender: PhotoPostCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        print("tapped 😍")
    }
}

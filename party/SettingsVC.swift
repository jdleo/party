//
//  SettingsVC.swift
//  party
//
//  Created by John Leonardo on 11/19/18.
//  Copyright © 2018 John Leonardo. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {
    
    @IBOutlet weak var card1: UIView!
    @IBOutlet weak var card2: UIView!
    @IBOutlet weak var card3: UIView!
    @IBOutlet weak var card4: UIView!
    @IBOutlet weak var card5: UIView!
    @IBOutlet weak var card6: UIView!
    @IBOutlet weak var card7: UIView!
    @IBOutlet weak var profilePic: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tap gestures
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(supportTapped))
        card1.addGestureRecognizer(tap1)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(changeProfilePicTapped))
        card2.addGestureRecognizer(tap2)
        
        //style profile pic view
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2
        profileImg.clipsToBounds = true
        
        //download user data
        self.downloadUserData()

        //style settings cards
        card1.dropShadow(scale: true)
        card1.layer.cornerRadius = 10.0
        card2.dropShadow(scale: true)
        card2.layer.cornerRadius = 10.0
        card3.dropShadow(scale: true)
        card3.layer.cornerRadius = 10.0
        card4.dropShadow(scale: true)
        card4.layer.cornerRadius = 10.0
        card5.dropShadow(scale: true)
        card5.layer.cornerRadius = 10.0
        card6.dropShadow(scale: true)
        card6.layer.cornerRadius = 10.0
        card7.dropShadow(scale: true)
        card7.layer.cornerRadius = 10.0
        
    }

    @IBAction func unwindToSettings(segue:UIStoryboardSegue) { }
    
    func downloadUserData() {
        if let uid = Auth.auth().currentUser?.uid {
            let storage = Storage.storage().reference()
            let picRef = storage.child("avatars/\(uid)")
            
            // Download in memory with a maximum allowed size of 5MB (1 * 1024 * 1024 bytes)
            picRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    // Data for "images/island.jpg" is returned
                    let image = UIImage(data: data!)
                    self.profilePic.image = image
                }
            }
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func supportTapped() {
        self.performSegue(withIdentifier: "goToCrisp", sender: nil)
    }
    
    @objc func changeProfilePicTapped() {
        
    }
}

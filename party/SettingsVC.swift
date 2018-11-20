//
//  SettingsVC.swift
//  party
//
//  Created by John Leonardo on 11/19/18.
//  Copyright © 2018 John Leonardo. All rights reserved.
//

import UIKit
import Firebase
import SwiftMessages

class SettingsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var card1: UIView!
    @IBOutlet weak var card2: UIView!
    @IBOutlet weak var card3: UIView!
    @IBOutlet weak var card4: UIView!
    @IBOutlet weak var card5: UIView!
    @IBOutlet weak var card6: UIView!
    @IBOutlet weak var card7: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var privateSwitch: UISwitch!
    
    //instatiate image picker controller
    let imagePicker = UIImagePickerController()
    
    var changedProfilePic = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set image picker delegate
        imagePicker.delegate = self
        
        //tap gestures
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(supportTapped))
        card1.addGestureRecognizer(tap1)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(changeProfilePicTapped))
        card2.addGestureRecognizer(tap2)
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(changeUsernameTapped))
        card3.addGestureRecognizer(tap3)
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(changePasswordTapped))
        card4.addGestureRecognizer(tap4)
        
        //style profile pic view
        profilePic.layer.cornerRadius = profilePic.frame.size.width/2
        profilePic.clipsToBounds = true
        
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
    @IBAction func unwindToSettings2(segue:UIStoryboardSegue) { }
    
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
        print(changedProfilePic)
        if changedProfilePic {
            if let uid = Auth.auth().currentUser?.uid {
                //attempt to upload new profile pic
                let storage = Storage.storage().reference()
                let picRef = storage.child("avatars/\(uid)")
                let imageData = self.profilePic.image!.jpegData(compressionQuality: 0.5)
                picRef.putData(imageData!, metadata: nil, completion: { (meta, error) in
                    if error != nil {
                        print(error?.localizedDescription)
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        print("uploaded new profile pic")
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func supportTapped() {
        self.performSegue(withIdentifier: "goToCrisp", sender: nil)
    }
    
    @objc func changeUsernameTapped() {
        self.performSegue(withIdentifier: "goToChangeUsername", sender: nil)
    }
    
    @objc func changePasswordTapped() {
        if let user = Auth.auth().currentUser {
            Auth.auth().sendPasswordReset(withEmail: user.email ?? "error") { (error) in
                if error != nil {
                    let view = MessageView.viewFromNib(layout: .centeredView)
                    view.configureTheme(.error)
                    view.configureDropShadow()
                    view.button?.isHidden = true
                    view.configureContent(title: "Oops", body: error?.localizedDescription ?? "Something went wrong", iconText:"😓")
                    view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
                    var config = SwiftMessages.Config()
                    config.presentationStyle = .center
                    config.duration = .seconds(seconds: 2)
                    SwiftMessages.show(config: config, view: view)
                } else {
                    let view = MessageView.viewFromNib(layout: .centeredView)
                    view.configureTheme(.success)
                    view.configureDropShadow()
                    view.button?.isHidden = true
                    view.configureContent(title: "Success", body: "A password reset link has been sent to your email! Be sure to check Junk mail.", iconText:"🎉")
                    view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
                    var config = SwiftMessages.Config()
                    config.presentationStyle = .center
                    config.duration = .seconds(seconds: 2)
                    SwiftMessages.show(config: config, view: view)
                }
            }
        }
    }
    
    @objc func changeProfilePicTapped() {
        let alertController = UIAlertController(title: "Change profile picture", message: "Select an option below.", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "Camera roll", style: .default) { (action:UIAlertAction) in
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .photoLibrary
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let action2 = UIAlertAction(title: "Random default picture", style: .default) { (action:UIAlertAction) in
            self.profilePic.image = UIImage(named: "d\(Int.random(in: 1...36))")
            self.changedProfilePic = true
        }
        
        let action3 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            //do nothing
        }
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profilePic.contentMode = .scaleAspectFill
            self.profilePic.image = pickedImage
            self.changedProfilePic = true
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switchChanged(_ sender: Any) {
        let view = MessageView.viewFromNib(layout: .centeredView)
        view.configureTheme(.info)
        view.configureDropShadow()
        view.button?.isHidden = true
        view.configureContent(title: "Soon", body: "Profile privacy hasn't been shipped yet. Look out for it in a future update!", iconText:"🚢")
        view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        var config = SwiftMessages.Config()
        config.presentationStyle = .center
        config.duration = .seconds(seconds: 2)
        SwiftMessages.show(config: config, view: view)
    }
    
}

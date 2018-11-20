//
//  ChangeUsernameVC.swift
//  party
//
//  Created by John Leonardo on 11/20/18.
//  Copyright © 2018 John Leonardo. All rights reserved.
//

import UIKit
import Firebase
import SwiftMessages

class ChangeUsernameVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    
    var currentUsername: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        //text field delegate
        usernameField.delegate = self
        usernameField.addTarget(self, action: #selector(SignupStep3VC.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        //load current username
        if let uid = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(uid)
            userRef.getDocument { (snap, error) in
                if error != nil {
                    //error, handle
                    print(error?.localizedDescription)
                } else {
                    //set name and status of user's own account
                    let username = snap?.get("username") as! String
                    self.usernameField.text = "@" + username
                    self.currentUsername = username
                }
            }
        }
    }

    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        //insert @ symbol at the beginning of the string if none already
        if usernameField.text?.prefix(1) != "@" {
            usernameField.text?.insert("@", at: usernameField.text?.startIndex ?? "".startIndex)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if usernameField.text != "", let username = usernameField.text {
            if username.count <= 16 {
                var uname = username
                //strip the @ symbol
                uname.remove(at: uname.startIndex)
                if uname.isAlphanumeric {
                    if uname != "" {
                        uname = uname.lowercased()
                        let db = Firestore.firestore()
                        let usernameRef = db.collection("usernames").document(uname)
                        
                        usernameRef.getDocument { (document, error) in
                            if let document = document, document.exists {
                                //document exists, therefore, username IS taken
                                self.presentError(message: "@\(uname) is already taken.")
                            } else {
                                //document doesnt exist, therefore, username isnt taken
                                let currentUsernameRef = db.collection("usernames").document(self.currentUsername)
                                currentUsernameRef.delete(completion: { (error) in
                                    if error != nil {
                                        self.presentError(message: (error?.localizedDescription)!)
                                    } else {
                                        //change username references in database
                                        let uid = Auth.auth().currentUser?.uid
                                        usernameRef.setData(["userId": uid], completion: { (error) in
                                            if error != nil {
                                                self.presentError(message: "Something went wrong.")
                                            } else {
                                                let userRef = db.collection("users").document(uid!)
                                                userRef.setData(["username":uname], merge: true, completion: { (error) in
                                                    if error != nil {
                                                        self.presentError(message: "Something went wrong.")
                                                    } else {
                                                        //FINAL SUCCEsS
                                                        let view = MessageView.viewFromNib(layout: .centeredView)
                                                        view.configureTheme(.success)
                                                        view.configureDropShadow()
                                                        view.button?.isHidden = true
                                                        view.configureContent(title: "Username changed", body: "Username was successfully changed.", iconText:"👍")
                                                        view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
                                                        var config = SwiftMessages.Config()
                                                        config.presentationStyle = .center
                                                        config.duration = .seconds(seconds: 2)
                                                        SwiftMessages.show(config: config, view: view)
                                                        self.dismiss(animated: true, completion: nil)
                                                    }
                                                })
                                            }
                                        })
                                    }
                                })
                            }
                        }
                    } else {
                        //username is empty at this point for whatever reason
                        self.presentError(message: "Username can't be empty.")
                    }
                } else {
                    //username has special characters
                    self.presentError(message: "Username can't have any special characters.")
                }
            } else {
                //username is too long
                self.presentError(message: "Username can't be over 15 characters")
            }
        } else {
            //field is empty
            self.presentError(message: "Text field can't be empty.")
        }
        return true
    }
    
    //helper function to present error to user (uses SwiftMessages)
    func presentError(message: String) {
        // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
        // files in the main bundle first, so you can easily copy them into your project and make changes.
        let view = MessageView.viewFromNib(layout: .centeredView)
        
        // Theme message elements with the warning style.
        view.configureTheme(.error)
        
        // Add a drop shadow.
        view.configureDropShadow()
        
        view.button?.isHidden = true
        
        // Set message title, body, and icon. Here, we're overriding the default warning
        // image with an emoji character.
        view.configureContent(title: "Oops", body: message, iconText: "😞")
        
        // Increase the external margin around the card. In general, the effect of this setting
        // depends on how the given layout is constrained to the layout margins.
        view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        var config = SwiftMessages.Config()
        
        config.presentationStyle = .center
        config.duration = .seconds(seconds: 2)
        
        // Show the message.
        SwiftMessages.show(config: config, view: view)
    }
    
    
}

//
//  SignupStep4VC.swift
//  party
//
//  Created by John Leonardo on 11/18/18.
//  Copyright © 2018 John Leonardo. All rights reserved.
//

import UIKit
import Firebase
import SwiftMessages

class SignupStep4VC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var passwordField: UITextField!
    
    var name: String!
    var email: String!
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        passwordField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let password = passwordField.text {
            if password.count >= 8 {
                if password.count <= 60 {
                    Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                        if error != nil {
                            //error, handle
                            self.presentError(message: (error?.localizedDescription)!)
                        } else {
                            guard let user = authResult?.user else {
                                self.presentError(message: "Some error occurred.")
                                return
                            }
                            //user auth was successful, upload user document to database
                            let db = Firestore.firestore()
                            
                            //attempt to create new user document in firestore database
                            db.collection("users").document(user.uid).setData([
                                "name": self.name,
                                "username": self.username,
                                "following": 0,
                                "followers": 0,
                                "posts": 0
                            ]) { err in
                                if let err = err {
                                    self.presentError(message: err.localizedDescription)
                                } else {
                                    //success, now register username as taken
                                    db.collection("usernames").document(self.username).setData([
                                        "userId": user.uid
                                    ]) { err in
                                        if let err = err {
                                            self.presentError(message: err.localizedDescription)
                                        } else {
                                            //success, ALL FINISHED
                                            self.performSegue(withIdentifier: "goToMain", sender: nil)
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    //password too big
                    self.presentError(message: "Password can't be over 60 characters.")
                }
            } else {
                //password too short
                self.presentError(message: "Password must be at least 8 characters.")
            }
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

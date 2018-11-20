//
//  SignupStep3VC.swift
//  party
//
//  Created by John Leonardo on 11/18/18.
//  Copyright © 2018 John Leonardo. All rights reserved.
//

import UIKit
import SwiftMessages
import Firebase

class SignupStep3VC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    
    var name: String!
    var email: String!
    var u: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        usernameField.delegate = self
        usernameField.addTarget(self, action: #selector(SignupStep3VC.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
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
                                self.u = uname
                                self.performSegue(withIdentifier: "goToSignup4", sender: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSignup4" {
            let destination = segue.destination as! SignupStep4VC
            destination.email = self.email
            destination.name = self.name
            destination.username = self.u
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        //insert @ symbol at the beginning of the string if none already
        if usernameField.text?.prefix(1) != "@" {
            usernameField.text?.insert("@", at: usernameField.text?.startIndex ?? "".startIndex)
        }
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

extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}

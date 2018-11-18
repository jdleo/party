//
//  SignupStep2VC.swift
//  party
//
//  Created by John Leonardo on 11/18/18.
//  Copyright © 2018 John Leonardo. All rights reserved.
//

import UIKit
import SwiftMessages

class SignupStep2VC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailField: UITextField!
    
    var name: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        
        let nameChunk = name.components(separatedBy: " ")
        nameLbl.text = "Hi, \(nameChunk[0])😎"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailField.text != "", let email = emailField.text {
            if email.isValidEmail() {
                
            } else {
                //invalid email
                self.presentError(message: "Your email is invalid.")
            }
        } else {
            //is empty
            self.presentError(message: "Your email can't be empty.")
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
        view.configureContent(title: "Oops", body: message, iconText: "🤔")
        
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
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

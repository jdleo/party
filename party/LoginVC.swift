//
//  LoginVC.swift
//  party
//
//  Created by John Leonardo on 11/17/18.
//  Copyright © 2018 John Leonardo. All rights reserved.
//

import UIKit
import YXWaveView
import Firebase
import FirebaseAuth
import SwiftMessages

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //assign text field delegates to self
        emailField.delegate = self
        passwordField.delegate = self
        
        //style text fields
        emailField.layer.cornerRadius = 5.0
        emailField.layer.borderWidth = 2.0
        emailField.layer.borderColor = UIColor(red:0.17, green:0.13, blue:0.14, alpha:1.0).cgColor
        passwordField.layer.cornerRadius = 5.0
        passwordField.layer.borderWidth = 2.0
        passwordField.layer.borderColor = UIColor(red:0.17, green:0.13, blue:0.14, alpha:1.0).cgColor
        
        //style btns
        loginBtn.layer.cornerRadius = 5.0
        signupBtn.layer.cornerRadius = 5.0

        //set up wave view
        let frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 200)
        let waterView = YXWaveView(frame: frame, color: UIColor.white)
        let lbl = UILabel()
        lbl.textAlignment = .center //For center alignment
        lbl.text = "placeholder"
        lbl.textColor = .white
        lbl.font = UIFont(name:"Asap-BoldItalic",size:70)
        
        //to display multiple lines in label if needed
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        
        lbl.sizeToFit()//If required
        lbl.text = "Party"
        
        //add OverView
        waterView.addOverView(lbl)
        waterView.backgroundColor = UIColor(red:0.99, green:0.00, blue:0.33, alpha:1.0)
        waterView.waveHeight = 7
        self.view.addSubview(waterView)
        
        //start wave view
        waterView.start()
    }
    
    @IBAction func attemptLogin(_ sender: Any) {
        view.endEditing(true)
        
        if emailField.text != "" && passwordField.text != "" {
            Auth.auth().signIn(withEmail: emailField.text ?? "", password: passwordField.text ?? "") { (res, error) in
                if error != nil {
                    //error here, handle it
                    self.presentError(message: error?.localizedDescription ?? "An error has occurred.")
                } else {
                    //success, handle login
                    self.performSegue(withIdentifier: "goToMain0", sender: nil)
                }
            }
        } else {
            //one of the text fields is empty
        }
    }
    
    @IBAction func unwindToLogin(segue:UIStoryboardSegue) { }
    @IBAction func unwindToLogin2(segue:UIStoryboardSegue) { }
    
    @IBAction func attemptForgotPassword(_ sender: Any) {
        //trigger segue
        self.performSegue(withIdentifier: "goToForgotPassword", sender: nil)
    }
    
    @IBAction func attemptSignup(_ sender: Any) {
        self.performSegue(withIdentifier: "goToSignup", sender: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            emailField.resignFirstResponder()
            passwordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
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
        view.configureContent(title: "Error", body: message, iconText: "😭")
        
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

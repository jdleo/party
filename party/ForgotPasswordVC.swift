//
//  ForgotPasswordVC.swift
//  party
//
//  Created by John Leonardo on 11/19/18.
//  Copyright © 2018 John Leonardo. All rights reserved.
//

import UIKit
import Firebase
import SwiftMessages

class ForgotPasswordVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up email field delegate
        emailField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let email = emailField.text {
            //attempt password reset trigger with Firebase Auth
            Auth.auth().sendPasswordReset(withEmail: email) { (err) in
                if err != nil {
                    //handle error
                    let view = MessageView.viewFromNib(layout: .centeredView)
                    view.configureTheme(.error)
                    view.configureDropShadow()
                    view.button?.isHidden = true
                    view.configureContent(title: "Error", body: err?.localizedDescription ?? "Something went wrong.", iconText:"😭")
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
                    view.configureContent(title: "Success", body: "I sent a password reset link to your email!", iconText:"🎉")
                    view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
                    var config = SwiftMessages.Config()
                    config.presentationStyle = .center
                    config.duration = .seconds(seconds: 2)
                    SwiftMessages.show(config: config, view: view)
                }
            }
        }
        
        return true
    }

    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

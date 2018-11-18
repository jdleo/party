//
//  LoginVC.swift
//  party
//
//  Created by John Leonardo on 11/17/18.
//  Copyright © 2018 John Leonardo. All rights reserved.
//

import UIKit
import YXWaveView

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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            emailField.resignFirstResponder()
            passwordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

}

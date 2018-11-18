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
        let nameChunk = name.components(separatedBy: " ")
        name = nameChunk[0]
        nameLbl.text = "Hi, \(name ?? "friend")😎"
    }


}

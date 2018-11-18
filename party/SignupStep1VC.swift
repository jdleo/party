//
//  SignupStep1VC.swift
//  party
//
//  Created by John Leonardo on 11/18/18.
//  Copyright © 2018 John Leonardo. All rights reserved.
//

import UIKit
import SwiftMessages

class SignupStep1VC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        //set text field delegate
        nameField.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSignup2" {
            let destination = segue.destination as! SignupStep2VC
            destination.name = nameField.text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField.text != "", let name = textField.text {
            if name.characters.count <= 25 {
                self.performSegue(withIdentifier: "goToSignup2", sender: nil)
            } else {
                //text field too long
            }
        } else {
            //text field is empty
        }
        return true
    }

}

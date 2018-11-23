//
//  ComposePollVC.swift
//  party
//
//  Created by John Leonardo on 11/20/18.
//  Copyright © 2018 John Leonardo. All rights reserved.
//

import UIKit

class ComposePollVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var choice1textField: UITextField!
    @IBOutlet weak var choice2textField: UITextField!
    @IBOutlet weak var choice3textField: UITextField!
    @IBOutlet weak var choice4textField: UITextField!
    @IBOutlet weak var lengthSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set delegates
        titleTextField.delegate = self
        choice1textField.delegate = self
        choice2textField.delegate = self
        choice3textField.delegate = self
        choice4textField.delegate = self
        
        //style card view
        //cardView.layer.masksToBounds = true
        cardView.roundCorners([.topRight, .topLeft], radius: 20)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            titleTextField.resignFirstResponder()
            choice1textField.becomeFirstResponder()
        } else if textField == choice1textField {
            choice1textField.resignFirstResponder()
            choice2textField.becomeFirstResponder()
        } else if textField == choice2textField {
            choice2textField.resignFirstResponder()
            choice3textField.becomeFirstResponder()
        } else if textField == choice3textField {
            choice3textField.resignFirstResponder()
            choice4textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

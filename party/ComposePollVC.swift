//
//  ComposePollVC.swift
//  party
//
//  Created by John Leonardo on 11/20/18.
//  Copyright © 2018 John Leonardo. All rights reserved.
//

import UIKit
import Firebase
import SwiftMessages

class ComposePollVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var choice1textField: UITextField!
    @IBOutlet weak var choice2textField: UITextField!
    @IBOutlet weak var choice3textField: UITextField!
    @IBOutlet weak var choice4textField: UITextField!
    @IBOutlet weak var lengthSegment: UISegmentedControl!
    @IBOutlet weak var uploadBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tap gesture recognizer for view, to dismiss editing
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        self.view.addGestureRecognizer(tap)
        
        //target for textfieldchange
        titleTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        choice1textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        choice2textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        choice3textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        choice4textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        //hide upload btn by default
        uploadBtn.isHidden = true
        
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
    
    @objc func endEditing() {
        self.view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let title = titleTextField.text, let choice1 = choice1textField.text, let choice2 = choice2textField.text {
            if !title.trimmingCharacters(in: .whitespaces).isEmpty && !choice1.trimmingCharacters(in: .whitespaces).isEmpty && !choice2.trimmingCharacters(in: .whitespaces).isEmpty {
                uploadBtn.isHidden = false
            } else {
                uploadBtn.isHidden = true
            }
        } else {
            uploadBtn.isHidden = true
        }
    }
    
    //helper function to calculate future timestamps
    func future(timestamp: Timestamp, fromNow: Int) -> Timestamp {
        var seconds = timestamp.seconds
        
        if fromNow == 0 {
            //12h
            seconds += 43200
        } else if fromNow == 1 {
            //1d
            seconds += 86400
        } else if fromNow == 2 {
            //2d
            seconds += 172800
        } else if fromNow == 3 {
            //3d
            seconds += 259200
        } else if fromNow == 4 {
            //1w
            seconds += 604800
        }
        
        return Timestamp(seconds: seconds, nanoseconds: 0)
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func upload(_ sender: Any) {
        //empty choices array
        var choices: [String] = []
        
        if let choice1 = choice1textField.text, let choice2 = choice2textField.text, let title = titleTextField.text {
            //add first two choices (required)
            choices.append(choice1)
            choices.append(choice2)
            
            //check for choices 3 and 4 and add if needed
            if let choice3 = choice3textField.text {
                if !choice3.trimmingCharacters(in: .whitespaces).isEmpty {
                    choices.append(choice3)
                }
            }
            
            if let choice4 = choice4textField.text {
                if !choice4.trimmingCharacters(in: .whitespaces).isEmpty {
                    choices.append(choice4)
                }
            }
            
            //get reference to current user's uid
            if let uid = Auth.auth().currentUser?.uid {
                //create firestore db reference
                let db = Firestore.firestore()
                
                //get new write batch
                let batch = db.batch()
                
                //create reference to this user
                let userRef = db.collection("users").document(uid)
                
                //create reference to this user's posts
                let postRef = db.collection("posts").document(uid).collection("posts").document()
                
                //create reference to this user's polls
                let pollRef = db.collection("polls").document(uid).collection("polls").document()
                
                //get current time as Timestamp type
                let timestamp = Timestamp.init()
                
                //calculate ending time for poll
                let endingTimestamp = future(timestamp: timestamp, fromNow: lengthSegment.selectedSegmentIndex)
                
                //update status data in user document
                batch.setData(["status": "☑️ \(title)", "lastStatus": timestamp], forDocument: userRef, merge: true)
                
                //update poll data in user polls document
                batch.setData(["1": 0, "2": 0, "3": 0, "4": 0], forDocument: pollRef)
                
                //update post data in user posts document
                batch.setData([
                    "type": "poll",
                    "title": title,
                    "choices": choices,
                    "end_at": endingTimestamp,
                    "created_at": timestamp
                    ], forDocument: postRef)
                
                //commit batch to database
                batch.commit { (error) in
                    if error != nil {
                        //error, handle
                        self.presentError(message: error?.localizedDescription ?? "Something went wrong.")
                    } else {
                        let view = MessageView.viewFromNib(layout: .centeredView)
                        view.configureTheme(.success)
                        view.configureDropShadow()
                        view.button?.isHidden = true
                        view.configureContent(title: "Success", body: "Your poll was sent!", iconText:"🎉")
                        view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
                        var config = SwiftMessages.Config()
                        config.presentationStyle = .center
                        config.duration = .seconds(seconds: 2)
                        SwiftMessages.show(config: config, view: view)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    //helper function to present error
    func presentError(message: String) {
        let view = MessageView.viewFromNib(layout: .centeredView)
        view.configureTheme(.error)
        view.configureDropShadow()
        view.button?.isHidden = true
        view.configureContent(title: "Oops", body: message, iconText:"🙃")
        view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        var config = SwiftMessages.Config()
        config.presentationStyle = .center
        config.duration = .seconds(seconds: 2)
        SwiftMessages.show(config: config, view: view)
    }
    
}

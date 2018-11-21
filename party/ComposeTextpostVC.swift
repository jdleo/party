//
//  ComposeTextpostVC.swift
//  party
//
//  Created by John Leonardo on 11/20/18.
//  Copyright © 2018 John Leonardo. All rights reserved.
//

import UIKit

class ComposeTextpostVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textCountLbl: UILabel!
    @IBOutlet weak var constraintOutlet: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //to get keyboard height
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        //set text view delegate
        textView.delegate = self
        
        //placeholder stuff
        textView.text = "Start typing..."
        textView.textColor = UIColor.lightGray

        //style card view
        //cardView.layer.masksToBounds = true
        cardView.roundCorners([.topRight, .topLeft], radius: 20)
    }

    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        constraintOutlet.constant = 0
        textView.layoutIfNeeded()
        if textView.text.isEmpty {
            self.textCountLbl.text = "0/400"
            textView.text = "Start typing..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if self.textView.text.count <= 400 {
            //green
            self.textCountLbl.textColor = UIColor(red:0.30, green:0.69, blue:0.31, alpha:1.0)
        } else {
            //red
            self.textCountLbl.textColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
        }
        self.textCountLbl.text = "\(self.textView.text.count)/400"
    }
    
    /* Updated for Swift 4 */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        //resize bottom constraint to match keyboard height (to avoid text covering)
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            constraintOutlet.constant = keyboardHeight
            textView.layoutIfNeeded()
        }
    }
    
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
}

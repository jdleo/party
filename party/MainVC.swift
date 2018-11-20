//
//  MainVC.swift
//  party
//
//  Created by John Leonardo on 11/18/18.
//  Copyright © 2018 John Leonardo. All rights reserved.
//

import UIKit
import CircleMenu
import Firebase
import SwiftMessages

class MainVC: UIViewController, CircleMenuDelegate {
    
    @IBOutlet weak var topCard: UIView!
    @IBOutlet weak var tellAFriendBtn: UIButton!
    @IBOutlet weak var followPeopleBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var plusBtn: CircleMenu!
    @IBOutlet weak var menuBtn: CircleMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plusBtn.delegate = self
        menuBtn.delegate = self

        //style the top card
        topCard.layer.cornerRadius = 5.0
        topCard.dropShadow(scale: true)
        
        //style buttons
        tellAFriendBtn.layer.cornerRadius = 5.0
        followPeopleBtn.layer.cornerRadius = 5.0
        
        //style table view
        tableView.layer.cornerRadius = 5.0
        //tableView.dropShadow(scale: true)
        
        //force size constraints
        plusBtn.customNormalIconView?.frame.size = CGSize(width: 40, height: 40)
        plusBtn.customNormalIconView?.contentMode = .scaleAspectFit
        plusBtn.customSelectedIconView?.frame.size = CGSize(width: 40, height: 40)
        plusBtn.customSelectedIconView?.contentMode = .scaleAspectFit
        menuBtn.customNormalIconView?.frame.size = CGSize(width: 40, height: 40)
        menuBtn.customNormalIconView?.contentMode = .scaleAspectFit
        menuBtn.customSelectedIconView?.frame.size = CGSize(width: 40, height: 40)
        menuBtn.customSelectedIconView?.contentMode = .scaleAspectFit
        
    }
    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        if circleMenu.buttonsCount == 5 {
            //this is for menu button
            switch (atIndex) {
            case 0:
                button.setImage(UIImage(named: "home.png"), for: .normal)
                button.backgroundColor = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
                break
            case 1:
                button.setImage(UIImage(named: "logout.png"), for: .normal)
                button.backgroundColor = UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
                break
            case 2:
                button.setImage(UIImage(named: "settings.png"), for: .normal)
                button.backgroundColor = UIColor(red:0.30, green:0.69, blue:0.31, alpha:1.0)
                break
            case 3:
                button.setImage(UIImage(named: "inbox.png"), for: .normal)
                button.backgroundColor = UIColor(red:1.00, green:0.92, blue:0.23, alpha:1.0)
                break
            default:
                button.setImage(UIImage(named: "reactions.png"), for: .normal)
                button.backgroundColor = UIColor(red:1.00, green:0.34, blue:0.13, alpha:1.0)
                break
            }
        } else if circleMenu.buttonsCount == 6 {
            //this is for post button
        }
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        if circleMenu.buttonsCount == 5 {
            switch (atIndex) {
            case 4:
                //logout
                try! Auth.auth().signOut()
                let view = MessageView.viewFromNib(layout: .centeredView)
                view.configureTheme(.success)
                view.configureDropShadow()
                view.button?.isHidden = true
                view.configureContent(title: "Logged Out", body: "You have successfully logged out", iconText:"👍")
                view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
                var config = SwiftMessages.Config()
                config.presentationStyle = .center
                config.duration = .seconds(seconds: 2)
                SwiftMessages.show(config: config, view: view)
                self.dismiss(animated: true, completion: nil)
            default:
                break
            }
        } else if circleMenu.buttonsCount == 6 {
            //this is the post button
        }
    }
    

}

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 1
        
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

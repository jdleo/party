//
//  CrispVC.swift
//  party
//
//  Created by John Leonardo on 11/19/18.
//  Copyright © 2018 John Leonardo. All rights reserved.
//

import UIKit
import Crisp

class CrispVC: UIViewController {
    
    let crisp = CrispView()

    override func viewDidLoad() {
        super.viewDidLoad()

        //set up bounds for crisp chat
        crisp.center = view.center
        crisp.bounds = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width, height: view.frame.height - 150)
        view.addSubview(crisp)
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

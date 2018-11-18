//
//  LaunchVC.swift
//  party
//
//  Created by John Leonardo on 11/17/18.
//  Copyright © 2018 John Leonardo. All rights reserved.
//

import UIKit
import SAConfettiView

class LaunchVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //initialize confetti view & configure
        let confettiView = SAConfettiView(frame: self.view.bounds)
        self.view.addSubview(confettiView)
        confettiView.intensity = 0.75
        confettiView.startConfetti()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            confettiView.stopConfetti()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                //segue
                self.performSegue(withIdentifier: "goToLogin", sender: nil)
            }
        }
    }


}


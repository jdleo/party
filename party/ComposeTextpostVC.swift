//
//  ComposeTextpostVC.swift
//  party
//
//  Created by John Leonardo on 11/20/18.
//  Copyright © 2018 John Leonardo. All rights reserved.
//

import UIKit

class ComposeTextpostVC: UIViewController {
    
    @IBOutlet weak var cardView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //style card view
        //cardView.layer.masksToBounds = true
        cardView.roundCorners([.topRight, .topLeft], radius: 20)
    }

    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

//
//  PhotoPostCell.swift
//  party
//
//  Created by John Leonardo on 11/24/18.
//  Copyright © 2018 John Leonardo. All rights reserved.
//

import UIKit

class PhotoPostCell: UITableViewCell {
    
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    
    weak var delegate: PostCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //style photo w/ corner radius
        postImg.layer.cornerRadius = 10
        postImg.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func react1(_ sender: Any) {
        delegate?.react1(self)
    }
    
    @IBAction func react2(_ sender: Any) {
        delegate?.react2(self)
    }
    @IBAction func react3(_ sender: Any) {
        delegate?.react3(self)
    }
    @IBAction func react4(_ sender: Any) {
        delegate?.react4(self)
    }
    @IBAction func react5(_ sender: Any) {
        delegate?.react5(self)
    }
    @IBAction func react6(_ sender: Any) {
        delegate?.react6(self)
    }
}

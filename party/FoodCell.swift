//
//  FoodCell.swift
//  party
//
//  Created by John Leonardo on 11/23/18.
//  Copyright © 2018 John Leonardo. All rights reserved.
//

import UIKit

class FoodCell: UITableViewCell {
    
    @IBOutlet weak var businessImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ratingsImg: UIImageView!
    @IBOutlet weak var numRatingsLbl: UILabel!
    @IBOutlet weak var yelpImg: UIImageView!
    @IBOutlet weak var accessoryCardView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  SongPickCell.swift
//  party
//
//  Created by John Leonardo on 11/21/18.
//  Copyright © 2018 John Leonardo. All rights reserved.
//

import UIKit

class SongPickCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var albumImg: UIImageView!
    @IBOutlet weak var artistLbl: UILabel!
    @IBOutlet weak var trackLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        //style card view
        cardView.layer.cornerRadius = 10
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 1, height: 1)
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowRadius = 2.0
        
        //style album img
        albumImg.layer.cornerRadius = 10
        albumImg.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

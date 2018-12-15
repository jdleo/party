//
//  SongPostCell.swift
//  party
//
//  Created by John Leonardo on 11/24/18.
//  Copyright © 2018 John Leonardo. All rights reserved.
//

import UIKit

class SongPostCell: UITableViewCell {
    
    @IBOutlet weak var artistLbl: UILabel!
    @IBOutlet weak var trackLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var albumImg: UIImageView!
    
    var postId: String!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //style album img
        albumImg.layer.cornerRadius = 10
        albumImg.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

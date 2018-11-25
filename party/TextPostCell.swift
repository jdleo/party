//
//  TextPostCell.swift
//  party
//
//  Created by John Leonardo on 11/23/18.
//  Copyright © 2018 John Leonardo. All rights reserved.
//

import UIKit

protocol PostCellDelegate : class {
    func react1(_ sender: TextPostCell)
    func react2(_ sender: TextPostCell)
    func react3(_ sender: TextPostCell)
    func react4(_ sender: TextPostCell)
    func react5(_ sender: TextPostCell)
    func react6(_ sender: TextPostCell)
    
    func react1(_ sender: PhotoPostCell)
    func react2(_ sender: PhotoPostCell)
    func react3(_ sender: PhotoPostCell)
    func react4(_ sender: PhotoPostCell)
    func react5(_ sender: PhotoPostCell)
    func react6(_ sender: PhotoPostCell)
}

class TextPostCell: UITableViewCell {
    
    @IBOutlet weak var bodyLbl: UILabel!
    @IBOutlet weak var reactionBtn1: UIButton!
    @IBOutlet weak var reactionBtn2: UIButton!
    @IBOutlet weak var reactionBtn3: UIButton!
    @IBOutlet weak var reactionBtn4: UIButton!
    @IBOutlet weak var reactionBtn5: UIButton!
    @IBOutlet weak var reactionBtn6: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    weak var delegate: PostCellDelegate?
    
    var postId: String!

    override func awakeFromNib() {
        super.awakeFromNib()
        
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

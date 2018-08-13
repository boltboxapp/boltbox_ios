//
//  GSProfileTableViewCell.swift
//  Gigs
//
//  Created by dreams on 04/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var gBtnPicTapped: UIButton!
    @IBOutlet weak var gImgViewBckGrd: UIView!
    @IBOutlet weak var gImgViewProfile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

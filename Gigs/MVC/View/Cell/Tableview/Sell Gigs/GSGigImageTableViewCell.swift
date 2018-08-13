//
//  GSGigImageTableViewCell.swift
//  Gigs
//
//  Created by Dreamguys on 13/03/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSGigImageTableViewCell: UITableViewCell {

    @IBOutlet var gContainerView: UIView!
    @IBOutlet var gImgView: UIImageView!
    @IBOutlet var gBtnImage: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

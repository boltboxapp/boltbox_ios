//
//  GSTopBannerTableViewCell.swift
//  Gigs
//
//  Created by chandru on 12/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSTopBannerTableViewCell: UITableViewCell {

    @IBOutlet weak var gImgView: UIImageView!
    @IBOutlet weak var gContainerView: UIView!
    @IBOutlet var gBtnAddFavourites: MyFavButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

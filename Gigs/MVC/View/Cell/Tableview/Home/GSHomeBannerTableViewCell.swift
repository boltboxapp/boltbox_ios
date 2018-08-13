//
//  GSHomeBannerTableViewCell.swift
//  Gigs
//
//  Created by dreams on 09/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit
import GoogleMobileAds

class GSHomeBannerTableViewCell: UITableViewCell {

    @IBOutlet weak var gContainerView: GADBannerView!
    @IBOutlet var gContainerViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

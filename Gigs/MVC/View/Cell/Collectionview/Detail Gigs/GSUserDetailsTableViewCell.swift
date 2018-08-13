//
//  GSUserDetailsTableViewCell.swift
//  Gigs
//
//  Created by chandru on 12/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit
import AARatingBar

class GSUserDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var gLblName: UILabel!
    @IBOutlet weak var gLblType: UILabel!
    @IBOutlet weak var gRatingView: AARatingBar!
    @IBOutlet weak var gImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

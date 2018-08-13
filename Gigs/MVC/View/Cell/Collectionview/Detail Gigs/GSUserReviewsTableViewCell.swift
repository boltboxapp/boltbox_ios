//
//  GSUserReviewsTableViewCell.swift
//  Gigs
//
//  Created by chandru on 12/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit
import AARatingBar

class GSUserReviewsTableViewCell: UITableViewCell {

    @IBOutlet weak var gLblUserDetail: UILabel!
    @IBOutlet weak var gLblUserName: UILabel!
    @IBOutlet weak var gImgView: UIImageView!
    @IBOutlet weak var gViewRating: AARatingBar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

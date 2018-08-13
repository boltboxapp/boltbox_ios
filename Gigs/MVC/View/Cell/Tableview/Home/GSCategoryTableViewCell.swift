//
//  GSCategoryTableViewCell.swift
//  Gigs
//
//  Created by dreams on 10/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var gImgView: UIImageView!
    @IBOutlet weak var gLblCategory: UILabel!
    @IBOutlet weak var gLblSubCategory: UILabel!
    
    @IBOutlet weak var gConstraintCategpryTitleBottom: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

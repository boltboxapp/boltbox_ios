//
//  GSHomeHeaderTableViewCell.swift
//  Gigs
//
//  Created by dreams on 09/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSHomeHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var gLblHeader: UILabel!
    @IBOutlet weak var gBtnViewAll: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

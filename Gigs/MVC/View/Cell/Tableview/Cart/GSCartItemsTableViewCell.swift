//
//  GSCartItemsTableViewCell.swift
//  Gigs
//
//  Created by user on 19/03/2018.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSCartItemsTableViewCell: UITableViewCell {
    @IBOutlet weak var gLabelItemNo: UILabel!
    @IBOutlet weak var gLabelProductName: UILabel!
    @IBOutlet weak var gLabelQuantity: UILabel!
    
    @IBOutlet weak var gLabelTotal: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

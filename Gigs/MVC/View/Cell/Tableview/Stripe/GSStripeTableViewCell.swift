//
//  GSStripeTableViewCell.swift
//  Gigs
//
//  Created by user on 22/03/2018.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit
import Stripe
import FormTextField

class GSStripeTableViewCell: UITableViewCell {

    @IBOutlet weak var gLabelCardDetails: UILabel!
    @IBOutlet weak var gTextFieldCardDetails: FormTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

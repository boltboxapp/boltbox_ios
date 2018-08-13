//
//  GSPaymentCancelStripeTableViewCell.swift
//  Gigs
//
//  Created by Leo Chelliah on 04/07/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSPaymentCancelStripeTableViewCell: UITableViewCell {

    @IBOutlet weak var gContainerView: UIView!
    @IBOutlet weak var gLblTitle: UILabel!
    @IBOutlet weak var gTxtViewReason: UITextView!
    @IBOutlet weak var gLblReason: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

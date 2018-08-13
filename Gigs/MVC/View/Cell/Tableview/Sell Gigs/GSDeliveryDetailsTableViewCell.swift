//
//  GSDeliveryDetailsTableViewCell.swift
//  Gigs
//
//  Created by Dreamguys on 08/02/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSDeliveryDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var gTxtFldContent: UITextField!
    @IBOutlet weak var gTxtFldPrice: UITextField!
    @IBOutlet weak var gTxtFldDays: UITextField!
    @IBOutlet var deletegigsBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

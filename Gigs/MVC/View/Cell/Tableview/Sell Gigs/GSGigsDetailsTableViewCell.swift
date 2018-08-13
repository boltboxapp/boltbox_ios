//
//  GSGigsDetailsTableViewCell.swift
//  Gigs
//
//  Created by Dreamguys on 08/02/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSGigsDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var gTxtFldTitle: UITextField!
    @IBOutlet weak var gTxtFldDays: UITextField!
    @IBOutlet weak var gTxtFldCost: UITextField!
    @IBOutlet weak var gTxtViewGigDetails: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

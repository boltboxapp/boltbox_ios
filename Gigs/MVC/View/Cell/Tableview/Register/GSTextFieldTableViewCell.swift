//
//  GSTextFieldTableViewCell.swift
//  Gigs
//
//  Created by dreams on 04/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSTextFieldTableViewCell: UITableViewCell {

    @IBOutlet var gContainerView: UIView!
    @IBOutlet weak var gTxtFldRegister: UITextField!
    @IBOutlet var gLblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

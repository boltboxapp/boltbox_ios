//
//  GSTextViewTableViewCell.swift
//  Gigs
//
//  Created by Dreamguys on 21/03/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSTextViewTableViewCell: UITableViewCell {

    @IBOutlet var gContainerView: UIView!
    @IBOutlet var gTxtView: UITextView!
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

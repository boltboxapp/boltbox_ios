//
//  GSExtrasTableViewCell.swift
//  Gigs
//
//  Created by chandru on 12/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSExtrasTableViewCell: UITableViewCell {

    
    @IBOutlet weak var gViewContainer: UIView!
    @IBOutlet weak var gBtnCheckBox: UIButton!
    @IBOutlet weak var gLblFirst: UILabel!
    @IBOutlet weak var gLblMiddle: UILabel!
    @IBOutlet weak var gLblLast: UILabel!
    @IBOutlet var gBtnCheckBoxWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

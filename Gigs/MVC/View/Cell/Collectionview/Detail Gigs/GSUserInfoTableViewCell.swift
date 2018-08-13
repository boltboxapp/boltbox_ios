//
//  GSUserInfoTableViewCell.swift
//  Gigs
//
//  Created by chandru on 12/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSUserInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var gLblFirst: UILabel!
    @IBOutlet weak var gLblSecond: UILabel!
    @IBOutlet weak var gLblThird: UILabel!
    @IBOutlet weak var gLblFour: UILabel!
    @IBOutlet weak var gLblFive: UILabel!
    @IBOutlet weak var gLblSix: UILabel!
    @IBOutlet weak var gLblSeven: UILabel!
    @IBOutlet weak var gLblEight: UILabel!
    
    @IBOutlet var gLblFirstHeight: NSLayoutConstraint!
    @IBOutlet var gLblSecondHeight: NSLayoutConstraint!
    @IBOutlet var gLblFiveHeight: NSLayoutConstraint!
    @IBOutlet var gLblSixHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

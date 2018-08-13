//
//  GSSuperFastTableViewCell.swift
//  Gigs
//
//  Created by Dreamguys on 08/02/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSSuperFastTableViewCell: UITableViewCell {

    @IBOutlet weak var gTxtFldContent: UITextField!
    @IBOutlet weak var gTxtFldDays: UITextField!
    @IBOutlet weak var gTxtViewDescription: UITextView!
    
    @IBOutlet var gTxtFldAmount: UITextField!
    @IBOutlet var gBtnSuperfastCheck: UIButton!
    @IBOutlet var gBtnOnSiteCheck: UIButton!
    @IBOutlet var gBtnRemoteCheck: UIButton!
    @IBOutlet var superFastViewHeight: NSLayoutConstraint!
    @IBOutlet var gBtnSuperfastCheckHeight: NSLayoutConstraint!
    @IBOutlet var gLblSuperFastCheck: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

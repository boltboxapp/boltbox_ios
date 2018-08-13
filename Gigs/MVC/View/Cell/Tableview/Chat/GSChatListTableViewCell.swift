//
//  GSChatListTableViewCell.swift
//  Gigs
//
//  Created by Yosicare on 24/03/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSChatListTableViewCell: UITableViewCell {

    @IBOutlet weak var gViewContainer: UIView!
    @IBOutlet weak var gImgView: UIImageView!
    @IBOutlet weak var gLblDateAndTIme: UILabel!
    @IBOutlet weak var gLblTitle: UILabel!
    @IBOutlet weak var gLblDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//
//  GSChatReciverCollectionViewCell.swift
//  Gigs
//
//  Created by Yosicare on 23/04/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSChatReciverCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var gViewBubble: UIView!
    @IBOutlet weak var gLblMessage: UILabel!
    @IBOutlet weak var gViewContainer: UIView!
    @IBOutlet var gLblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

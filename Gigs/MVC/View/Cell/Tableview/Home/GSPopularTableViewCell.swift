//
//  GSPopularTableViewCell.swift
//  Gigs
//
//  Created by dreams on 10/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSPopularTableViewCell: UITableViewCell {

    @IBOutlet weak var gCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

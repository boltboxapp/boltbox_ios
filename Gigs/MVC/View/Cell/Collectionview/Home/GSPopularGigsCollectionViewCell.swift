//
//  GSPopularGigsCollectionViewCell.swift
//  Gigs
//
//  Created by dreams on 10/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSPopularGigsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var gView: UIView!
    @IBOutlet weak var gImgView: UIImageView!
    @IBOutlet weak var gLblTitle: UILabel!
    @IBOutlet weak var gLblReview: UILabel!
    @IBOutlet weak var gLblPrice: UILabel!
    @IBOutlet var gBtnFavourites: MyFavButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

class MyFavButton : UIButton {
    
    var row : Int?
    var section : Int?
    
}

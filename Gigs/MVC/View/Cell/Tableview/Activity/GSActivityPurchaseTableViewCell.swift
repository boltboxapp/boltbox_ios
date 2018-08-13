//
//  GSActivityPurchaseTableViewCell.swift
//  Gigs
//
//  Created by user on 04/04/2018.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSActivityPurchaseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gViewContainer: UIView!
    
    @IBOutlet weak var gImgViewGigImg: UIImageView!
    
    @IBOutlet weak var gLabelGigName: UILabel!
    
    @IBOutlet weak var gLabelGigTime: UILabel!
    
    @IBOutlet weak var gLabelGigPrice: UILabel!
    
    @IBOutlet weak var gLabelOrderId: UILabel!
    
    @IBOutlet weak var gLabelDeliveryDate: UILabel!
    
    @IBOutlet weak var gLabelSellerName: UILabel!
    
    @IBOutlet weak var gBtnPending: UIButton!
    
    @IBOutlet weak var gBtnCancel: UIButton!
    
    @IBOutlet weak var gBtnOrderStatus: UIButton!
    
    @IBOutlet weak var gViewPurchaseAndSales: UIView!
    
    @IBOutlet weak var gViewPaymentRequest: UIView!
    
    @IBOutlet weak var gBtnPaymentRequest: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  GSSellBackgroundViewController.swift
//  Gigs
//
//  Created by Dreamguys on 03/07/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSSellBackgroundViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
         self.tabBarController?.tabBar.isHidden = false

        let aview = GSSellViewController()
        self.navigationController?.pushViewController(aview, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

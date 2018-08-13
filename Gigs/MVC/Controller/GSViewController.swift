//
//  GSViewController.swift
//  Gigs
//
//  Created by Dreamguys on 16/03/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit
import Lottie

class GSViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animationView = LOTAnimationView(name: "servishero_loading")
        
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: (UIScreen.main.bounds.width - 200) / 2, y: (UIScreen.main.bounds.height - 200) / 2, width: 200, height: 200)
        
        self.view.addSubview(animationView)
//        animationView.play{ (finished) in
//            // Do Something
//        }

        animationView.play()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

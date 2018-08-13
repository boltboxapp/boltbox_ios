//
//  HelperViewController.swift
//  DriverUtilites
//
//  Created by Guru Prasad chelliah on 11/8/17.
//  Copyright © 2017 project. All rights reserved.
//

import UIKit

class HelperViewController: UIViewController {
    
    @IBOutlet var noData: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showNoData()  {
        
        print(noData)
        
        noData.alpha = 1.0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

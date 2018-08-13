//
//  GSPaymentViewController.swift
//  Gigs
//
//  Created by user on 09/06/2018.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSPaymentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var myTblview: UITableView!
    
    let cellIdentifier: String = "GSLeftMenuTableViewCell"
    
    var myAryRowInfo = [[String:String]]()
    
    let KMENUTITLE: String = "title"
    let KMENUIMAGENAME: String = "image_name"

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        setUpModel()
        loadModel()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI() {
        
        NAVIGAION.setNavigationTitle(aStrTitle: SCREEN_TITLE_PAYMENT_SETTINGS, aViewController: self)
        setUpLeftBarBackButton()
        
        myTblview.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)

        
//        myAryRowInfo = [[KMENUIMAGENAME: "icon_paypal_settings", KMENUTITLE:SCREEN_TITLE_PAYPAL_SETTINGS], [KMENUIMAGENAME: "icon_paypal_settings", KMENUTITLE:SCREEN_TITLE_STRIPE_SETTINGS]]
        
        myAryRowInfo = [[KMENUIMAGENAME: "icon_paypal_settings", KMENUTITLE:SCREEN_TITLE_STRIPE_SETTINGS]]
        
        myTblview.delegate = self
        myTblview.dataSource = self
    }

    func setUpModel() {
        
    }
    
    func loadModel() {
        
    }
    
    
    // MARK: - TableView delegate and datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myAryRowInfo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! GSLeftMenuTableViewCell
        aCell.gLblTitle.text = (myAryRowInfo[indexPath.row][KMENUTITLE])
        aCell.gImgView.image = UIImage(named: myAryRowInfo[indexPath.row][KMENUIMAGENAME]!)
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.myTblview.deselectRow(at: indexPath, animated: true)
        
        let strTitle = myAryRowInfo[indexPath.row][KMENUTITLE]
        
//        if strTitle == SCREEN_TITLE_PAYPAL_SETTINGS {
//
//            let aViewController = GSPaypalSettingsViewController()
//            self.navigationController?.pushViewController(aViewController, animated: true)
//        }
//        else if strTitle == SCREEN_TITLE_STRIPE_SETTINGS {
        
        if strTitle == SCREEN_TITLE_STRIPE_SETTINGS {
            
            let aViewController = GSStripeViewController()
            self.navigationController?.pushViewController(aViewController, animated: true)
        }
        
    }

   
    
    // MARK: - Left Bar Button Methods
    
    func setUpLeftBarBackButton() {
        
        let leftBtn = UIButton(type: .custom)
        leftBtn.setImage(UIImage(named: ICON_BACK), for: .normal)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        leftBtn.addTarget(self, action: #selector(questionBackBtnTapped), for: .touchUpInside)
        
        let leftBarBtnItem = UIBarButtonItem(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftBarBtnItem
    }
    
    @objc func questionBackBtnTapped() {
        
        self.navigationController?.popViewController(animated: true)
    }

}

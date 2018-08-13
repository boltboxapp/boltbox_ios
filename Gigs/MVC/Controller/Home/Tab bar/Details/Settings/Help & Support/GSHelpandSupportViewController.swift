//
//  GSHelpandSupportViewController.swift
//  Gigs
//
//  Created by Dreamguys on 22/03/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSHelpandSupportViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var myTblView: UITableView!
    
    var myAryResponse = [[String:Any]]()
    var myArySubMenu = [[String:Any]]()
    
    let cellIdentifier: String = "GSLeftMenuTableViewCell"
   // let cellHeaderIdentifier = "GSHomeHeaderTableViewCell"
    let cellSettingsHeaderIdentifier = "GSSettingsHeaderTableViewCell"
    
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
        
        NAVIGAION.setNavigationTitle(aStrTitle: SCREEN_TITLE_HELP_AND_SUPPORT, aViewController: self)
        setUpLeftBarBackButton()

        myTblView.delegate = self
        myTblView.dataSource = self
        
        myTblView.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
     //   myTblView.register(UINib.init(nibName: cellHeaderIdentifier, bundle: nil), forCellReuseIdentifier: cellHeaderIdentifier)
       // myTblView.register(UINib.init(nibName: cellSettingsHeaderIdentifier, bundle: nil), forCellReuseIdentifier: cellSettingsHeaderIdentifier)
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
        settingsApi()
    }
    
    // MARK: - TableView delegte and datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return myAryResponse.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let aAryInfo = self.myAryResponse[section]["sub_menu"] as! [[String:Any]]
        return myAryResponse[section]["is_expand"] as? String == "0" ?  0 : aAryInfo.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
       // let aCell:GSSettingsHeaderTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellSettingsHeaderIdentifier) as? GSSettingsHeaderTableViewCell
        
       // let aCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: cellSettingsHeaderIdentifier) as! GSSettingsHeaderTableViewCell

        var aCell:GSSettingsHeaderTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cellheader") as? GSSettingsHeaderTableViewCell
        
        if  (aCell == nil) {
            
            let nib:NSArray=Bundle.main.loadNibNamed("GSSettingsHeaderTableViewCell", owner: self, options: nil)! as NSArray
            aCell = nib.object(at: 0) as? GSSettingsHeaderTableViewCell
        }
        
        aCell?.backgroundColor = UIColor.clear
        
        aCell?.gLblTitle.text = myAryResponse[section]["main_menu"] as? String
        aCell?.gBtnTitle.tag = section
        
        aCell?.gBtnTitle.addTarget(self, action: #selector(self.viewHeaderBtnTapped(sender:)), for: .touchUpInside)
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        self.myArySubMenu = self.myAryResponse[indexPath.section]["sub_menu"] as! [[String:Any]]
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! GSLeftMenuTableViewCell
        aCell.gLblTitle.text = myArySubMenu[indexPath.row]["title"] as? String
        return aCell
    }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
             let aAryInfo = self.myAryResponse[indexPath.section]["sub_menu"] as! [[String:Any]]
            
            self.myTblView.deselectRow(at: indexPath, animated: true)
            
            let aViewController = GSFAQsViewController()
            aViewController.gStrTitle = aAryInfo[indexPath.row]["title"] as! String
            aViewController.gStrContent = aAryInfo[indexPath.row]["page_desc"] as! String
            self.navigationController?.pushViewController(aViewController, animated: true)
            
        }
    
    // MARK:- Api
    
    func settingsApi() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "Help & Support..")
        
        HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL+CASE_SETTINGS, sucessBlock: {response in

//        HTTPMANAGER.settingsRequest(sucessblock: {response in
            
            HELPER.hideLoadingAnimation()
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                self.myAryResponse = response["primary"] as! [[String:Any]]
                
                self.myTblView.reloadData()
            } else {
                
                HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse, okActionBlock: { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    // MARK:- Left Bar Button Methods
    
    @objc func viewHeaderBtnTapped(sender: UIButton) {
        
        print(sender.tag)
        
        var aDictInfo = self.myAryResponse[sender.tag]

        print(aDictInfo)
        
        let aStr = aDictInfo["is_expand"] as! String
        
        aDictInfo["is_expand"] = aStr == "0" ? "1" : "0"
        
        myAryResponse[sender.tag] = aDictInfo
        
        print(self.myAryResponse)

        myTblView.reloadSections(NSIndexSet(index: sender.tag) as IndexSet, with: .none)
        myTblView.reloadData()
    }
    
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


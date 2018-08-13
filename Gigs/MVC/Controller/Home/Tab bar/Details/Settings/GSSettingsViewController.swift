//
//  GSSettingsViewController.swift
//  Gigs
//
//  Created by dreams on 08/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSSettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var myAryRowInfo = [[String:String]]()
    
    var myDictResponse = [[String:String]]()
    
    let KMENUTITLE: String = "title"
    let KMENUIMAGENAME: String = "image_name"
    
    var myStrFAQ = String()
    var myStrAbout = String()
    
    let cellIdentifier: String = "GSLeftMenuTableViewCell"
    
    @IBOutlet var myTblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpModel()
        loadModel()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = SCREEN_TITLE_SETTINGS
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI() {
        
        HELPER.setUpLeftBarBackButton(fromVc: self)
//        NAVIGAION.setNavigationTitle(aStrTitle: SCREEN_TITLE_SETTINGS, aViewController: self)
//        self.navigationController?.navigationBar.topItem?.title = SCREEN_TITLE_SETTINGS

        myTblView.delegate = self
        myTblView.dataSource = self
        
        myTblView.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        myAryRowInfo = [[KMENUIMAGENAME: "icon_change_password", KMENUTITLE:SCREEN_TITLE_CHANGE_PASSWORD], [KMENUIMAGENAME: "icon_edit_profile", KMENUTITLE:SCREEN_TITLE_EDIT_PROFILE], [KMENUIMAGENAME: "icon_paypal_settings", KMENUTITLE:SCREEN_TITLE_PAYMENT_SETTINGS], [KMENUIMAGENAME: "icon_help_support", KMENUTITLE:SCREEN_TITLE_HELP_AND_SUPPORT],[KMENUIMAGENAME: "icon_logout", KMENUTITLE:SCREEN_TITLE_LOGOUT]]
        
        //[KMENUIMAGENAME: "icon_settings", KMENUTITLE:SCREEN_TITLE_FAQS], [KMENUIMAGENAME: "icon_settings", KMENUTITLE:SCREEN_TITLE_ABOUT],
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
        
        self.myTblView.deselectRow(at: indexPath, animated: true)
        
        let strTitle = myAryRowInfo[indexPath.row][KMENUTITLE]
        
        if strTitle == SCREEN_TITLE_CHANGE_PASSWORD {
            
            let aViewController = GSChangePasswordViewController()
            self.navigationController?.pushViewController(aViewController, animated: true)
        }
            
        else if strTitle == SCREEN_TITLE_EDIT_PROFILE {
            
            let aViewController = GSEditProfileViewController()
            self.navigationController?.pushViewController(aViewController, animated: true)
        }
            
        else if strTitle == SCREEN_TITLE_PAYMENT_SETTINGS {
            
            let aViewController = GSPaymentViewController()
            self.navigationController?.pushViewController(aViewController, animated: true)
        }
            
        else if strTitle == SCREEN_TITLE_HELP_AND_SUPPORT {
            
            let aViewController = GSHelpandSupportViewController()
            self.navigationController?.pushViewController(aViewController, animated: true)
        }
            
            //        else if strTitle == SCREEN_TITLE_FAQS {
            //
            //            let aViewController = GSFAQsViewController()
            //            aViewController.gStrTitle = myDictResponse[0]["title"]!
            //            aViewController.gStrContent = myDictResponse[0]["page_desc"]!
            //            self.navigationController?.pushViewController(aViewController, animated: true)
            //        }
            //
            //        else if strTitle == SCREEN_TITLE_ABOUT {
            //
            //            let aViewController = GSFAQsViewController()
            //            aViewController.gStrTitle = myDictResponse[2]["title"]!
            //            aViewController.gStrContent = myDictResponse[2]["page_desc"]!
            //            self.navigationController?.pushViewController(aViewController, animated: true)
            //        }
            
        else if strTitle == SCREEN_TITLE_LOGOUT {
            
            
            HELPER.showAlertControllerIn(aViewController: self, aStrMessage: "Do you want to log out ?", okButtonTitle: "Yes", cancelBtnTitle: "No", okActionBlock: { (sucessAction) in
                
                self.callLogOut()
                
//                SESSION.setIsUserLogIN(isLogin: false)
//                SESSION.setUserImage(aStrUserImage: "")
//                SESSION.setUserPriceOption(option: "", price: "", extraprice: "")
//                SESSION.setUserId(aStrUserId: "")
//                APPDELEGATE.loadLogInSceen()
                
            }, cancelActionBlock: { (cancelAction) in
                
            })
        }
    }
    
    func callLogOut() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingViewAnimation(viewController: self)
        
        HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL+CASE_LOGOUT, sucessBlock: {response in
            
            //        HTTPMANAGER.categoryListRequest(sucessblock: {response in
            
            HELPER.hideLoadingAnimation(viewController: self)
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                SESSION.setIsUserLogIN(isLogin: false)
                SESSION.setUserImage(aStrUserImage: "")
                SESSION.setUserPriceOption(option: "", price: "", extraprice: "")
                SESSION.setUserId(aStrUserId: "")
                APPDELEGATE.loadLogInSceen()
            }
            else if aIntResponseCode == RESPONSE_CODE_498 {
                
                HELPER.showAlertControllerWithOkActionBlock(aViewController: (APPDELEGATE.window?.rootViewController)!, aStrMessage: aMessageResponse, okActionBlock: { (action) in
                    
                    SESSION.setIsUserLogIN(isLogin: false)
                    SESSION.setUserImage(aStrUserImage: "")
                    SESSION.setUserPriceOption(option: "", price: "", extraprice: "")
                    SESSION.setUserId(aStrUserId: "")
                    APPDELEGATE.loadLogInSceen()
                    
                })
            }
            else {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation(viewController: self)
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
}

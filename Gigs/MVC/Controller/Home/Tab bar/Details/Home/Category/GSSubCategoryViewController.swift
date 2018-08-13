//
//  GSSubCategoryViewController.swift
//  Gigs
//
//  Created by dreams on 19/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSSubCategoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var myTblView: UITableView!
    
    typealias CompletionBlock = (String?,String?) -> Void
    var completion: CompletionBlock = { reason,reason1  in print(reason ?? false) }
    
    var myAryInfo = [[String:Any]]()
    var gAryInfo = [[String:Any]]()
    
    var gStrCategoryId = String()
    var gStrCategoryName = String()
    
    var isfromhome = false
    
    let cellCategoryIdentifier = "GSCategoryListTableViewCell"
    
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
        
        NAVIGAION.setNavigationTitle(aStrTitle: gStrCategoryName, aViewController: self)
        setUpLeftBarBackButton()
        
        myTblView.delegate = self
        myTblView.dataSource = self

        myTblView.tableFooterView = UIView()
        
        myTblView.register(UINib.init(nibName: cellCategoryIdentifier, bundle: nil), forCellReuseIdentifier: cellCategoryIdentifier)
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
        callSubCategoryList()
    }
    
    // MARK: - TableView Delegate adn Datasource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return myAryInfo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if isfromhome == true {
            let aViewcontroller = GSViewAllGigsViewController()
            aViewcontroller.gIsCategoryAll = true
            aViewcontroller.gStrCategoryId = myAryInfo[indexPath.row]["cid"] as! String
            aViewcontroller.gStrCategoryName = myAryInfo[indexPath.row]["name"] as! String

//        print(myAryInfo[indexPath.row]["cid"] as! String)
        
            self.navigationController?.pushViewController(aViewcontroller, animated: true)
        }
        else {
            gStrCategoryId = myAryInfo[indexPath.row]["cid"] as! String
            gStrCategoryName = myAryInfo[indexPath.row]["name"] as! String
            
            let controllers =  self.navigationController?.viewControllers
            var isHaveSearchScreen = false
            var isHaveSellScreen = false
             myStrCategoryNameForSell = gStrCategoryName
            myStrCategoryId = gStrCategoryId
            for vc in controllers! {
                if vc.isKind(of: GSSearchViewController.self) {
                    isHaveSearchScreen = true
                    let viewc = vc as! GSSearchViewController
                    viewc.myStrCategoryId = gStrCategoryId
                    viewc.myStrCategory = gStrCategoryName
                    self.navigationController?.popToRootViewController(animated: true)
                }
                else if vc.isKind(of: GSSellViewController.self) {
                    isHaveSellScreen = true
                    let viewc = vc as! GSSellViewController
                    myStrCategoryId = gStrCategoryId
                    myStrCategoryNameForSell = gStrCategoryName
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
            if isHaveSearchScreen == false {
                self.navigationController?.popToRootViewController(animated: true)

            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: cellCategoryIdentifier, for: indexPath) as! GSCategoryListTableViewCell
        aCell.gLblList.text = (self.myAryInfo[indexPath.row]["name"]! as! String)
        return aCell
    }

    
    // MARK: - Api Call
    
    func callSubCategoryList() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingViewAnimation(viewController: self)
        
        var dictParameters = [String:String]()
        dictParameters[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
        dictParameters[kDEVICE_CATEGORY_iD] = gStrCategoryId //"29"
        //        dictParameters[K_USER_ID] = "1"
        //        dictParameters[K_SUB_CATEGORY_ID] = ""
        dictParameters[kDEVICE_VIEWALL] = kDEVICE_VIEWALL_SERVICES
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_HOME_VIEWALL_GIGS, dictParameters: dictParameters, sucessBlock: { (response) in
        
//        HTTPMANAGER.subCategoryListRequest(subCategoryId: gStrCategoryId, sucessblock: {response in
        
            HELPER.hideLoadingAnimation(viewController: self)
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                var dict  = response["data"] as! [String : Any]
                self.myAryInfo = dict["category_details"] as! [[String : Any]]
                
                self.myTblView.reloadData()
            }
            else {
                
                if self.myAryInfo.count == 0 {
                    
                    HELPER.showNoDataWithRetryAlert(viewController: self, alertMessage: ALERT_NO_RECORDS_FOUND, retryBlock: {
                        
                        self.callSubCategoryList()
                    })
                }
                
                else {
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
                }
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation(viewController: self)
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    
    // MARK : - Left Bar Button Methods
    
    func setUpLeftBarBackButton() {
        
        let leftBtn = UIButton(type: .custom)
        leftBtn.setImage(UIImage(named: ICON_BACK), for: .normal)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        leftBtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        
        let leftBarBtnItem = UIBarButtonItem(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftBarBtnItem
    }
    
    @objc func backBtnTapped() {
        
        self.navigationController?.popViewController(animated: true)
    }
}

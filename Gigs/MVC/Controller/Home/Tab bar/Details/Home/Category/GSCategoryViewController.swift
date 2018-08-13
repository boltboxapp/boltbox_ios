//
//  GSCategoryViewController.swift
//  Gigs
//
//  Created by dreams on 19/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSCategoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var myTblView: UITableView!
    
    var myAryInfo = [[String:Any]]()
    
    var isClickSubCategory:Bool!
    var isCategoryView:Bool!
    
    var gStrCategoryId = String()
    
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
        
        NAVIGAION.setNavigationTitle(aStrTitle: SCREEN_TITLE_CATEGORY, aViewController: self)
        setUpLeftBarBackButton()
        
        myTblView.delegate = self
        myTblView.dataSource = self
        
        myTblView.register(UINib.init(nibName: cellCategoryIdentifier, bundle: nil), forCellReuseIdentifier: cellCategoryIdentifier)
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
        callCategoryList()
    }
    
    // MARK: - TableView Delegate and Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myAryInfo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if myAryInfo[indexPath.row]["subcategory"]as? String == "0" {
            
            let aViewcontroller = GSViewAllGigsViewController()
            aViewcontroller.gIsCategoryAll = true
            aViewcontroller.gStrCategoryId = myAryInfo[indexPath.row]["cid"] as! String
            aViewcontroller.gStrCategoryName = myAryInfo[indexPath.row]["name"] as! String
            self.navigationController?.pushViewController(aViewcontroller, animated: true)
            
        } else if myAryInfo[indexPath.row]["subcategory"]as? String == "1" {
            
            let aViewcontroller = GSSubCategoryViewController()
            aViewcontroller.gStrCategoryId = myAryInfo[indexPath.row]["cid"] as! String
            aViewcontroller.gStrCategoryName = myAryInfo[indexPath.row]["name"] as! String
            aViewcontroller.isfromhome = true
            self.navigationController?.pushViewController(aViewcontroller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: cellCategoryIdentifier, for: indexPath) as! GSCategoryListTableViewCell
        aCell.gLblList.text = (self.myAryInfo[indexPath.row]["name"]! as! String)
        return aCell
    }
    
    // MARK: - Api Call
    
    func callCategoryList() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingViewAnimation(viewController: self)
        
        HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL+CASE_HOME_VIEWALL_GIGS, sucessBlock: {response in
        
//        HTTPMANAGER.categoryListRequest(sucessblock: {response in
            
            HELPER.hideLoadingAnimation(viewController: self)
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                self.myAryInfo = response["primary"] as! [[String : Any]] as! [[String : String]]
                
                self.myTblView.reloadData()
            }
            else {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
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

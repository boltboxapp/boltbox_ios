//
//  GSViewAllReviewsViewController.swift
//  Gigs
//
//  Created by dreams on 13/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSViewAllReviewsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var myTblView: UITableView!
    
    let cellUserReviewIdentifier = "GSUserReviewsTableViewCell"
    
    var gStrPaginationIndex = 1
    var isLazyLoading:Bool!
    
    let cellLazyLoadingIdentifier = "LazyLoadingTableViewCell"
    
    var myStrPagewNumber = "1"
    var myIntPagewNumber:Int = 1
    var myIntTotalPage = Int()
    
    var gStrGigId = String()
    
    var gAryInfo = [[String:String]]()
    
    var myAryInfo = [[String:String]]()
    
    var isLoadMoreStart:Bool!
    
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
    
    func setUpUI(){
        
        NAVIGAION.setNavigationTitle(aStrTitle: SCREEN_TITLE_REVIEWS, aViewController: self)
        setUpLeftBarBackButton()
        
        myTblView.delegate = self
        myTblView.dataSource = self
        
        myTblView.tableFooterView = UIView()
        
        myTblView.register(UINib.init(nibName: cellUserReviewIdentifier, bundle: nil), forCellReuseIdentifier: cellUserReviewIdentifier)
        myTblView.register(UINib.init(nibName: cellLazyLoadingIdentifier, bundle: nil), forCellReuseIdentifier: cellLazyLoadingIdentifier)

    }
    
    func setUpModel(){
        
    }
    
    func loadModel(){
        
        getMessagesFromApi()
    }
    
    // MARK: - Table View Delegate and Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myAryInfo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let myAryInfo = gAryInfo
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: cellUserReviewIdentifier, for: indexPath) as! GSUserReviewsTableViewCell
        aCell.gLblUserName.text = myAryInfo[indexPath.row]["buyername"]
        aCell.gLblUserDetail.text = myAryInfo[indexPath.row]["comment"]
        
        let aStrProfileImage = myAryInfo[indexPath.row]["profile_img"]
        
        HELPER.setRoundCornerView(aView: aCell.gImgView)
        aCell.gImgView.sd_setImage(with: URL(string:SESSION.getBaseImageUrl() + aStrProfileImage!), placeholderImage: UIImage(named: IMG_PROFILE_PLACEHOLDER))
        
        let result = (myAryInfo[indexPath.row]["rating"]! as NSString).floatValue
        aCell.gViewRating.isUserInteractionEnabled = false
        aCell.gViewRating.maxValue = 5
        aCell.gViewRating.value = CGFloat(result)
        
        return aCell
    }
    
    // MARK: - Api Call
    func getMessagesFromApi() {
        
        if !HELPER.isConnectedToNetwork() {
            
            self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_NO_INTERNET)
            return
        }
        
        var dictLoginCrediental = [String:String]()
        dictLoginCrediental["page"] = String(gStrPaginationIndex)
        dictLoginCrediental[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
        dictLoginCrediental["gig_id"] = gStrGigId
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_VIEWALL_BUYER_REVIEWS, dictParameters: dictLoginCrediental, sucessBlock: { (response) in
            
            //        HTTPMANAGER.getChatList(parameter: dictGetComments, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation(viewController: self)
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
           
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                self.myAryInfo = response["data"] as! [[String:String]]
                self.myTblView.reloadData()
            }
            else {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
            self.myTblView.reloadData()
            
        }, failureBlock: { error in
            
            self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_SERVER_ERROR)
        })
    }
    
    
    func handleNodataAndErrorMessage(alertType:String) {
        
        HELPER.hideLoadingAnimation(viewController: self)
        
        let alertType = alertType
        
        if alertType == ALERT_TYPE_NO_INTERNET {
            
            if myAryInfo.count != 0 {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            }
                
            else {
                
                HELPER.showNetworkWithRetryAlert(viewController: self,alertMessage:ALERT_NO_INTERNET_DESC, retryBlock: {
                    
                    HELPER.removeNetworlAlertIn(viewController: self)
                    self.getMessagesFromApi()
                })
            }
        }
            
        else if alertType == ALERT_TYPE_NO_DATA {
            
            if myAryInfo.count == 0 {
                
                HELPER.showNoDataWithRetryAlert(viewController: self,alertMessage:ALERT_NO_RECORDS_FOUND, retryBlock: {
                    
                    HELPER.removeNetworlAlertIn(viewController: self)
                    self.getMessagesFromApi()
                })
            }
        }
            
        else if alertType == ALERT_TYPE_SERVER_ERROR {
            
            if myAryInfo.count != 0 {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_UNABLE_TO_REACH_DESC)
            }
                
            else {
                
                HELPER.showNetworkWithRetryAlert(viewController: self,alertMessage:ALERT_UNABLE_TO_REACH_DESC, retryBlock: {
                    
                    HELPER.removeNetworlAlertIn(viewController: self)
                    self.getMessagesFromApi()
                })
            }
        }
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

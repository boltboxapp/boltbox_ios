//
//  GSChatListViewController.swift
//  Gigs
//
//  Created by Yosicare on 24/03/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSChatListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTblView: UITableView!
    var myAryInfo = [[String:String]]()

    var isLazyLoading:Bool!
    var isLoadMoreStart:Bool!
    
    let cellIdentifierList = "GSChatListTableViewCell"
    let cellLazyLoadingIdentifier = "LazyLoadingTableViewCell"
    
    var myIntTotalPage = Int()
    var myStrPagewNumber = "1"
    var myIntPagewNumber:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpUI()
        setUpModel()
        loadModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.topItem?.title = SCREEN_TITLE_CHAT
        
    }
    
    // MARK: - View Initailize

    func setUpUI() {
        NAVIGAION.setNavigationTitle(aStrTitle: SCREEN_TITLE_CHAT, aViewController: self)
        //self.navigationController?.navigationBar.topItem?.title = SCREEN_TITLE_CHAT
        myTblView.register(UINib.init(nibName: cellIdentifierList, bundle: nil), forCellReuseIdentifier: cellIdentifierList)
        myTblView.register(UINib.init(nibName: cellLazyLoadingIdentifier, bundle: nil), forCellReuseIdentifier: cellLazyLoadingIdentifier)
        
        myTblView.tableFooterView = UIView()
    }
    
    func setUpModel() {
        
        isLazyLoading = true
    }
    
    func loadModel() {
        
        getMessagesFromApi()
    }
    
    // MARK: - Table view delegate and data source

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return myAryInfo.count != 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myAryInfo.count + (isLazyLoading ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row >= myAryInfo.count {
            
            return 50
        }
            
        else {
            
            return  80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row >= myAryInfo.count {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellLazyLoadingIdentifier, for: indexPath) as! LazyLoadingTableViewCell
            
            aCell.gActivityIndicator.startAnimating()
            
            return aCell
        }
            
        else {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierList, for: indexPath) as! GSChatListTableViewCell
            
            aCell.gLblTitle.text = self.myAryInfo[indexPath.row]["firstname"]
            aCell.gLblDescription.text = self.myAryInfo[indexPath.row]["last_message"]
           
            aCell.gLblDateAndTIme.text = (HELPER.timeAgoSinceDate(date: HELPER.convertStringFormatToDate(inputString: self.myAryInfo[indexPath.row]["utc_time"]!) as NSDate, numericDates: false))
            
            HELPER.setRoundCornerView(aView: aCell.gImgView)
            
            aCell.gImgView.setShowActivityIndicator(true)
            aCell.gImgView.setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
            
            aCell.gImgView.sd_setImage(with: URL(string: SESSION.getBaseImageUrl() + myAryInfo[indexPath.row]["profile_image"]!), placeholderImage: UIImage(named: IMG_PROFILE_PLACEHOLDER) )
            
            return aCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let aViewController = GSChatDetailsViewController()
        aViewController.gStrToUserId = myAryInfo[indexPath.row]["user_id"]!
        aViewController.gStrUserName = myAryInfo[indexPath.row]["firstname"]!
        self.navigationController?.pushViewController(aViewController, animated: true)
    }
    
    // MARK: - Scroll view delegate and data source

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffsetMaxY: Float = Float(scrollView.contentOffset.y + scrollView.bounds.size.height)
        let contentHeight: Float = Float(scrollView.contentSize.height)
        
        let ret = contentOffsetMaxY > contentHeight
        if ret {
            print("testButton is show");
            
            if isLazyLoading {
                isLazyLoading = false
                loadMore()
            }
            
        }else{
            print("testButton is hidden");
        }
    }
    
    func loadMore() {
        
        getMessagesFromApi()
    }
    
    func getMessagesFromApi() {
        
        if !HELPER.isConnectedToNetwork() {
            
            self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_NO_INTERNET)
            return
        }
        
        var dictGetComments = [String:String]()
        
        dictGetComments = ["user_id":SESSION.getUserId(),"page":myStrPagewNumber]
        
        HELPER.showLoadingViewAnimation(viewController: self)
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_CHAT_LIST, dictParameters: dictGetComments, sucessBlock: { (response) in

//        HTTPMANAGER.getChatList(parameter: dictGetComments, sucessBlock: { response in

            HELPER.hideLoadingAnimation(viewController: self)
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            var aDictResponseInfo = [String:Any]()
            
            aDictResponseInfo = response["data"] as! [String:Any]
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                self.myIntTotalPage = aDictResponseInfo["total_pages"] as! Int
                
                if self.myIntTotalPage == 0 {
                    
                    self.isLazyLoading = false
                }
                
                else {
                    
                    self.isLazyLoading = self.myIntTotalPage == self.myIntPagewNumber ? false : true
                    
                    self.myIntPagewNumber = self.myIntPagewNumber + 1
                    self.myStrPagewNumber = String(describing: self.myIntPagewNumber)
                    
                    if self.myAryInfo.count == 0 {
                        
                        self.myAryInfo = aDictResponseInfo["chat_details"] as! [[String : String]]
                        self.myTblView.reloadData()
                    }
                    else {
                        
                        for dictInfo in aDictResponseInfo["chat_details"] as! [[String : String]] {
                            self.myAryInfo.append(dictInfo)
                        }
                    }
                }
                
                self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_NO_DATA)
            }
                
            else {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
            self.isLoadMoreStart = false
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
}

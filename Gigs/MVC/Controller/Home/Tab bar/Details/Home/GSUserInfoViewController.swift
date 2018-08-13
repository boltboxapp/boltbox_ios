//
//  GSUserInfoViewController.swift
//  Gigs
//
//  Created by Dreamguys on 27/03/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSUserInfoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    
    @IBOutlet var myTblView: UITableView!
    @IBOutlet var myBtnContact: UIButton!
    @IBOutlet var myContactContainerView: UIView!
    @IBOutlet var myContactTextView: UITextView!
    @IBOutlet var myContactSendButton: UIButton!
    @IBOutlet var myTableContainerView: UIView!
    @IBOutlet var myBtnContactClose: UIButton!
    
    let cellUserInfoIdentifier = "GSUserInfoTableViewCell"
    let cellUserDetailsIdentifier = "GSUserDetailsTableViewCell"
    let cellUserReviewIdentifier = "GSUserReviewsTableViewCell"
    let cellHeaderIdentifier = "GSHomeHeaderTableViewCell"

    var gStrTitle = String()
    var gStrPaginationIndex = 1
    var gAryInfo = [[String:Any]]()
    var gAryReviewInfo = [[String:Any]]()
    var userInfo = [[String:Any]]()
    var userProfileInfo = [[String:Any]]()
    
    var gStrContacttext = String()
    
    var isLazyLoading:Bool!

    let cellLazyLoadingIdentifier = "LazyLoadingTableViewCell"

    var myStrPagewNumber = "1"
    var myIntPagewNumber:Int = 1
    var myIntTotalPage = Int()
    
    var myDictReviewInfo = [String:Any]()
    
    var needToUpdate = false
    
    let K_TITLE = "title"
    let K_TITLE_BANNER = "Banner"
    let K_TITLE_PROFILE = "Profile"
    let K_TITLE_DESCRIPTION = "Description"
    let K_TITLE_USER_INFO = "User Information"
    let K_TITLE_EXTRA_GIGS = "Extra Gigs"
    let K_TITLE_SIMILAR_GIGS = "Similar Gigs"
    let K_TITLE_REVIEWS = "Reviews"
    
    let K_TITLE_CATEGORY = "Top Category"
    let K_TITLE_POPULAR_GIGS = "Popular Gigs"
    let K_TITLE_RECENT_GIGS = "Recent Gigs"
    let K_ARRAYINFO = "aryinfo"
    
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
        
        setUpLeftBarBackButton()
        HELPER.setRoundCornerView(aView: myContactContainerView, borderRadius: 4)
        HELPER.setBorderView(aView: myContactContainerView, borderWidth: 4, borderColor: UIColor.clear, cornerRadius: 12)
        myContactContainerView.isHidden = true
        NAVIGAION.setNavigationTitle(aStrTitle: gStrTitle, aViewController: self)
        
        HELPER.setBorderView(aView: myContactTextView, borderWidth: 1, borderColor: UIColor.gray, cornerRadius: 4)
        myContactTextView.delegate = self
        myTblView.delegate = self
        myTblView.dataSource = self
        self.myBtnContact.backgroundColor = HELPER.hexStringToUIColor(hex: APP_GREEN_COLOR)
        self.myContactSendButton.backgroundColor = HELPER.hexStringToUIColor(hex: APP_GREEN_COLOR)

        myTblView.register(UINib.init(nibName: cellHeaderIdentifier, bundle: nil), forCellReuseIdentifier: cellHeaderIdentifier)
        myTblView.register(UINib.init(nibName: cellUserDetailsIdentifier, bundle: nil), forCellReuseIdentifier: cellUserDetailsIdentifier)
        myTblView.register(UINib.init(nibName: cellUserInfoIdentifier, bundle: nil), forCellReuseIdentifier: cellUserInfoIdentifier)
        myTblView.register(UINib.init(nibName: cellUserReviewIdentifier, bundle: nil), forCellReuseIdentifier: cellUserReviewIdentifier)
        myTblView.register(UINib.init(nibName: cellLazyLoadingIdentifier, bundle: nil), forCellReuseIdentifier: cellLazyLoadingIdentifier)
        
        myBtnContact.isHidden = false

        let aDictInfo = userInfo[0]
        let currentSellerId:String = aDictInfo["user_id"] as! String
        if currentSellerId == SESSION.getUserId() {
            
            myBtnContact.isHidden = true
        }
    }
    
    func setUpModel() {
        
        isLazyLoading = true
    }
    
    func loadModel() {
        
        self.httpRequestForGettingUserReviews()
    }
    
    // MARK: - TableView delegate and datsource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3 //gAryInfo.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        let aAryInfo = gAryInfo[section][K_ARRAYINFO] as! [[String:Any]]
//
//        return aAryInfo.count
        if section == 2   {
            
            return gAryReviewInfo.count + (isLazyLoading ? 1 : 0)

        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1 || section == 2 {
                return 40
        }
        
        return  0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let aCell:GSHomeHeaderTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellHeaderIdentifier) as? GSHomeHeaderTableViewCell
        
        aCell?.gBtnViewAll.isEnabled = true
        aCell?.gBtnViewAll.tag = section
        //aCell?.gBtnViewAll.addTarget(self, action: #selector(self.viewSimilarBtnTapped(sender:)), for: .touchUpInside)
        
        aCell?.backgroundColor = UIColor.groupTableViewBackground
        
//        if  (aCell == nil) {
//
//            let nib:NSArray=Bundle.main.loadNibNamed(cellHeaderIdentifier, owner: self, options: nil)! as NSArray
//            aCell = nib.object(at: 0) as? GSHomeHeaderTableViewCell
//        }
//        else {
//
//            aCell?.gLblHeader.text = gAryInfo[section][K_TITLE] as? String
//        }
        
        if section == 1 {
            
            aCell?.gBtnViewAll.isHidden = true
            aCell?.gLblHeader.text = "User Information"
        }
        
        else if section == 2 {
            
            aCell?.gBtnViewAll.isHidden = true
            aCell?.gLblHeader.text = "Reviews"
        }
        else {
            
            aCell?.gBtnViewAll.isHidden = true
        }
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return 70
        }
        else if indexPath.section == 1 {
            
            return 100
        }
        else  {
            
//            let aAryInfo = gAryInfo[indexPath.section][K_ARRAYINFO] as! [[String:String]]
//
//            return aAryInfo.count > 0 ? 250 : 0
            
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 0 {

            let aDictInfo = userInfo[indexPath.row]

            let aCell = tableView.dequeueReusableCell(withIdentifier: cellUserDetailsIdentifier, for: indexPath) as! GSUserDetailsTableViewCell

            aCell.gLblName.text = aDictInfo["fullname"] as? String
            aCell.gLblType.text = aDictInfo["profession_name"] as? String

            let aStrProfileImage = aDictInfo["user_profile_image"] as? String
            
            HELPER.setRoundCornerView(aView: aCell.gImgView)
            aCell.gImgView.sd_setImage(with: URL(string:SESSION.getBaseImageUrl() + aStrProfileImage!), placeholderImage: UIImage(named: IMG_PROFILE_PLACEHOLDER))

            let myFloat = (aDictInfo["gig_rating"]! as! NSString).floatValue
            aCell.gRatingView.isAbsValue = false
            aCell.gRatingView.isUserInteractionEnabled = false

            aCell.gRatingView.maxValue = 5
            aCell.gRatingView.value = CGFloat(myFloat)

            return aCell
        }
        else if indexPath.section == 1 {

            let aAryInfo = userProfileInfo

            let aAryUsrinfo = ["Total Views","Country","User Count","Speaks"]
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellUserInfoIdentifier, for: indexPath) as! GSUserInfoTableViewCell

            aCell.gLblFirstHeight.constant = 0
            aCell.gLblSecondHeight.constant = 0
            aCell.gLblFiveHeight.constant = 0
            aCell.gLblSixHeight.constant = 0

//            aCell.gLblFirst.text = aAryUsrinfo[0]
//            aCell.gLblSecond.text = aAryInfo[indexPath.row]["Views"] as? String
            aCell.gLblThird.text = aAryUsrinfo[1]
            aCell.gLblFour.text = aAryInfo[indexPath.row]["Country"] as? String
//            aCell.gLblFive.text = aAryUsrinfo[2]
//            aCell.gLblSix.text = aAryInfo[indexPath.row]["UserCount"] as? String
            aCell.gLblSeven.text = aAryUsrinfo[3]
            aCell.gLblEight.text = aAryInfo[indexPath.row]["Speaks"] as? String

            return aCell
        }

        else  {
            
            if indexPath.row >= gAryReviewInfo.count {
                
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellLazyLoadingIdentifier, for: indexPath) as! LazyLoadingTableViewCell
                
                aCell.gActivityIndicator.startAnimating()
                
                return aCell
            }
            else {
                
                if gAryReviewInfo.count > 0 {
                    
                    let aCell = tableView.dequeueReusableCell(withIdentifier: cellUserReviewIdentifier, for: indexPath) as! GSUserReviewsTableViewCell
                    
                    let aStrProfileImage = gAryReviewInfo[indexPath.row]["profile_img"] as? String
                    
                    HELPER.setRoundCornerView(aView: aCell.gImgView)
                    aCell.gImgView.sd_setImage(with: URL(string:SESSION.getBaseImageUrl() + aStrProfileImage!), placeholderImage: UIImage(named: IMG_PROFILE_PLACEHOLDER))
                    
                    aCell.gLblUserName.text = gAryReviewInfo[indexPath.row]["buyer_name"] as? String
                    
                    let result = (gAryReviewInfo[indexPath.row]["rating"] as! NSString).floatValue
                    aCell.gViewRating.isUserInteractionEnabled = false
                    aCell.gViewRating.maxValue = 5
                    aCell.gViewRating.value = CGFloat(result)
                    aCell.gLblUserDetail.text = gAryReviewInfo[indexPath.row]["comment"] as? String
                    
                    return aCell
                }
                else {
                    let aCell = tableView.dequeueReusableCell(withIdentifier: cellUserInfoIdentifier, for: indexPath) as! GSUserInfoTableViewCell
                    
                    return aCell
                }
            }
        }
        
//        let aCell = tableView.dequeueReusableCell(withIdentifier: cellUserInfoIdentifier, for: indexPath) as! GSUserInfoTableViewCell

//        return aCell
    }
    
    // MARK: - TextView Delegate
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let textViewText: NSString = (textView.text ?? "") as NSString
        let txtAfterUpdate = textViewText.replacingCharacters(in: range, with: text)
        
            gStrContacttext = txtAfterUpdate
        
        return true
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
        
        httpRequestForGettingUserReviews()
    }
    // MARK: - Button Action
    
    @IBAction func btnContactTapped(_ sender: Any) {
        
        if SESSION.isUserLogIn() {
            
            myContactTextView.text = ""
            UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.myContactContainerView.isHidden = false
                self.myTableContainerView.backgroundColor = UIColor.lightGray
                self.myTblView.alpha = 0.5
            })
        }
        else {
            HELPER.pushToLogInScreen(isFrom: self)
        }
    }
    
    @IBAction func btnContactSendTapped(_ sender: Any) {
        
        if gStrContacttext.count > 0 {
            
            httpRequestForContactMessage()
        }
        
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.myContactContainerView.isHidden = true
            self.myTableContainerView.backgroundColor = UIColor.clear
            self.myTblView.alpha = 1.0
        })
    }
    
    @IBAction func btnContactCloseTapped(_ sender: Any) {
        
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.myContactContainerView.isHidden = true
            self.myTableContainerView.backgroundColor = UIColor.clear
            self.myTblView.alpha = 1.0
        })
    }
    // MARK: - Api Call
    func httpRequestForGettingUserReviews() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "Loading..")
        
        let aDictInfo = userInfo[0]
       
        var dictLoginCrediental = [String:String]()
        dictLoginCrediental["page"] = String(gStrPaginationIndex)
        dictLoginCrediental[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
        dictLoginCrediental[K_USER_ID] =  aDictInfo["user_id"] as? String
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_VIEWALL_USERREVIEWS, dictParameters: dictLoginCrediental, sucessBlock: { (response) in

//        HTTPMANAGER.getAllUserReviewsInfo(parameter: dictLoginCrediental, sucessblock: {response in
            
            print(response)
            
            HELPER.hideLoadingAnimation()
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            var aDictResponseInfo = [String:Any]()
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                aDictResponseInfo = response["data"] as! [String:Any]

                self.myIntTotalPage = aDictResponseInfo["total_pages"] as! Int
                
                if self.myIntTotalPage == 0 {
                    
                    self.isLazyLoading = false
                }
                    
                else {
                    
                    self.isLazyLoading = self.myIntTotalPage == self.myIntPagewNumber ? false : true
                    
                    self.myIntPagewNumber = self.myIntPagewNumber + 1
                    self.myStrPagewNumber = String(describing: self.myIntPagewNumber)
                    
                    if self.gAryReviewInfo.count == 0 {
                        
                        self.gAryReviewInfo = aDictResponseInfo["review_details"] as! [[String : Any]]
                        self.myTblView.reloadData()
                    }
                    else {
                        
//                        for dictInfo in aDictResponseInfo["review_details"] as! [[String : Any]] {
//                            self.gAryReviewInfo.append(dictInfo)
//                        }
                    }
                }
                
            }
                
            else {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
            self.myTblView.reloadData()
            
//            if aIntResponseCode == RESPONSE_CODE_200 {
//
//                //self.myDictReviewInfo = response["data"] as! [String:Any]
//
//                var info = response["data"] as! [String:Any]
//                var reviewDetails:[[String:Any]]?
//
//                self.myIntTotalPage = info["total_pages"] as! Int
//
//                if self.myIntTotalPage == 0 {
//
//                    self.isLazyLoading = false
//                }
//                else {
//
//                    self.isLazyLoading = self.myIntTotalPage == self.myIntPagewNumber ? false : true
//
//                    self.myIntPagewNumber = self.myIntPagewNumber + 1
//                    self.myStrPagewNumber = String(describing: self.myIntPagewNumber)
//
//                    if self.myAryInfo.count == 0 {
//
//                        self.myAryInfo = ["chat_details"] as! [[String : String]]
//                        self.myTblView.reloadData()
//                    }
//                    else {
//
//                        for dictInfo in aDictResponseInfo["chat_details"] as! [[String : String]] {
//                            self.myAryInfo.append(dictInfo)
//                        }
//                    }
//                }
//
//                if self.gStrPaginationIndex == 1 {
//
//                    if let details = info["review_details"] {
//                        reviewDetails = details as?  [[String:Any]]
//
//                    }
//                }
//                else {
//
//                    if let details = info["review_details"] {
//                        reviewDetails = reviewDetails.ap details as?  [[String:Any]]
//
//                    }
//                }
//                self.needToUpdate = true
//                if pagesCount == self.gStrPaginationIndex {
//                    self.needToUpdate = false
//                }
//
//                self.myDictReviewInfo["total_pages"] = myIntTotalPage
//                self.myDictReviewInfo["review_details"] = reviewDetails
//
//                self.myTblView.reloadData()
//
//            } else {
//
//                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
//            }
            
        }, failureBlock: { error in
            HELPER.hideLoadingAnimation()
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    func httpRequestForContactMessage() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
         let aDictInfo = userInfo[0]
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "Loading..")
        
        var dictLoginCrediental = [String:String]()
        dictLoginCrediental["sell_gigs_userid"] = aDictInfo["user_id"] as? String
        dictLoginCrediental["chat_message_content"] = gStrContacttext
        //dictLoginCrediental[K_USER_ID] =  SESSION.getUserId()
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_CONTACT_MESSAGE, dictParameters: dictLoginCrediental, sucessBlock: { (response) in

//        HTTPMANAGER.sendContactMessage(parameter: dictLoginCrediental, sucessblock: {response in
            
            HELPER.hideLoadingAnimation()
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
                self.view.endEditing(true)
            }
            else {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
        }, failureBlock: { error in
            HELPER.hideLoadingAnimation()
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    // MARK: - Left Bar Button Methods
    
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

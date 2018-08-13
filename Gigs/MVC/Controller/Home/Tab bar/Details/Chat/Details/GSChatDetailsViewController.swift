//
//  GSChatDetailsViewController.swift
//  Gigs
//
//  Created by Yosicare on 28/03/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit


class GSChatDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate {

    @IBOutlet weak var myCollectionView: UICollectionView!

    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var inputToolbar: UIView!
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    let cellIdentifier = "GSChatCollectionViewCell"
    let cellIReciverdentifier = "GSChatReciverCollectionViewCell"
    let cellLazyLoadingIdentifier = "GSLazyLoadingCollectionViewCell"
    
    var gStrToUserId = String()
    var gStrUserName = String()
    var gStrUserImage = String()

    var myAryInfo = [[String:String]]()
    
    var myIntTotalPage = Int()
    var myStrPagewNumber = "1"
    var myIntPagewNumber:Int = 1
    
    var isLazyLoading:Bool!
    var isLoadMoreStart:Bool!
    
    var strText = String()

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
    
    // MARK: - View Initailize
    
    func setUpUI() {
        
        NAVIGAION.setNavigationTitle(aStrTitle: gStrUserName, aViewController: self)
        setUpLeftBarBackButton()
        
        myCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        myCollectionView.register(UINib(nibName: cellIReciverdentifier, bundle: nil), forCellWithReuseIdentifier: cellIReciverdentifier)
        myCollectionView.register(UINib(nibName: cellLazyLoadingIdentifier, bundle: nil), forCellWithReuseIdentifier: cellLazyLoadingIdentifier)
        
        textView.layer.cornerRadius = 4.0
        textView.placeholder = "Enter your comments.."
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.minHeight = 40
        textView.maxHeight = 100
        textView.delegate = self
        // *** Hide keyboard when tapping outside ***
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        view.addGestureRecognizer(tapGesture)
        
        // *** Listen to keyboard show / hide ***
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        
        // *** Customize GrowingTextView ***
        textView.layer.cornerRadius = 4.0
        
//        NotificationCenter.default.addObserver(forName: GETCHATDETAILS, object: nil, queue: nil) { (info) in
//
//
//            self.myAryInfo.append((info.userInfo as! [String : Any]))
//            self.myCollectionView.reloadData()
//
//            let lastItemIndex = IndexPath(item: self.myAryInfo.count - 1, section: 1)
//            self.myCollectionView?.scrollToItem(at: lastItemIndex, at: .top, animated: true)
//
//        }
    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
    
//    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
//        if let endFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            var keyboardHeight = view.bounds.height - endFrame.origin.y
//            if #available(iOS 11, *) {
//                if keyboardHeight > 0 {
//                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
//                }
//            }
//        }
//        self.view.layoutIfNeeded()
//    }

    func setUpModel() {
     
        self.myStrPagewNumber = "1"
        isLazyLoading = false
        btnSend.isEnabled = true
    }
    
    func loadModel() {
        
        getMessageDetails()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
      
        return 2
    }
    
    // MARK: - Collection View Delegate and Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return isLazyLoading ? 1 : 0
        }
        
        else {
            
            return myAryInfo.count

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {

            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellLazyLoadingIdentifier, for: indexPath) as! GSLazyLoadingCollectionViewCell
           
            aCell.gActivityIndicator.color = HELPER.hexStringToUIColor(hex: APP_COLOR)
            aCell.gActivityIndicator.stopAnimating()
            return aCell
        }
            
        else {
            
            if myAryInfo[indexPath.row]["chat_from"] == SESSION.getUserId() {
                
                let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIReciverdentifier, for: indexPath) as! GSChatReciverCollectionViewCell
                
                aCell.gLblMessage.text = myAryInfo[indexPath.row]["content"]
                aCell.gLblDate.text = myAryInfo[indexPath.row]["chat_time"]
                HELPER.setRoundCornerView(aView: aCell.gViewBubble, borderRadius: 5.0)
                
                return aCell
            }
                
            else {
                
                let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! GSChatCollectionViewCell
                
                aCell.gLblMessage.text = myAryInfo[indexPath.row]["content"]
                aCell.gLblDate.text = myAryInfo[indexPath.row]["chat_time"]
                HELPER.setRoundCornerView(aView: aCell.gViewBubble, borderRadius: 5.0)
                aCell.gViewBubble.backgroundColor = HELPER.hexStringToUIColor(hex: APP_COLOR)
                
                aCell.gLblMessage.textColor = UIColor.white
                aCell.gLblDate.textColor = UIColor.white

                return aCell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {

            return CGSize(width: collectionView.frame.size.width, height: 50)
        }
        
        else {
            
            let strContent = myAryInfo[indexPath.row]["content"]
            
            return CGSize(width: collectionView.frame.size.width, height: calculateContentHeight(strMessageContent: strContent!))
        }
    }
    
    func calculateContentHeight(strMessageContent:String) -> CGFloat {
        
        let maxLabelSize:CGSize = CGSize(width: 300, height: 9999)
        
        //var maxLabelSize: CGSize = CGSize(self.view.frame.size.width - 100, CGFloat(9999))
        
        let contentNSString = strMessageContent
        
        let expectedLabelSize = contentNSString.boundingRect(with: maxLabelSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14)], context: nil)
        
        print("\(expectedLabelSize)")
        return expectedLabelSize.size.height + 50
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        if scrollView.contentOffset.y == 0 {
            
            print("At the top")
      
            if isLazyLoading {
                isLazyLoading = false
                loadMore()
            }
        }
    }
    
    func loadMore() {
        
        getMessageDetails()
    }
    
    // MARK: - Api Call
    func getMessageDetails() {
        
        if !HELPER.isConnectedToNetwork() {
            
            self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_NO_INTERNET)
            return
        }
        
        var dictGetComments = [String:String]()
        
//        dictGetComments = ["from_user_id":SESSION.getUserId(),"to_user_id":gStrToUserId,"page":self.myStrPagewNumber]
        
        dictGetComments = ["to_user_id":gStrToUserId,"page":self.myStrPagewNumber]
        
        if isLazyLoading {
            
            HELPER.showLoadingViewAnimation(viewController: self)
        }
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_CHAT_DETAIL, dictParameters: dictGetComments, sucessBlock: { (response) in

//        HTTPMANAGER.getChatDetail(parameter: dictGetComments, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation(viewController: self)
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            var aDictResponseInfo = [String:Any]()

            aDictResponseInfo = response["data"] as! [String:Any]
            
            print(aDictResponseInfo)
            
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
                        
                        self.myCollectionView.reloadData()
                        
                       // let indexPath = IndexPath(forRow: self.myAryInfo.count, inSection: 0)

                        let indexPath = IndexPath(row: self.myAryInfo.count, section: 1)

                       // self.myCollectionView.scrollToItem(at: indexPath as IndexPath, at: UICollectionViewScrollPosition.top, animated: true)
                    }
                    else {
                        
                        var myAryInfoUpdate = [[String:String]]()
                        
                        for dictInfo in aDictResponseInfo["chat_details"] as! [[String : String]] {
                            
                            myAryInfoUpdate.append(dictInfo)
                            print(self.myAryInfo)
                        }
                        
                        for dictInfoUpdate in self.myAryInfo {
                            
                            myAryInfoUpdate.append(dictInfoUpdate)
                        }
                        
                        self.myAryInfo = myAryInfoUpdate
                    }
                }
                self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_NO_DATA)
            }
                
            else {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
            self.isLoadMoreStart = false
            self.myCollectionView.reloadData()
            
        }, failureBlock: { error in
            
            self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_SERVER_ERROR)
        })
    }
    
    //Send Message
    func sendMessageDetails(strMessage:String) {
        
        var dictGetComments = [String:String]()
        
//        dictGetComments = ["from_user_id":SESSION.getUserId(),"to_user_id":gStrToUserId,"message":strMessage]
        dictGetComments = ["to_user_id":gStrToUserId,"message":strMessage]

        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_CHAT_USER, dictParameters: dictGetComments, sucessBlock: { (response) in

//        HTTPMANAGER.getUserChat(parameter: dictGetComments, sucessBlock: { response in
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            self.btnSend.isEnabled = true
            self.textView.text = ""

            if aIntResponseCode == RESPONSE_CODE_200 {
                
                var aAryResponseInfo = [[String:Any]]()
                aAryResponseInfo = response["data"] as! [[String:Any]]
                
                let dictInfo = aAryResponseInfo[0] as! [String:String]
                
                self.myAryInfo.append(dictInfo)
                self.myCollectionView.reloadData()
            }
                
            else {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
        }, failureBlock: { error in
            
            self.btnSend.isEnabled = true
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
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
                    self.getMessageDetails()
                })
            }
        }

        else if alertType == ALERT_TYPE_NO_DATA {

            if myAryInfo.count == 0 {

                HELPER.showNoDataWithRetryAlert(viewController: self,alertMessage:ALERT_NO_RECORDS_FOUND, retryBlock: {

                    HELPER.removeNetworlAlertIn(viewController: self)
                    self.getMessageDetails()
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
                    self.getMessageDetails()
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
    
    @IBAction func sendBtnTapped(_ sender: Any) {
        
        btnSend.isEnabled = false

        sendMessageDetails(strMessage:textView.text)
    }
    
    @objc func tapGestureHandler() {
        view.endEditing(true)
    }
    
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        
        if let endFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            
            if #available(iOS 11, *) {
                
                if keyboardHeight > 0 {
                    
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                    
                }
                
            }
            
            textViewBottomConstraint.constant = keyboardHeight + 8
            
            view.layoutIfNeeded()
            
        }
        
    }
}

//extension GSChatDetailsViewController: GrowingTextViewDelegate {
//
//    // *** Call layoutIfNeeded on superview for animation when changing height ***
//
//    func textViewDidChange(_ textView: UITextView) {
//
//        if textView.text.count == 0 {
//
//            btnSend.isEnabled = false
//        }
//
//        else {
//
//            btnSend.isEnabled = true
//        }
//    }
//
//
//    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
//        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.curveLinear], animations: { () -> Void in
//            self.view.layoutIfNeeded()
//        }, completion: nil)
//    }
//
//
//
//}

//var arrayFilter = [[String:String]]()
//var dictInfoAdd = [String:String]()
//
//dictInfoAdd = ["firstname":"jegan"]
//
//arrayFilter.append(dictInfoAdd)
//
//dictInfoAdd = ["firstname":"jegan"]
//
//arrayFilter.append(dictInfoAdd)
//
//dictInfoAdd = ["firstname":"goog"]
//
//arrayFilter.append(dictInfoAdd)
//
//dictInfoAdd = ["firstname":"gl"]
//
//arrayFilter.append(dictInfoAdd)
//
//dictInfoAdd = ["firstname":"assss"]
//
//arrayFilter.append(dictInfoAdd)
//
//dictInfoAdd = ["firstname":"goog"]
//
//arrayFilter.append(dictInfoAdd)
//
//let grouDict = Dictionary(grouping: arrayFilter) { (dictInfo) -> String in
//    return dictInfo["firstname"]!
//}
//
//var groubArray = [[String:Any]]()
//
//let keys = grouDict.keys
//
//keys.forEach { (key) in
//
//    var dictInfoAdd = [String:Any]()
//    let searchString = key
//
//    let predicate = NSPredicate(format: "firstname = %@", searchString)
//
//    let searchDataSource = arrayFilter.filter { predicate.evaluate(with: $0) }
//    dictInfoAdd["title"] = key
//
//    dictInfoAdd["row"] = searchDataSource
//    groubArray.append(dictInfoAdd)
//
//}
//print(groubArray)

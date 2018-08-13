//
//  GSActivityViewController.swift
//  Gigs
//
//  Created by user on 03/04/2018.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit
import MXSegmentedControl
import Presentr
import CZPicker

class GSActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ClassPaymentCancelDelegate, CZPickerViewDelegate, CZPickerViewDataSource {

    @IBOutlet weak var mySegmentedControl: MXSegmentedControl!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myViewAvailableFunds: UIView!
    @IBOutlet weak var myConstraintTblViewTop: NSLayoutConstraint!
    @IBOutlet weak var myLabelWalletBalnc: UILabel!
    
    var myAryPickerInfo = [String]()
    
    let cellActivityIdentifier = "GSActivityPurchaseTableViewCell"
    
    var myAryPurchaseInfo = [[String:Any]]()
    var myArySalesInfo = [[String:Any]]()
    var myAryPaymentInfo = [[String:Any]]()
    var myAryFilterInfo = [[String:Any]]()

    var myStrUserId = String()
    var myIntSelectedIndex = Int()
    
    var myIndex = String()
    var myStrRejectReason = String()
    
    var selectedIndexPath = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpUI()
        setUpModel()
        loadModel()
    }

    
    // MARK: - View Initialize
    
    override func viewWillAppear(_ animated: Bool) {
        
        NAVIGAION.setNavigationTitle(aStrTitle: SCREEN_TITLE_MY_ACTIVITY, aViewController: self)
    }
    
    func setUpUI() {
        
        setUpLeftBarButton()
        mySegmentedControl.append(title: "Purchase")
        mySegmentedControl.append(title: "Sales")
        mySegmentedControl.append(title: "Payment")
        
        myTableView.register(UINib.init(nibName: cellActivityIdentifier, bundle: nil), forCellReuseIdentifier: cellActivityIdentifier)
        
        myViewAvailableFunds.isHidden = true
        myConstraintTblViewTop.constant = 0.0

        myStrUserId = SESSION.getUserId()
    }
    
    func setUpModel() {
        
        myAryPickerInfo = ["Accept Order","Reject Order"]
    }
    
    func loadModel() {
        
        callActivityApi()
    }
    
    //MARK: - TableView Delegate and DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myAryFilterInfo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 170.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell:GSActivityPurchaseTableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellActivityIdentifier) as? GSActivityPurchaseTableViewCell)!
        HELPER.setCardView(cardView: aCell.gViewContainer)
        
        if mySegmentedControl.selectedIndex == 2 {
            
            aCell.gLabelSellerName.text = String(format: "%@ %@", "Buyer Name:", (myAryFilterInfo[indexPath.row]["buyer_name"] as? String)!)
            aCell.gViewPaymentRequest.isHidden = false
            aCell.gViewPurchaseAndSales.isHidden = true
            HELPER.setCardView(cardView: aCell.gBtnPaymentRequest)
            let aWithDrawStatus = myAryFilterInfo[indexPath.row]["withdraw_val"] as! Int
            aCell.gBtnPaymentRequest.addTarget(self, action: #selector(self.requestButtonClicked(sender:)), for: .touchUpInside)
            
            switch aWithDrawStatus
            {
            // set title to Withdraw amount
            case 0:
                aCell.gBtnPaymentRequest.setTitle("WITHDRAW AMOUNT", for: .normal)
                aCell.gBtnPaymentRequest.isUserInteractionEnabled = true
            // set title to Request Sent
            case 1:
                aCell.gBtnPaymentRequest.setTitle("REQUEST SENT", for: .normal)
                aCell.gBtnPaymentRequest.isUserInteractionEnabled = false
            // set title to Payment Received
            case 2:
                aCell.gBtnPaymentRequest.setTitle("PAYMENT RECEIVED", for: .normal)
                aCell.gBtnPaymentRequest.isUserInteractionEnabled = false
            default:
                break;
            }
            
            aCell.gBtnPaymentRequest.addTarget(self, action: #selector(self.requestButtonClicked(sender:)), for: .touchUpInside)
        }
        
        else if mySegmentedControl.selectedIndex == 1 {
            
            aCell.gViewPaymentRequest.isHidden = true
            aCell.gViewPurchaseAndSales.isHidden = false
            
            let aFeedBackBtnTitle = myAryFilterInfo[indexPath.row]["feedback"] as? String?
            let aCancelBtnTitle = myAryFilterInfo[indexPath.row]["order_cancel"] as? String?
            let aOrderStatusBtnTitle = myAryFilterInfo[indexPath.row]["order_status"] as? String?
            
            aCell.gLabelSellerName.text = String(format: "%@ %@", "Buyer Name:", (myAryFilterInfo[indexPath.row]["buyer_name"] as? String)!)
            aCell.gBtnPending.setTitle(aFeedBackBtnTitle!, for: .normal)
            aCell.gBtnCancel.setTitle(aCancelBtnTitle!, for: .normal)
            aCell.gBtnOrderStatus.setTitle(aOrderStatusBtnTitle!, for: .normal)
            aCell.gBtnPending.addTarget(self, action: #selector(self.feedBackSalesButtonClicked(sender:)), for: .touchUpInside)
            aCell.gBtnCancel.addTarget(self, action: #selector(self.cancelButtonClicked(sender:)), for: .touchUpInside)
            aCell.gBtnOrderStatus.addTarget(self, action: #selector(self.orderStatusButtonClicked(sender:)), for: .touchUpInside)
            
            if(aCancelBtnTitle == "Cancel Request" || aCancelBtnTitle == "View Reason") {
                
                aCell.gBtnCancel.isUserInteractionEnabled = true
            }
            
            else {
                
                aCell.gBtnCancel.isUserInteractionEnabled = false
            }
            
            if aOrderStatusBtnTitle == "New" && aCancelBtnTitle != "Cancel Request" {
                
                aCell.gBtnOrderStatus.isUserInteractionEnabled = true
            }
            
            else {
                
                aCell.gBtnOrderStatus.isUserInteractionEnabled = false
            }
            
            if aOrderStatusBtnTitle == "Process" || aOrderStatusBtnTitle == "Pending"  {

                aCell.gBtnOrderStatus.isUserInteractionEnabled = true
            }
            
            else {
                
                aCell.gBtnOrderStatus.isUserInteractionEnabled = false
            }
            
        }
        
        else {
            
            aCell.gViewPaymentRequest.isHidden = true
            aCell.gViewPurchaseAndSales.isHidden = false
            
            let aFeedBackBtnTitle = myAryFilterInfo[indexPath.row]["feedback"] as? String!
            let aCancelBtnTitle = myAryFilterInfo[indexPath.row]["order_cancel"] as? String!
            let aOrderStatusBtnTitle = myAryFilterInfo[indexPath.row]["order_status"] as? String!
            
            aCell.gLabelSellerName.text = String(format: "%@ %@", "Seller Name:", (myAryFilterInfo[indexPath.row]["seller_name"] as? String)!)
            aCell.gBtnPending.setTitle(aFeedBackBtnTitle, for: .normal)
            aCell.gBtnCancel.setTitle(aCancelBtnTitle, for: .normal)
            aCell.gBtnOrderStatus.setTitle(aOrderStatusBtnTitle, for: .normal)
            aCell.gBtnPending.addTarget(self, action: #selector(self.feedBackButtonClicked(sender:)), for: .touchUpInside)
            aCell.gBtnCancel.addTarget(self, action: #selector(self.cancelButtonClicked(sender:)), for: .touchUpInside)
            aCell.gBtnOrderStatus.addTarget(self, action: #selector(self.orderStatusButtonClicked(sender:)), for: .touchUpInside)
            
            if(aCancelBtnTitle == "Cancel") {
                
                aCell.gBtnCancel.isUserInteractionEnabled = true
            }
            
            else {
                
                aCell.gBtnCancel.isUserInteractionEnabled = false
            }
            
            if aOrderStatusBtnTitle == "Completed Accept" {
                
                aCell.gBtnOrderStatus.isUserInteractionEnabled = true
                aCell.gBtnOrderStatus.tag = indexPath.row
                aCell.gBtnOrderStatus.addTarget(self, action: #selector(self.completeReqButtonClicked(sender:)), for: .touchUpInside)
            }
                
            else {
                
                aCell.gBtnOrderStatus.isUserInteractionEnabled = false
            }
        }
        
        let aImgGigImg = myAryFilterInfo[indexPath.row]["gig_image_thumb"] as? String
        
        aCell.gLabelGigName.text = myAryFilterInfo[indexPath.row]["title"] as? String
        aCell.gLabelGigTime.text = myAryFilterInfo[indexPath.row]["created_date"] as? String
        aCell.gLabelGigPrice.text = String(format: "%@%@", (myAryFilterInfo[indexPath.row]["currency_sign"] as? String)!, (myAryFilterInfo[indexPath.row]["amount"] as? String)!)
        aCell.gImgViewGigImg.sd_setImage(with: URL(string:SESSION.getBaseImageUrl() + aImgGigImg!), placeholderImage: UIImage(named: ICON_PLACEHOLDER_IMAGE))
        
        aCell.gLabelOrderId.text = String(format: "%@ %@", "Order Id:", (myAryFilterInfo[indexPath.row]["order_id"] as? String)!)
        let aDeliveryDate = HELPER.dateformate(getDate: (myAryFilterInfo[indexPath.row]["delivery_date"] as? String)!)
        aCell.gLabelDeliveryDate.text = String(format: "%@ %@", "Delivery Date:", aDeliveryDate)
        
        return aCell
    }
    
    // Protocol Delegate
    
    func callActivityApiAndReloadList(selectedIndex :Int){
        
        myIntSelectedIndex = selectedIndex
        loadModel()
    }
    
    // MARK: - CZPicker delegate and datasource
    
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        
        return myAryPickerInfo.count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        
        return myAryPickerInfo[row]
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {
        
        if row == 0 {
            
//            let buttonPosition:CGPoint = pickerView.convert(CGPoint.zero, to:self.myTableView)
//            let indexPath = self.myTableView.indexPathForRow(at: buttonPosition)
            
            print(selectedIndexPath)
            callCompleteRequestAcceptApi(indexpath: selectedIndexPath)
        }
            
        else {
        
            let alert = UIAlertController(title: "Reject Order", message: "Enter a text", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.text = ""
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                print("Text field: \(String(describing: textField?.text))")
                
                self.myStrRejectReason = (textField?.text)!
                
                print(self.selectedIndexPath)
                
                self.callCompleteRequestRejectApi(indexpath: self.selectedIndexPath)
                
            }))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Api call
    // Call Activity Api
    
    func callActivityApi() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingViewAnimation(viewController: self)
        
        var dictParameters = [String:String]()
        dictParameters[kDEVICE_VIEWALL] = kDEVICE_VIEWALL_SERVICES
        dictParameters[K_USER_ID] = myStrUserId
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_MY_ACTIVITY, dictParameters: dictParameters, sucessBlock: { (response) in

//        HTTPMANAGER.getMyActivity(userId: myStrUserId, sucessblock: {response in
            
            HELPER.hideLoadingAnimation(viewController: self)
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                print(response["data"] as! [String:Any])
                
                let aResponseData = response["data"] as! [String:Any]
                
                self.myAryPurchaseInfo = aResponseData["my_purchases"] as! [[String : Any]]
                self.myArySalesInfo = aResponseData["my_sale"] as! [[String : Any]]
                self.myAryPaymentInfo = aResponseData["my_payments"] as! [[String : Any]]
//                self.updateActivityFilterArrayInfo(filterArray: self.myAryPurchaseInfo)
                
                switch self.myIntSelectedIndex
                {
                //show purchase view
                case 0:
                   self.updateActivityFilterArrayInfo(filterArray: self.myAryPurchaseInfo)
                //show sales view
                case 1:
                    self.updateActivityFilterArrayInfo(filterArray: self.myArySalesInfo)
                //show payment view
                case 2:
                    self.updateActivityFilterArrayInfo(filterArray: self.myAryPaymentInfo)
                default:
                    break;
                }
                
                let aStrWalletBalnce = aResponseData["wallet_balance"] as! CFNumber
                
                self.myLabelWalletBalnc.text = String(format: "£%@", aStrWalletBalnce as! CVarArg)
                
            }
            else {
                
                HELPER.hideLoadingAnimation(viewController: self)
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation(viewController: self)
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    func updateActivityFilterArrayInfo(filterArray: [[String:Any]]) {
        
        myAryFilterInfo = filterArray
        myTableView.reloadData()
    }
    
    
    // Call Amount Withdraw Api
    
    func aAmountWithdrawApi(orderId:String, indexPath: IndexPath) {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingAnimation()
        
        var dictParameters = [String:String]()
        dictParameters[kDEVICE_VIEWALL] = kDEVICE_VIEWALL_SERVICES
        dictParameters[K_ORDER_ID] = orderId
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_AMOUNT_WITHDRAW, dictParameters: dictParameters, sucessBlock: { (response) in

//        HTTPMANAGER.amountWithdrawApi(orderId: orderId, sucessblock: {response in
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                
                let aResponseData = response["data"] as! [String:Any]
                
                let aWithdrawValue = aResponseData["payment_status"] as! Int
                
                
                if self.mySegmentedControl.selectedIndex == 2 {
                    
                    self.myAryPaymentInfo[indexPath.row]["withdraw_val"] = aWithdrawValue
                    self.updateActivityFilterArrayInfo(filterArray: self.myAryPaymentInfo)
                    self.myTableView.reloadData()
                    HELPER.hideLoadingAnimation()
                }
            }
            else {
                
                HELPER.hideLoadingAnimation()
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    // Call Complete Request Api
    func callCompleteRequestAcceptApi(indexpath: IndexPath) {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingAnimationWithDefaultTitle()
        
        var aDicParams = ["payment_id": self.myAryFilterInfo[indexpath.row]["order_id"], "status": "6", "time_zone": TimeZone.current.identifier] as! [String:String]
        aDicParams[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_COMPLETE_REQUEST, dictParameters: aDicParams, sucessBlock: { (response) in

//        HTTPMANAGER.completeRequestApiRequest(parameter: aDicParams, SucessBlock: {response in
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                HELPER.hideLoadingAnimation()
                self.callActivityApi()
            }
            else {
                
                HELPER.hideLoadingAnimation()
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    // Call Complete Request Api
    func callCompleteRequestRejectApi(indexpath: IndexPath) {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingAnimationWithDefaultTitle()
        
        var aDicParams = ["order_id": self.myAryFilterInfo[indexpath.row]["order_id"], "seller_id": self.myAryFilterInfo[indexpath.row]["seller_id"],"gig_id": self.myAryFilterInfo[indexpath.row]["gigs_id"],"reject_reason":myStrRejectReason] as! [String:String]
        aDicParams[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_COMPLETE_REQUEST_REJECT, dictParameters: aDicParams, sucessBlock: { (response) in
            
            //        HTTPMANAGER.completeRequestApiRequest(parameter: aDicParams, SucessBlock: {response in
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                HELPER.hideLoadingAnimation()
                self.callActivityApi()
            }
            else {
                
                HELPER.hideLoadingAnimation()
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    // MARK: - Button Actions
    
    // Segment Control clicked
    @IBAction func segmentIndexChanged(_ sender: Any) {
        
        switch mySegmentedControl.selectedIndex
        {
        //show purchase view
        case 0:
            myViewAvailableFunds.isHidden = true
            myConstraintTblViewTop.constant = 0.0
            updateActivityFilterArrayInfo(filterArray: myAryPurchaseInfo)
            print("Purchase selected")
        //show sales view
        case 1:
            myViewAvailableFunds.isHidden = true
            myConstraintTblViewTop.constant = 0.0
            updateActivityFilterArrayInfo(filterArray: myArySalesInfo)
            print("Sales selected")
       //show payment view
        case 2:
            myViewAvailableFunds.isHidden = false
            myConstraintTblViewTop.constant = 60.0
            updateActivityFilterArrayInfo(filterArray: myAryPaymentInfo)
            print("Payment selected")
        default:
            break;
        }
    }
    
    
    // Cancel Button Clicked
    @objc func cancelButtonClicked(sender: UIButton) {
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.myTableView)
        let indexPath = self.myTableView.indexPathForRow(at: buttonPosition)
        let aStrViewReason = myAryFilterInfo[(indexPath?.row)!]["order_cancel"] as? String
        
        
        let sourceType = myAryFilterInfo[(indexPath?.row)!]["source"] as? String
        let aViewController = GSPaymentCancelViewController()
        aViewController.gStrPaymentSource = sourceType!
        aViewController.gDicPaymentCancelInfo = myAryFilterInfo[(indexPath?.row)!]
        aViewController.delegate = self
        aViewController.gBoolIsFromCancel = true
        aViewController.gBoolIsFromOrderStatus = false
        aViewController.gBoolIsFromFeedback = false
        aViewController.gIntSelectedIndex = mySegmentedControl.selectedIndex
        
        let width = ModalSize.custom(size: 320)
        var height = ModalSize.custom(size: 300)
        
        if aStrViewReason == "View Reason" {
            
            height = ModalSize.custom(size: 100)
        }
            
        else if aStrViewReason == "Cancel Request" {
            
            height = ModalSize.custom(size: 150)
        }
        
        else {
            
            if sourceType == "stripe" || sourceType == "Stripe" {
                
                height = ModalSize.custom(size: 300)
            }
                
            else if sourceType == "paypal" || sourceType == "Paypal"{
                
                height = ModalSize.custom(size: ((80*2)+100))
            }
        }
        
        let center = ModalCenterPosition.center
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .coverVertical
        customPresenter.dismissTransitionType = .coverVertical
        customPresenter.roundCorners = true
        customPresenter.dismissOnSwipe = false
        customPresenter.dismissOnSwipeDirection = .top
        customPresenter.blurStyle = .light
        customPresenter.blurBackground = true
        
        self.customPresentViewController(customPresenter, viewController: aViewController, animated: true, completion: nil)
    }
    
    
    //Feedback
     @objc func feedBackButtonClicked(sender: UIButton) { // (2)See feedback (1)Leave feedback
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.myTableView)
        let indexPath = self.myTableView.indexPathForRow(at: buttonPosition)
        
        print([(indexPath?.row)!])
        
        let aNumViewFeedback = myAryPurchaseInfo[(indexPath?.row)!]["feedback_val"] as! NSNumber
        let aStrViewFeedback = "\(aNumViewFeedback)"
        
        
        if aStrViewFeedback == "1" {
            
            let aViewController = GSFeedbackViewController()
            aViewController.gIsComment = true
            aViewController.gIsReview = false
            aViewController.gGigId = (myAryFilterInfo[(indexPath?.row)!]["gigs_id"] as? String)!
            aViewController.gOrderId = (myAryFilterInfo[(indexPath?.row)!]["order_id"] as? String)!
            aViewController.gFromUserId = (myAryFilterInfo[(indexPath?.row)!]["user_id"] as? String)!
            let aNavi = UINavigationController(rootViewController: aViewController)
            self.present(aNavi, animated: true, completion: nil)

        }
        else if aStrViewFeedback == "2" {
            
            let aViewController = GSFeedbackViewController()
            aViewController.gIsComment = false
            aViewController.gIsReview = true
            aViewController.gGigId = (myAryFilterInfo[(indexPath?.row)!]["gigs_id"] as? String)!
            aViewController.gOrderId = (myAryFilterInfo[(indexPath?.row)!]["order_id"] as? String)!
            aViewController.gFromUserId = (myAryFilterInfo[(indexPath?.row)!]["user_id"] as? String)!
            let aNavi = UINavigationController(rootViewController: aViewController)
            self.present(aNavi, animated: true, completion: nil)
            
        }
    }
    
    //Feedback Sale
    @objc func feedBackSalesButtonClicked(sender: UIButton) { // (2)See feedback (1)Leave feedback
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.myTableView)
        let indexPath = self.myTableView.indexPathForRow(at: buttonPosition)
        
        print([(indexPath?.row)!])
        
        let aNumViewFeedback = myArySalesInfo[(indexPath?.row)!]["feedback_val"] as! NSNumber
        let aStrViewFeedback = "\(aNumViewFeedback)"
        
        
        if aStrViewFeedback == "1" {
            
            let aViewController = GSFeedbackViewController()
            aViewController.gIsComment = true
            aViewController.gIsReview = false
            aViewController.gGigId = (myArySalesInfo[(indexPath?.row)!]["gigs_id"] as? String)!
            aViewController.gOrderId = (myArySalesInfo[(indexPath?.row)!]["order_id"] as? String)!
            aViewController.gFromUserId = (myArySalesInfo[(indexPath?.row)!]["user_id"] as? String)!
            let aNavi = UINavigationController(rootViewController: aViewController)
            self.present(aNavi, animated: true, completion: nil)
            
        }
        else if aStrViewFeedback == "2" {
            
            let aViewController = GSFeedbackViewController()
            aViewController.gIsComment = false
            aViewController.gIsReview = true
            aViewController.gGigId = (myArySalesInfo[(indexPath?.row)!]["gigs_id"] as? String)!
            aViewController.gOrderId = (myArySalesInfo[(indexPath?.row)!]["order_id"] as? String)!
            aViewController.gFromUserId = (myArySalesInfo[(indexPath?.row)!]["user_id"] as? String)!
            let aNavi = UINavigationController(rootViewController: aViewController)
            self.present(aNavi, animated: true, completion: nil)
            
        }
    }
    
    //Complete Request
    @objc func completeReqButtonClicked(sender: UIButton) {
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.myTableView)
        let indexPath = self.myTableView.indexPathForRow(at: buttonPosition)
        
        selectedIndexPath = indexPath!
        
        let picker = CZPickerView(headerTitle: "Type of Order status", cancelButtonTitle: "", confirmButtonTitle: "")
        
        picker?.headerBackgroundColor = HELPER.hexStringToUIColor(hex: APP_COLOR)
        picker?.tag = sender.tag
        picker?.delegate = self
        picker?.dataSource = self
        picker?.needFooterView = false
        picker?.tapBackgroundToDismiss = true
        picker?.show()
        
//        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.myTableView)
//        let indexPath = self.myTableView.indexPathForRow(at: buttonPosition)
//
//        print([(indexPath?.row)!])
//
//        let aNumViewFeedback = myAryPurchaseInfo[(indexPath?.row)!]["feedback_val"] as! NSNumber
//        let aStrViewFeedback = "\(aNumViewFeedback)"
//
//
//        if aStrViewFeedback == "1" {
//
//            let aViewController = GSFeedbackViewController()
//            aViewController.gIsComment = true
//            aViewController.gIsReview = false
//            aViewController.gGigId = (myAryFilterInfo[(indexPath?.row)!]["gigs_id"] as? String)!
//            aViewController.gOrderId = (myAryFilterInfo[(indexPath?.row)!]["order_id"] as? String)!
//            aViewController.gFromUserId = (myAryFilterInfo[(indexPath?.row)!]["user_id"] as? String)!
//            let aNavi = UINavigationController(rootViewController: aViewController)
//            self.present(aNavi, animated: true, completion: nil)
//
//        }
//        else if aStrViewFeedback == "2" {
//
//            let aViewController = GSFeedbackViewController()
//            aViewController.gIsComment = false
//            aViewController.gIsReview = true
//            aViewController.gGigId = (myAryFilterInfo[(indexPath?.row)!]["gigs_id"] as? String)!
//            aViewController.gOrderId = (myAryFilterInfo[(indexPath?.row)!]["order_id"] as? String)!
//            aViewController.gFromUserId = (myAryFilterInfo[(indexPath?.row)!]["user_id"] as? String)!
//            let aNavi = UINavigationController(rootViewController: aViewController)
//            self.present(aNavi, animated: true, completion: nil)
//
//        }
    }
    
    // Order Status Button Clicked
    @objc func orderStatusButtonClicked(sender: UIButton) {
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.myTableView)
        let indexPath = self.myTableView.indexPathForRow(at: buttonPosition)
      
        if mySegmentedControl.selectedIndex == 1 {
            
            let aViewController = GSPaymentCancelViewController()
            aViewController.gDicPaymentCancelInfo = myAryFilterInfo[(indexPath?.row)!]
            aViewController.delegate = self
            aViewController.gBoolIsFromCancel = false
            aViewController.gBoolIsFromOrderStatus = true
            aViewController.gBoolIsFromFeedback = false
            aViewController.gIntSelectedIndex = mySegmentedControl.selectedIndex
            
            let width = ModalSize.custom(size: 320)
            let height = ModalSize.custom(size: 150)
            
            let center = ModalCenterPosition.center
            let customType = PresentationType.custom(width: width, height: height, center: center)
            
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.transitionType = .coverVertical
            customPresenter.dismissTransitionType = .coverVertical
            customPresenter.roundCorners = true
            customPresenter.dismissOnSwipe = false
            customPresenter.dismissOnSwipeDirection = .top
            customPresenter.blurStyle = .light
            customPresenter.blurBackground = true
            
            self.customPresentViewController(customPresenter, viewController: aViewController, animated: true, completion: nil)
        }
        
        else {
            
           // callCompleteRequestApi(indexpath: indexPath!)
        }
    }
    
    
    @objc func requestButtonClicked(sender: UIButton) {
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.myTableView)
        let indexPath = self.myTableView.indexPathForRow(at: buttonPosition)
        let aOrderId = myAryFilterInfo[(indexPath?.row)!]["order_id"] as? String
        aAmountWithdrawApi(orderId: aOrderId!, indexPath: indexPath!)
    }
    
    // MARK: - Left Bar Button Methods
    
    func setUpLeftBarButton() {
        
        let close = UIBarButtonItem(image: UIImage(named: ICON_CLOSE), style: .plain, target: self, action: #selector(closeBarBtnTapped))
        
        self.navigationItem.leftBarButtonItems = [close]
        navigationController?.navigationBar.tintColor = .white
    }
    @objc func closeBarBtnTapped() {
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

}

//
//  GSPaymentCancelViewController.swift
//  Gigs
//
//  Created by user on 05/04/2018.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit
import Presentr
import DropDown


//MARK: - Protocol Delegate
protocol ClassPaymentCancelDelegate: class {
    func callActivityApiAndReloadList(selectedIndex : Int)
}

class GSPaymentCancelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var myLabelPageTitle: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myBtnUpdate: UIButton!
    @IBOutlet weak var myLabelCancelReason: UILabel!
    @IBOutlet weak var myViewOrderStatus: UIView!
    @IBOutlet weak var myViewCancel: UIView!
    @IBOutlet weak var myBtnUpdateOrderStatus: UIButton!
    @IBOutlet weak var myTxtFldOrderStatusTitle: UITextField!
    @IBOutlet weak var myBtnOrderStatusTitle: UIButton!
    @IBOutlet weak var myViewCancelRequest: UIView!
    @IBOutlet weak var myLblCancelReason: UILabel!
    @IBOutlet weak var myBtnCancelAccept: UIButton!
    
    let cellPaymentCancelIdentifier = "GSPaymentCancelTableViewCell"
    let cellPaymentCancelStripeIdentifier = "GSPaymentCancelStripeTableViewCell"
    
    let dropDown = DropDown()
    
    weak var delegate: ClassPaymentCancelDelegate?
    
    var myAryPaymentCancelInfo = [[String:Any]]()
    var gDicPaymentCancelInfo = [String:Any]()
    var myFilteredArrayDropDownInfo = [String]()
    
    var gStrPaymentSource = String()
    var gIntSelectedIndex = Int()
    var gBoolIsFromCancel = Bool()
    var gBoolIsFromOrderStatus = Bool()
    var gBoolIsFromFeedback = Bool()
    
    let KTITLE: String = "title"
    let KPLACEHOLDER : String = "placeholder"
    
    let TAG_REASON : Int = 10
    let TAG_EMAIL_ID: Int = 20
    let TAG_ACC_HOLDER_NAME: Int = 20
    let TAG_ACC_NO: Int = 30
    let TAG_IBAN: Int = 40
    let TAG_BANK_NAME : Int = 50
    let TAG_BANK_ADDRESS : Int = 60
    let TAG_SORT_CODE : Int = 70
    let TAG_ROUTING_NUMBER : Int = 80
    let TAG_IFSC_CODE : Int = 90
    let TAG_ORDER_STATUS : Int = 100
    
    var myStrReason = String()
    var myStrEmailId = String()
    var myStrAccHolderName = String()
    var myStrAccNo = String()
    var myStrIBAN = String()
    var myStrBankName = String()
    var myStrBankAddress = String()
    var myStrSortCode = String()
    var myStrRoutingNo = String()
    var myStrIFSC = String()
    var myStrOrderStatusTitle = String()
    var myStrOrderStatusId = String()
    var myDictDetails = [String:String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpUI()
        setUpModel()
        loadModel()
    }

    
    //MARK: - View Initialize
    
    func setUpUI() {
        
        myTableView.register(UINib.init(nibName: cellPaymentCancelIdentifier, bundle: nil), forCellReuseIdentifier: cellPaymentCancelIdentifier)
         myTableView.register(UINib.init(nibName: cellPaymentCancelStripeIdentifier, bundle: nil), forCellReuseIdentifier: cellPaymentCancelStripeIdentifier)
        HELPER.setRoundCornerView(aView: myBtnUpdate, borderRadius: 5.0)
        
        if gBoolIsFromFeedback {
            
            
        }
        
        else if gBoolIsFromCancel {
            
            myViewCancel.isHidden = false
            myViewOrderStatus.isHidden = true
            myViewCancelRequest.isHidden = true
            
            let aStrViewReason = gDicPaymentCancelInfo["order_cancel"] as? String
            if aStrViewReason == "View Reason" {
                
                myLabelPageTitle.isHidden = true
                myTableView.isHidden = true
                myBtnUpdate.isHidden = true
                myLabelCancelReason.isHidden = false
            }
                
            else if aStrViewReason == "Cancel Request" {
                
                myViewCancel.isHidden = true
                myViewCancelRequest.isHidden = false
                HELPER.setRoundCornerView(aView: myBtnCancelAccept, borderRadius: 5.0)
                myLblCancelReason.text = gDicPaymentCancelInfo["cancel_reason"] as? String
            }
                
            else {
                
                myLabelCancelReason.isHidden = true
                myLabelPageTitle.isHidden = false
                myTableView.isHidden = false
                myBtnUpdate.isHidden = false
            }
        }
        
        
        else if gBoolIsFromOrderStatus {
            
            myLabelPageTitle.text = "Change your Status"
            myViewCancel.isHidden = true
            myViewCancelRequest.isHidden = true
            myViewOrderStatus.isHidden = false
            HELPER.setRoundCornerView(aView: myBtnUpdateOrderStatus, borderRadius: 5.0)
            myTxtFldOrderStatusTitle.tag = TAG_ORDER_STATUS
            myBtnOrderStatusTitle.setTitle("Choose Order Status", for: .normal)
            dropDown.backgroundColor = UIColor.white
        }
        
    }
    
    func setUpModel() {
        
        if gBoolIsFromFeedback {
            
            
        }
            
        else if gBoolIsFromCancel {
            
            if gStrPaymentSource == "stripe" || gStrPaymentSource == "Stripe" {
                
//                myAryPaymentCancelInfo = [[KTITLE: CONTENT_TITLE_REASON, KPLACEHOLDER: "Enter Reason"],[KTITLE: CONTENT_TITLE_ACC_HOLDER_NAME, KPLACEHOLDER: ""],[KTITLE: CONTENT_TITLE_ACC_NO, KPLACEHOLDER: ""],[KTITLE: CONTENT_TITLE_IBAN, KPLACEHOLDER: ""],[KTITLE: CONTENT_TITLE_BANK_NAME, KPLACEHOLDER: ""],[KTITLE: CONTENT_TITLE_BANK_ADDRESS, KPLACEHOLDER: ""],[KTITLE: CONTENT_TITLE_SORT_CODE, KPLACEHOLDER: "UK Bank code (6 digits usually displayed as 3 pairs of numbers)"],[KTITLE: CONTENT_TITLE_ROUTING_NUMBER, KPLACEHOLDER: "The American Bankers Association Number (consists of 9 digits) and is also called a ABA Routing Number"],[KTITLE: CONTENT_TITLE_IFSC_CODE, KPLACEHOLDER: "Financial System Code, which is a unique 11-digit code that identifies the bank branch i.e. ICIC0001245"]]
                
                myAryPaymentCancelInfo = [[KTITLE: CONTENT_TITLE_REASON, KPLACEHOLDER: "Enter Reason"]]
            }
                
            else if gStrPaymentSource == "paypal" || gStrPaymentSource == "Paypal"{
                
                myAryPaymentCancelInfo = [[KTITLE: CONTENT_TITLE_REASON, KPLACEHOLDER: "Enter Reason"],[KTITLE: CONTENT_TITLE_PAYPAL_EMAIL_ID, KPLACEHOLDER: "abc@gmail.com"]]
            }
        }
            
            
        else if gBoolIsFromOrderStatus {
            
            myFilteredArrayDropDownInfo = ["Pending","Processing","Declined","Completed"]
        }
        
        
        
    }
    
    func loadModel() {
        
        myDictDetails = SESSION.getUserStripeInfo()
        
        if myDictDetails.count > 0 {
            
            myStrAccHolderName = myDictDetails["account_holder_name"]!
            myStrAccNo = myDictDetails["account_number"]!
            myStrIBAN = myDictDetails["account_iban"]!
            myStrBankName = myDictDetails["bank_name"]!
            myStrBankAddress = myDictDetails["bank_address"]!
            myStrSortCode = myDictDetails["sort_code"]!
            myStrRoutingNo = myDictDetails["routing_number"]!
            myStrIFSC = myDictDetails["account_ifsc"]!
        }
        
    }
    
    //MARK: - TableView Delegate and DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myAryPaymentCancelInfo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell:GSPaymentCancelTableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellPaymentCancelIdentifier) as? GSPaymentCancelTableViewCell)!
        
        if gStrPaymentSource == "stripe" || gStrPaymentSource == "Stripe" {
            
            let aCell:GSPaymentCancelStripeTableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellPaymentCancelStripeIdentifier) as? GSPaymentCancelStripeTableViewCell)!
            
            if indexPath.row == 0 {
                
                HELPER.setBorderView(aView: aCell.gContainerView, borderWidth: 1, borderColor: UIColor.gray, cornerRadius: 5)
                aCell.gLblTitle.text = myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
                aCell.gTxtViewReason.text = myStrReason
                aCell.gTxtViewReason.delegate = self
                aCell.gTxtViewReason.returnKeyType = UIReturnKeyType.done
                aCell.gLblReason.isHidden = true
                
                if SESSION.getUserStripeInfo().count == 0 {
                    aCell.gLblReason.isHidden = false
                }
                else {
                    aCell.gLblReason.isHidden = true
                }
            }
            
            return aCell
            
//            if indexPath.row == 0 {
//
//                aCell.gLabelTitle.text = myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
//                aCell.gTextFieldContent.tag = TAG_REASON
//                aCell.gTextFieldContent.placeholder = myAryPaymentCancelInfo[indexPath.row][KPLACEHOLDER] as? String
//                aCell.gTextFieldContent.text = myStrReason
//
//                aCell.gTextFieldContent.delegate = self
//                aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
//            }
//
//            else if indexPath.row == 1 {
//
//                aCell.gLabelTitle.text = myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
//                aCell.gTextFieldContent.tag = TAG_ACC_HOLDER_NAME
//                aCell.gTextFieldContent.placeholder = myAryPaymentCancelInfo[indexPath.row][KPLACEHOLDER] as? String
//                aCell.gTextFieldContent.text = myStrAccHolderName
//
//                aCell.gTextFieldContent.delegate = self
//                aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
//            }
//
//            else if indexPath.row == 2 {
//
//                aCell.gLabelTitle.text = myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
//                aCell.gTextFieldContent.tag = TAG_ACC_NO
//                aCell.gTextFieldContent.placeholder = myAryPaymentCancelInfo[indexPath.row][KPLACEHOLDER] as? String
//                aCell.gTextFieldContent.text = myStrAccNo
//
//                aCell.gTextFieldContent.delegate = self
//                aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
//            }
//
//            else if indexPath.row == 3 {
//
//                aCell.gLabelTitle.text = myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
//                aCell.gTextFieldContent.tag = TAG_IBAN
//                aCell.gTextFieldContent.placeholder = myAryPaymentCancelInfo[indexPath.row][KPLACEHOLDER] as? String
//                aCell.gTextFieldContent.text = myStrIBAN
//
//                aCell.gTextFieldContent.delegate = self
//                aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
//            }
//
//            else if indexPath.row == 4 {
//
//                aCell.gLabelTitle.text = myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
//                aCell.gTextFieldContent.tag = TAG_BANK_NAME
//                aCell.gTextFieldContent.placeholder = myAryPaymentCancelInfo[indexPath.row][KPLACEHOLDER] as? String
//                aCell.gTextFieldContent.text = myStrBankName
//
//                aCell.gTextFieldContent.delegate = self
//                aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
//            }
//
//            else if indexPath.row == 5 {
//
//                aCell.gLabelTitle.text = myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
//                aCell.gTextFieldContent.tag = TAG_BANK_ADDRESS
//                aCell.gTextFieldContent.placeholder = myAryPaymentCancelInfo[indexPath.row][KPLACEHOLDER] as? String
//                aCell.gTextFieldContent.text = myStrBankAddress
//
//                aCell.gTextFieldContent.delegate = self
//                aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
//            }
//
//            else if indexPath.row == 6 {
//
//                aCell.gLabelTitle.text = myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
//                aCell.gTextFieldContent.tag = TAG_SORT_CODE
//                aCell.gTextFieldContent.placeholder = myAryPaymentCancelInfo[indexPath.row][KPLACEHOLDER] as? String
//                aCell.gTextFieldContent.text = myStrSortCode
//
//                aCell.gTextFieldContent.delegate = self
//                aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
//            }
//
//            else if indexPath.row == 7 {
//
//                aCell.gLabelTitle.text = myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
//                aCell.gTextFieldContent.tag = TAG_ROUTING_NUMBER
//                aCell.gTextFieldContent.placeholder = myAryPaymentCancelInfo[indexPath.row][KPLACEHOLDER] as? String
//                aCell.gTextFieldContent.text = myStrRoutingNo
//
//                aCell.gTextFieldContent.delegate = self
//                aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
//            }
//
//            else if indexPath.row == 8 {
//
//                aCell.gLabelTitle.text = myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
//                aCell.gTextFieldContent.tag = TAG_IFSC_CODE
//                aCell.gTextFieldContent.placeholder = myAryPaymentCancelInfo[indexPath.row][KPLACEHOLDER] as? String
//                aCell.gTextFieldContent.text = myStrIFSC
//
//                aCell.gTextFieldContent.delegate = self
//                aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
//            }
            
        }
        
        else if gStrPaymentSource == "paypal" || gStrPaymentSource == "Paypal" {
            
            myStrEmailId = SESSION.getPaypalId()
        
            let aCell:GSPaymentCancelTableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellPaymentCancelIdentifier) as? GSPaymentCancelTableViewCell)!
            
            if indexPath.row == 0 {
                
                aCell.gLabelTitle.text = myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
                aCell.gTextFieldContent.tag = TAG_REASON
                aCell.gTextFieldContent.placeholder = myAryPaymentCancelInfo[indexPath.row][KPLACEHOLDER] as? String
                aCell.gTextFieldContent.text = myStrReason
                
                aCell.gTextFieldContent.delegate = self
                aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
            }
                
            else if indexPath.row == 1 {
                
                aCell.gLabelTitle.text = myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
                aCell.gTextFieldContent.tag = TAG_EMAIL_ID
                aCell.gTextFieldContent.placeholder = myAryPaymentCancelInfo[indexPath.row][KPLACEHOLDER] as? String
                aCell.gTextFieldContent.text = myStrEmailId
                
                aCell.gTextFieldContent.delegate = self
                aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
                aCell.gTextFieldContent.keyboardType = UIKeyboardType.emailAddress
            }
            return aCell
        }
        return aCell
    }
    
    // MARK: - TextView Delegate
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let textViewText: NSString = (textView.text ?? "") as NSString
        let txtAfterUpdate = textViewText.replacingCharacters(in: range, with: text)
        
        myStrReason = txtAfterUpdate
        
        return true
    }
    
    
    //MARK: - Textfield Delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        dropDown.hide()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
        
        if gBoolIsFromFeedback {
            
        
        }
            
        else if gBoolIsFromCancel {
            
            if gStrPaymentSource == "stripe" || gStrPaymentSource == "Stripe" {
                
                if textField.tag == TAG_REASON {
                    
                    myStrReason = txtAfterUpdate
                }
                    
                else if textField.tag == TAG_ACC_HOLDER_NAME {
                    
                    myStrAccHolderName = txtAfterUpdate
                }
                    
                else if textField.tag == TAG_ACC_NO {
                    
                    myStrAccNo = txtAfterUpdate
                }
                    
                else if textField.tag == TAG_IBAN {
                    
                    myStrIBAN = txtAfterUpdate
                }
                    
                else if textField.tag == TAG_BANK_NAME {
                    
                    myStrBankName = txtAfterUpdate
                }
                    
                else if textField.tag == TAG_BANK_ADDRESS {
                    
                    myStrBankAddress = txtAfterUpdate
                }
                    
                else if textField.tag == TAG_SORT_CODE {
                    
                    myStrSortCode = txtAfterUpdate
                }
                    
                else if textField.tag == TAG_ROUTING_NUMBER {
                    
                    myStrRoutingNo = txtAfterUpdate
                }
                    
                else if textField.tag == TAG_IFSC_CODE {
                    
                    myStrIFSC = txtAfterUpdate
                }
            }
                
            else if gStrPaymentSource == "paypal" || gStrPaymentSource == "Paypal" {
                
                if textField.tag == TAG_REASON {
                    
                    myStrReason = txtAfterUpdate
                }
                    
                else if textField.tag == TAG_EMAIL_ID {
                    
                    myStrEmailId = txtAfterUpdate
                }
            }
        }
            
            
        else if gBoolIsFromOrderStatus {
            
            
        }
        
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.returnKeyType == UIReturnKeyType.next {
            
            self.myTableView .viewWithTag(textField.tag + 10)?.becomeFirstResponder()
        }
            
        else {
            
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    //MARK: - Api Call
    
    // Stripe Cancel Api Call
    func callStripeCancelApi() {
    
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingAnimationWithDefaultTitle()
        
        
        var aDicParams = ["time_zone":TimeZone.current.identifier, "order_id":gDicPaymentCancelInfo["order_id"], "user_id":SESSION.getUserId(), "cancel_reason":myStrReason, "account_holder_name":myStrAccHolderName, "account_number":myStrAccNo, "account_iban":myStrIBAN, "bank_name":myStrBankName, "bank_address":myStrBankAddress, "sort_code":myStrSortCode, "routing_number": myStrRoutingNo ,"account_ifsc": myStrIFSC] as! [String:String]
        aDicParams[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_STRIPE_PAYMENT_CANCEL, dictParameters: aDicParams, sucessBlock: { (response) in

//        HTTPMANAGER.stripePaymentCancelSericeRequest(parameter: aDicParams, SucessBlock: {response in
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                HELPER.hideLoadingAnimation()
                HELPER.showNotificationInAlertSucess(aStrMessage: aMessageResponse, inView: self.view)
                self.dismiss(animated: true, completion: {
                    self.delegate?.callActivityApiAndReloadList(selectedIndex: self.gIntSelectedIndex)
                })
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
    
    
    // Paypal Cancel Api Call
    func callPaypalCancelApi() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingAnimationWithDefaultTitle()
        
        var aDicParams = [String:String]()
        
        if gStrPaymentSource == "stripe" || gStrPaymentSource == "Stripe" {
            
            aDicParams = ["order_id": gDicPaymentCancelInfo["order_id"], "cancel_reason": myStrReason,"time_zone": TimeZone.current.identifier,"cancel_by":"stripe"] as! [String:String]
            aDicParams[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
        }
        else if gStrPaymentSource == "paypal" || gStrPaymentSource == "Paypal" {
            
            aDicParams = ["order_id": gDicPaymentCancelInfo["order_id"], "cancel_reason": myStrReason, "paypal_email": myStrEmailId,"time_zone": TimeZone.current.identifier,"cancel_by":"paypal"] as! [String:String]
            aDicParams[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
        }
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_PAYPAL_PAYMENT_CANCEL, dictParameters: aDicParams, sucessBlock: { (response) in

            
//        HTTPMANAGER.paypalPaymentCancelSericeRequest(parameter: aDicParams, SucessBlock: {response in
            
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                HELPER.hideLoadingAnimation()
                HELPER.showNotificationInAlertSucess(aStrMessage: aMessageResponse, inView: self.view)
                self.dismiss(animated: true, completion: {
                    self.delegate?.callActivityApiAndReloadList(selectedIndex: self.gIntSelectedIndex)
                })
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
    
    // Set Order Status Api Call
    func setOrderStatusApiCall() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingAnimationWithDefaultTitle()
        
        
        var aDicParams = ["order_id": gDicPaymentCancelInfo["order_id"], "order_status": myStrOrderStatusId, "time_zone": TimeZone.current.identifier] as! [String:String]
        aDicParams[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_ORDER_STATUS, dictParameters: aDicParams, sucessBlock: { (response) in

//        HTTPMANAGER.orderStatusApiRequest(parameter: aDicParams, SucessBlock: {response in
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                HELPER.hideLoadingAnimation()
                HELPER.showNotificationInAlertSucess(aStrMessage: aMessageResponse, inView: self.view)
                self.dismiss(animated: true, completion: {
                    self.delegate?.callActivityApiAndReloadList(selectedIndex: self.gIntSelectedIndex)
                })
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

    //MARK: - Button Actions
    
    
    // Cancel Button Action
    @IBAction func myBtnCancelAction(_ sender: Any) {
        
        if gStrPaymentSource == "stripe" || gStrPaymentSource == "Stripe" {
            
            if (self.myStrReason.count == 0) {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_REASON, aStrMessage: ALERT_REASON_FIELD)
            }
            else {
                
                callPaypalCancelApi()
            }
            
//            if (self.myStrReason.count == 0) && (self.myStrAccHolderName.count == 0)  && (self.myStrAccNo.count == 0) && (self.myStrBankName.count == 0) && (self.myStrBankAddress.count == 0) && (self.myStrSortCode.count == 0) && (self.myStrRoutingNo.count == 0) && (self.myStrIFSC.count == 0){
//
//                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_REQUIRED_FIELDS)
//            }
//
//            else if(self.myStrReason.count == 0) {
//
//                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_REASON, aStrMessage: ALERT_REASON_FIELD)
//            }
//
//            else if(self.myStrAccHolderName.count == 0) {
//
//                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_ACCOUNT_HOLDER_NAME, aStrMessage: ALERT_ACCOUNT_HOLDER_NAME_FIELD)
//            }
//
//            else if(self.myStrAccNo.count == 0) {
//
//                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_ACCOUNT_NO, aStrMessage: ALERT_ACCOUNT_NO_FIELD)
//            }
//
//            else if(self.myStrBankName.count == 0) {
//
//                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_BANK_NAME, aStrMessage: ALERT_BANK_NAME_FIELD)
//            }
//
//            else if(self.myStrBankAddress.count == 0) {
//
//                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_BANK_ADDRESS, aStrMessage: ALERT_BANK_ADDRESS_FIELD)
//            }
//
//            else if(self.myStrSortCode.count == 0) {
//
//                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_SORT_CODE, aStrMessage: ALERT_SORT_CODE_FIELD)
//            }
//
//            else if(self.myStrRoutingNo.count == 0) {
//
//                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_ROUTING_NUMBER, aStrMessage: ALERT_ROUTING_NUMBER_FIELD)
//            }
//
//            else if(self.myStrIFSC.count == 0) {
//
//                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_IFSC_CODE, aStrMessage: ALERT_IFSC_CODE_FIELD)
//            }
//
//            else {
//
//                callStripeCancelApi()
//            }
        }
        
        else if gStrPaymentSource == "paypal" || gStrPaymentSource == "Paypal" {
            
            if (self.myStrReason.count == 0) && (self.myStrEmailId.count == 0) {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_REQUIRED_FIELDS)
            }
                
            else if(self.myStrReason.count == 0) {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_REASON, aStrMessage: ALERT_REASON_FIELD)
            }
                
            else if(self.myStrEmailId.count == 0) {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_EMAIL_ID, aStrMessage: ALERT_EMPTY_FIELD)
            }
                
            else if !HELPER.isValidEmailAddress(emailAddressString: self.myStrEmailId) {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_EMAIL_ID, aStrMessage: ALERT_EMAIL_ID_NOTVALID)
            }
            
            else {
                
                callPaypalCancelApi()
            }
            
        }
        
    }
    
    
    @IBAction func myBtnOrderStatusDropdownAction(_ sender: Any) {
        
        dropDown.anchorView = myBtnOrderStatusTitle
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dataSource = myFilteredArrayDropDownInfo
        dropDown.show()
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                
            self.myBtnOrderStatusTitle.setTitle(item, for: .normal)
            self.myStrOrderStatusTitle = item
            self.dropDown.hide()
            
            switch self.myStrOrderStatusTitle
            {
            case "Pending":
                self.myStrOrderStatusId = "2"
            case "Processing":
                self.myStrOrderStatusId = "3"
            case "Declined":
                self.myStrOrderStatusId = "5"
            case "Complete Accepted":
                self.myStrOrderStatusId = "8"
            case "Completed":
                self.myStrOrderStatusId = "6"
            default:
                break;
            }
        }
    }
    
    // Order Status Button Action
    @IBAction func myBtnUpdateOrderStatusAction(_ sender: Any) {
        
        setOrderStatusApiCall()
    }
    
    @IBAction func myBtnCancelAcceptAction(_ sender: Any) {
    }
    

}

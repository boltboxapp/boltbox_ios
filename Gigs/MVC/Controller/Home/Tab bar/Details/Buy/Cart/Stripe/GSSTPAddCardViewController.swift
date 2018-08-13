//
//  GSSTPAddCardViewController.swift
//  Gigs
//
//  Created by user on 21/03/2018.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit
import Stripe
import FormTextField
class GSSTPAddCardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myBtnPay: UIButton!
    
    let cellStripeItemsIdentifier = "GSStripeTableViewCell"
    let KMENUTITLE: String = "title"
    
    let TAG_CARD_NUMBER : Int = 10
    let TAG_CARD_EXPIRY : Int = 20
    let TAG_CARD_CVV: Int = 30
    
    var myAryInfo = [[String:String]]()
    
    var gGigOrderId = String()
    var gGigPrice = Int()
    var gGigCurrency = String()
    var gGigName = String()
    
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
    
    //MARK: - View Initialize
    func setUpUI() {
        
        setUpLeftBarBackButton()
        
        NAVIGAION.setNavigationTitle(aStrTitle: "Payment Details", aViewController: self)
        
        let aStrCurrencySymbole = getSymbol(forCurrencyCode: gGigCurrency)
        
        myBtnPay.setTitle(String(format: "%@ %@%@", "Pay", aStrCurrencySymbole!, String(gGigPrice)), for: .normal)
        
        myTableView.register(UINib.init(nibName: cellStripeItemsIdentifier, bundle: nil), forCellReuseIdentifier: cellStripeItemsIdentifier)
        
        myTableView.estimatedRowHeight = UITableViewAutomaticDimension
    }
    
    func setUpModel() {
        
        myAryInfo = [[KMENUTITLE : STRIPE_CARD_NUMBER], [KMENUTITLE : STRIPE_CARD_EXPIRES], [KMENUTITLE : STRIPE_CARD_CVV]]
    }
    
    func loadModel() {
        
    }
    
    
    //MARK: - TableView Delegate and DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return myAryInfo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return myAryInfo.count > 0 ? 50 :  0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell:GSStripeTableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellStripeItemsIdentifier) as? GSStripeTableViewCell)!
        
        aCell.gLabelCardDetails.text = myAryInfo[indexPath.row][KMENUTITLE]
        
        if(myAryInfo[indexPath.row][KMENUTITLE] == STRIPE_CARD_NUMBER) {
            
            aCell.gTextFieldCardDetails.tag = TAG_CARD_NUMBER
            aCell.gTextFieldCardDetails.placeholder = "CARD NUMBER"
            aCell.gTextFieldCardDetails.inputType = .integer
            aCell.gTextFieldCardDetails.formatter = CardNumberFormatter()
            
            var validation = Validation()
            validation.maximumLength = "1234 5678 1234 5678".count
            validation.minimumLength = "1234 5678 1234 5678".count
            let characterSet = NSMutableCharacterSet.decimalDigit()
            characterSet.addCharacters(in: " ")
            validation.characterSet = characterSet as CharacterSet
            let inputValidator = InputValidator(validation: validation)
            aCell.gTextFieldCardDetails.inputValidator = inputValidator
            
        }
            
        else if(myAryInfo[indexPath.row][KMENUTITLE] == STRIPE_CARD_EXPIRES) {
            
            aCell.gTextFieldCardDetails.tag = TAG_CARD_EXPIRY
            aCell.gTextFieldCardDetails.inputType = .integer
            aCell.gTextFieldCardDetails.formatter = CardExpirationDateFormatter()
            aCell.gTextFieldCardDetails.placeholder = "Expiration Date (MM/YY)"
            
            var validation = Validation()
            validation.minimumLength = 1
            let inputValidator = CardExpirationDateInputValidator(validation: validation)
            aCell.gTextFieldCardDetails.inputValidator = inputValidator
        }
            
        else {
            
            aCell.gTextFieldCardDetails.tag = TAG_CARD_CVV
            aCell.gTextFieldCardDetails.inputType = .integer
            aCell.gTextFieldCardDetails.placeholder = "CVC"
            
            var validation = Validation()
            validation.maximumLength = "CVC".count
            validation.minimumLength = "CVC".count
            validation.characterSet = NSCharacterSet.decimalDigits
            let inputValidator = InputValidator(validation: validation)
            aCell.gTextFieldCardDetails.inputValidator = inputValidator
        }
        
        return aCell
    }
    
    
    
    
    //MARK: - Private Functions
    func getSymbol(forCurrencyCode code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        if locale.displayName(forKey: .currencySymbol, value: code) == code {
            let newlocale = NSLocale(localeIdentifier: code.characters.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: code)
        }
        return locale.displayName(forKey: .currencySymbol, value: code)
    }
    
    
    //MARK: - Button Actions
    
    @IBAction func myBtnPayAction(_ sender: Any) {
        
        HELPER.showLoadingAnimation()
        
        let aTxtFieldCardNo = self.view.viewWithTag(TAG_CARD_NUMBER) as! FormTextField
        let aTxtFieldCardExpiry = self.view.viewWithTag(TAG_CARD_EXPIRY) as! FormTextField
        let aTxtFieldCardCVV = self.view.viewWithTag(TAG_CARD_CVV) as! FormTextField
        
        let validCardNumber = aTxtFieldCardNo.validate()
        let validCardExpirationDate = aTxtFieldCardExpiry.validate()
        let validCVC = aTxtFieldCardCVV.validate()
        
        var aStrMonth = Int()
        var aStrYear = Int()
        
        
        let aExpirationDate = aTxtFieldCardExpiry.text?.components(separatedBy: "/")
        
        aStrMonth = Int(aExpirationDate![0])!
        aStrYear = Int(aExpirationDate![1])!
        
        //        if let range = aTxtFieldCardExpiry.text?.range(of: "/") {
        //            let aStrGetMonth = aTxtFieldCardExpiry.text![aTxtFieldCardExpiry.text!.startIndex..<range.lowerBound]
        //            aStrMonth = Int(aStrGetMonth)! // print Month
        //        }
        //
        //        if let aRange = aTxtFieldCardExpiry.text?.range(of: "/") {
        //            let aStrGetYear = aTxtFieldCardExpiry.text![aRange.upperBound...].trimmingCharacters(in: .whitespaces)
        //            aStrYear = Int(aStrGetYear)!
        //        }
        
        
        if  validCardNumber && validCardExpirationDate && validCVC {
            
            let card: STPCardParams = STPCardParams()
            card.number = aTxtFieldCardNo.text
            card.expMonth = UInt(aStrMonth)
            card.expYear = UInt(aStrYear)
            card.cvc = aTxtFieldCardCVV.text
            
            
            STPAPIClient.shared().createToken(withCard: card) { token, error in
                if let token = token {
                    
                    let aTransactionId = token.tokenId as String
                    print(aTransactionId)
                    let params: [String: Any] = [
                        "tokenid": aTransactionId,
                        "amount": self.gGigPrice,
                        "currency": self.gGigCurrency,
                        "description": self.gGigName
                    ]
                    
                    HTTPMANAGER.callPaymentPostApi(strUrl: WEB_SERVICE_URL+CASE_STRIPE_PAYMENT, dictParameters: params , sucessBlock: { (response) in
                        
                        //        HttpManager.sharedInstance.buySericeRequest(parameter: aDictBuyService , forgetSucessBlock: {response in
                        
                        let aIntResponseCode = response["code"] as! Int
                        let aMessageResponse = response["message"] as! String
                        let aData = response["data"] as! [String:String]
                        let aPaymentTransactionId = aData["transaction_id"]
                        
                        print(response)
                        
                        if aIntResponseCode == RESPONSE_CODE_200 {
                            
//                            HELPER.hideLoadingAnimation()
                            
                            let aParams: [String: Any] = [
                                "item_number": self.gGigOrderId,
                                "paypal_uid": aPaymentTransactionId!
                            ]
                            
                            HTTPMANAGER.callPaymentPostApi(strUrl: WEB_SERVICE_URL+CASE_PAYPAL_SUCCESS_SERVICE, dictParameters: aParams , sucessBlock: { (response) in
                                
                                let aIntResponseCode = response["code"] as! Int
                                let aMessageResponse = response["message"] as! String
                                
                                print(response)
                                
                                if aIntResponseCode == RESPONSE_CODE_200 {
                                    
                                    HELPER.hideLoadingAnimation()
                                    
                                    let aViewController = GSActivityViewController()
                                    self.navigationController?.pushViewController(aViewController, animated: true)
                                    
                                }
                                else {
                                    
                                    HELPER.hideLoadingAnimation()
                                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
                                }
                                
                            }, failureBlock: { error in
                                
                                HELPER.hideLoadingAnimation()
                                HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
                            })
                            
                        }
                        else {
                            
                            HELPER.hideLoadingAnimation()
                            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
                        }
                        
                    }, failureBlock: { error in
                        
                        HELPER.hideLoadingAnimation()
                        HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
                    })
                    
                    
//                    HttpManager.sharedInstance.stripeSuccessRequest(parameter: params , sucessblock: {response in
//
//                        HELPER.hideLoadingAnimation()
//                        print(response)
//                        let aIntResponseCode = response["code"] as! Int
//                        let aMessageResponse = response["message"] as! String
//                        let aData = response["data"] as! [String:String]
//                        let aPaymentTransactionId = aData["transaction_id"]
//
//
//                        if aIntResponseCode == RESPONSE_CODE_200 {
//
//                            HttpManager.sharedInstance.paypalSuccessRequest(item_number:self.gGigOrderId, paypal_id:aPaymentTransactionId!, sucessblock: {response in
//
//                                HELPER.hideLoadingAnimation()
//                                print(response)
//                                let aIntResponseCode = response["code"] as! Int
//                                let aMessageResponse = response["message"] as! String
//
//
//
//                                if aIntResponseCode == RESPONSE_CODE_200 {
//
//                                    let aViewController = GSActivityViewController()
//                                    self.navigationController?.pushViewController(aViewController, animated: true)
//                                }
//
//                                else {
//
//                                    HELPER.hideLoadingAnimation()
//                                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
//                                }
//                            }, failureBlock: { error in
//
//                                HELPER.hideLoadingAnimation()
//                                HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
//                            })
//
//                        }
//
//                        else {
//
//                            HELPER.hideLoadingAnimation()
//                            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
//                        }
//                    }, failureBlock: { error in
//
//                        HELPER.hideLoadingAnimation()
//                        HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
//                    })
                    //                    SVProgressHUD.showSuccessWithStatus("Stripe token successfully received: \(token)")
                    //                    self.postStripeToken(token)
                } else {
                    HELPER.hideLoadingAnimation()
                    HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: (error?.localizedDescription)!)
                }
            }
            
        }
            
        else {
            
            HELPER.hideLoadingAnimation()
            HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: "Card Details is not Valid")
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

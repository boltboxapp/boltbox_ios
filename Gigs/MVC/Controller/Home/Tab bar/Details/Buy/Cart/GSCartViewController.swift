//
//  GSCartViewController.swift
//  Gigs
//
//  Created by user on 19/03/2018.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit
import DLRadioButton
import Stripe
import BraintreeDropIn
import Braintree

class GSCartViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
//    var environment:String = PayPalEnvironmentSandbox {
//        willSet(newEnvironment) {
//            if (newEnvironment != environment) {
//                PayPalMobile.preconnect(withEnvironment: newEnvironment)
//            }
//        }
//    }
    
    
    @IBOutlet weak var myBtnPaypal: DLRadioButton!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myLabelTotAmount: UILabel!
    @IBOutlet weak var myBtnBuyNow: UIButton!
    
    let cellCartItemsIdentifier = "GSCartItemsTableViewCell"
    
    let K_TITLE = "title"
    let K_TITLE_GIG_INFO = "gig_info"
    let K_ARRAYINFO = "aryinfo"
    let K_TITLE_EXTRA_GIG_INFO = "extra_gig_info"
    
    var gAryInfo = [[String:Any]]()
    
    var gAryExtraGigInfo = [[String:Any]]()
    
    var myStrPaymentType = String()
    
    let mySettingsVC = SettingsViewController()
    
//    var payPalConfig = PayPalConfiguration() // default
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpUI()
        setUpModel()
        loadModel()
        
        // Set up payPalConfig
//        payPalConfig.acceptCreditCards = true
//        payPalConfig.merchantName = "Dreamguys"
//        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
//        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
//
//        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
//
//        payPalConfig.payPalShippingAddressOption = .none;
//
//        print("PayPal iOS SDK Version: \(PayPalMobile.libraryVersion())")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        PayPalMobile.preconnect(withEnvironment: environment)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - View initialize
    func setUpUI() {
        
        setUpLeftBarBackButton()
        
        NAVIGAION.setNavigationTitle(aStrTitle: "Cart", aViewController: self)
                
        myTableView.register(UINib.init(nibName: cellCartItemsIdentifier, bundle: nil), forCellReuseIdentifier: cellCartItemsIdentifier)
        
        myBtnPaypal.isHidden = true
        
        myTableView.estimatedRowHeight = UITableViewAutomaticDimension
        HELPER.setRoundCornerView(aView: myBtnBuyNow, borderRadius: 10.0)
        gAryInfo = gAryInfo.reversed()
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
    }
    
    //MARK: - TableView Delegate and DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        
        return gAryInfo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return gAryInfo.count > 0 ? 30 :  0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell:GSCartItemsTableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellCartItemsIdentifier) as? GSCartItemsTableViewCell)!
        
        
        if gAryInfo[indexPath.row][K_TITLE] as? String == K_TITLE_GIG_INFO {
            
            let aAryInfo = gAryInfo[indexPath.row][K_ARRAYINFO] as! [String:Any]
            
            aCell.gLabelItemNo.text = aAryInfo["item_no"] as? String
            aCell.gLabelProductName.text = aAryInfo["gig_name"] as? String
            aCell.gLabelQuantity.text = "1"
            aCell.gLabelTotal.text = String(format: "%@%@", "£", (aAryInfo["gig_price"] as? String)!)
            let aFloatTotPrice = aAryInfo["total_gig_price"] as? Float
            myLabelTotAmount.text = String(format: "%@%.2f", "£", aFloatTotPrice!)
        }
        
        else if gAryInfo[indexPath.row][K_TITLE] as? String == K_TITLE_EXTRA_GIG_INFO {
            
            let aAryInfo = gAryInfo[indexPath.row][K_ARRAYINFO] as! [String:Any]
            
            aCell.gLabelItemNo.text = ""
            aCell.gLabelProductName.text = aAryInfo["extra_gigs"] as? String
            aCell.gLabelQuantity.text = "1"
            aCell.gLabelTotal.text = String(format: "%@%@", "£", (aAryInfo["extra_gigs_amount"] as? String)!)
        }
        
        return aCell
    }
    
    
//    // PayPalPaymentDelegate
//    
//    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
//        print("PayPal Payment Cancelled")
//        paymentViewController.dismiss(animated: true, completion: nil)
//    }
//    
//    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
//        print("PayPal Payment Success !")
//        paymentViewController.dismiss(animated: true, completion: { () -> Void in
//            // send completed confirmaion to your server
//            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
//        })
//    }
    
    
    //MARK: - Api Call
    
    func callBuyServiceApi()  {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        var aDictBuyService = [String:Any]()
        
        let aAryUserInfo = gAryInfo[0][K_ARRAYINFO] as! [String:Any]
        
        if aAryUserInfo.count != 0 {
            
            aDictBuyService["gig_id"] = aAryUserInfo["gig_id"]
            aDictBuyService["seller_id"] = aAryUserInfo["seller_id"]
            aDictBuyService["gig_rate"] = aAryUserInfo["gig_price"]
            aDictBuyService["super_fast_delivery"] = aAryUserInfo["is_super_fast"]
            aDictBuyService["total_delivery_days"] = aAryUserInfo["total_delivery_days"]
        }
        
        
        aDictBuyService["buyer_id"] = SESSION.getUserId()
        aDictBuyService["source"] = myStrPaymentType
        aDictBuyService[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
        
        var theJSONText = String()

        let invalidJson = "Not a valid JSON"

        var jsonData = Data()

        do {

            jsonData = try JSONSerialization.data(withJSONObject: gAryExtraGigInfo, options: .prettyPrinted)
            theJSONText =  String(bytes: jsonData, encoding: String.Encoding.utf8)!

        } catch {

            print(invalidJson)
        }
        
            aDictBuyService["options"] = theJSONText
        
        HELPER.showLoadingAnimationWithDefaultTitle()
        
        print(aDictBuyService)
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_BUY_SERVICE, dictParameters: aDictBuyService as! [String : String], sucessBlock: { (response) in

//        HttpManager.sharedInstance.buySericeRequest(parameter: aDictBuyService , forgetSucessBlock: {response in
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            print(response)
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                HELPER.hideLoadingAnimation()
                var aGetResponse = response["data"] as! [String:Any]
                
                let aGigAmount = aGetResponse["gig_amount"] as! Int
                let aGigName = aGetResponse["gig_name"] as! String
                let aCurrency = aGetResponse["currency"] as! String
                let aOrderId = String(describing: aGetResponse["gig_order_id"]!)
                if self.myStrPaymentType == "Stripe"{
                    
//                    aGigAmount = aGigAmount * 100
                    
                    let aViewController = GSSTPAddCardViewController()
                    aViewController.gGigName = aGigName
                    aViewController.gGigOrderId = aOrderId
                    aViewController.gGigPrice = aGigAmount
                    aViewController.gGigCurrency = aCurrency
                    self.navigationController?.pushViewController(aViewController, animated: true)
//                    let aViewController = CheckoutViewController(product: aGigName, price: aGigAmount, paymentCurrency: aCurrency, orderId: aOrderId , settings: self.mySettingsVC.settings)
//                    self.navigationController?.pushViewController(aViewController, animated: true)
                }
                
                else {
                    
                    self.showDropIn(clientTokenOrTokenizationKey: "sandbox_zjntcghd_b6sjd8sz2mk6tdz4")
                    
                    
//                    let item1 = PayPalItem(name: aGigName, withQuantity: 1, withPrice: NSDecimalNumber(string: String(aGigAmount)), withCurrency: aCurrency, withSku: "Hip-0037")
//
//                    let items = [item1]
//                    let subtotal = PayPalItem.totalPrice(forItems: items)
//
//                    // Optional: include payment details
////                    let shipping = NSDecimalNumber(string: "5.99")
////                    let tax = NSDecimalNumber(string: "2.50")
//                    let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: nil, withTax: nil)
//
////                    let total = subtotal.adding(shipping).adding(tax)
//
//                    let payment = PayPalPayment(amount: subtotal, currencyCode: aCurrency, shortDescription: aGigName, intent: .sale)
//
//                    payment.items = items
//                    payment.paymentDetails = paymentDetails
//
//                    if (payment.processable) {
//                        let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: self.payPalConfig, delegate: self)
//                        self.present(paymentViewController!, animated: true, completion: nil)
//                    }
//                    else {
//                        // This particular payment will always be processable. If, for
//                        // example, the amount was negative or the shortDescription was
//                        // empty, this payment wouldn't be processable, and you'd want
//                        // to handle that here.
//                        print("Payment not processalbe: \(payment)")
//                    }
                }
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
    
    //MARK: - Button Actions
    
    @IBAction func myBtnBuyNowAction(_ sender: UIButton) {
        
        if myStrPaymentType.count > 0 {
            
            let aFltDuration:Double = 0.5
            
            UIView.animateKeyframes(withDuration: aFltDuration, delay: 0.0, options: .calculationModeLinear, animations: {() -> Void in
                // Zoom out
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: aFltDuration / 2, animations: {() -> Void in
                    
                    sender.transform = sender.transform.scaledBy(x: 0.9, y: 0.9)
                })
                
                // Back to orginal size
                UIView.addKeyframe(withRelativeStartTime: aFltDuration / 2, relativeDuration: aFltDuration / 2, animations: {() -> Void in
                    sender.transform = .identity
                })
            }, completion: {(_ finished: Bool) -> Void in
                
                if finished {
                    
                    self.callBuyServiceApi()
                }
            })
            
        }
        
        else {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: APP_ALERT_TITLE_CHOOSE_PAYMENT_TYPE)
            
        }
    }
    
    
    func showDropIn(clientTokenOrTokenizationKey: String) {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let result = result {
                print(result)
                // Use the BTDropInResult properties to update your UI
                // result.paymentOptionType
                // result.paymentMethod
                // result.paymentIcon
                // result.paymentDescription
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }
    
    
    @IBAction func myBtnpaypalAction(_ sender: Any) {
        myStrPaymentType = "Paypal"
    }
    @IBAction func myBtnStripeAction(_ sender: Any) {
        myStrPaymentType = "Stripe"
    }
    //    // MARK: - Private Functions
//
//    private func createRadioButton(frame : CGRect, title : String, color : UIColor) -> DLRadioButton {
//        let radioButton = DLRadioButton(frame: frame)
//        radioButton.titleLabel!.font = UIFont.systemFont(ofSize: 14)
//        radioButton.setTitle(title, for: [])
//        radioButton.setTitleColor(color, for: [])
//        radioButton.iconColor = color
//        radioButton.indicatorColor = color
//        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
//        radioButton.addTarget(self, action: #selector(self.paymentAction), for: UIControlEvents.touchUpInside)
//        self.view.addSubview(radioButton)
//
//        return radioButton
//    }
    
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

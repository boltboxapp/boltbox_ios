//
//  GSLoginViewController.swift
//  Gigs
//
//  Created by dreams on 03/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSLoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var myViewLogin: UIView!
    @IBOutlet weak var myTxtFldUserName: UITextField!
    @IBOutlet weak var myTxtFldPassword: UITextField!
    
    @IBOutlet weak var myBtnLogin: UIButton!
    @IBOutlet weak var myBtnForgotpswd: UIButton!
    @IBOutlet weak var myBtnRegisternow: UIButton!
    
    var myStrUsername : String = ""
    var myStrPassword : String = ""
    var beforeLoginDrawerMenuselectedStrStatus = false
    
    var gIsFavourites:Bool = false
    var gIsLastVisited:Bool = false
    var gIsMyGigs:Bool = false
    
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
    
//    override func viewWillAppear(_ animated: Bool) {
//
//        NAVIGAION.hideNavigationBar(aViewController: self)
//    }
    
    func setUpUI() {
        
//        NAVIGAION.hideNavigationBar(aViewController: self)
        
        setUpLeftBarBackButton()
        NAVIGAION.setNavigationTitle(aStrTitle: SCREEN_TITLE_LOGIN, aViewController: self)

        self.myBtnLogin.backgroundColor = HELPER.hexStringToUIColor(hex: APP_GREEN_COLOR)
        HELPER.setRoundCornerView(aView: self.myBtnLogin, borderRadius: 7.0)
        HELPER.setBorderView(aView: myViewLogin, borderWidth: 1, borderColor: UIColor.gray, cornerRadius: 5)
        
        myTxtFldUserName.delegate = self
        myTxtFldPassword.delegate = self
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
    }
    
    // MARK: - Textfield Delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
        if textField == myTxtFldPassword {
            if txtAfterUpdate.count <= 15 {
                return true
            }
            else {
                return false
            }
        }
        return true;
    }
    
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        if textfield == self.myTxtFldUserName {
            self.myTxtFldPassword.becomeFirstResponder()
        }
        else if textfield == self.myTxtFldUserName {
            self.myTxtFldPassword.resignFirstResponder()
        }
        else if textfield.returnKeyType == UIReturnKeyType.done {
            textfield.resignFirstResponder()
        }

        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Api Request
    // Push notification
    func pushNotification() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        var dictDeviceId = ["device_id":SESSION.getDeviceId(),"device":"iOS"] as! [String:String]

        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_DEVICE_ID, dictParameters: dictDeviceId, sucessBlock: { (response) in

        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
        
    }
    
    //Login
    func httpRequestForSignIn() {
        // Sign In request

        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "Get ready..")
        
        var dictLoginCrediental = ["username":myTxtFldUserName.text,"password":myTxtFldPassword.text] as! [String:String]
        dictLoginCrediental[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_LOGIN, dictParameters: dictLoginCrediental, sucessBlock: { (response) in
            
            HELPER.hideLoadingAnimation()
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                                
                var aAryResponse = [[String : Any]]()
                aAryResponse = response["data"] as! [[String : Any]]
                
                var dictUserData = [String : Any]()
                dictUserData = aAryResponse[0]
                
                SESSION.setCurrentPassword(password: self.myTxtFldPassword.text!)
                
//                SESSION.setUserId(aStrUserId: dictUserData["userid"]as! String)
//                SESSION.setUserToken(aStrUserToken: dictUserData["unique_code"] as? String ??  "")
                
                SESSION.setUserId(aStrUserId: dictUserData["unique_code"]as! String)
               
                SESSION.setUserName(aStrUserName:dictUserData["username"]as! String)
                SESSION.setUserImage(aStrUserImage: dictUserData["user_profile_image"]as! String)
                SESSION.setUserPriceOption(option: dictUserData["price_option"]as! String, price: dictUserData["gig_price"]as! String, extraprice: dictUserData["extra_gig_price"]as! String)
                SESSION.setPaypalId(aStrPaypalId: dictUserData["paypal_email"]as! String)
                SESSION.setCurrencySign(aStrCurrencySign: dictUserData["default_currency_sign"]as! String)
                
                var aDictTemp = [String:String]()
                aDictTemp = dictUserData["stripe_bank"] as! [String : String]
                
                SESSION.setUserStripeInfo(dictInfo:aDictTemp)
                SESSION.setIsUserLogIN(isLogin: true)
                
                self.pushNotification()
                
                if self.gIsLastVisited == true {
                    self.navigationController?.dismiss(animated: true, completion: nil)
                    let aViewController = GSViewAllGigsViewController()
                    aViewController.gIsLastVisited = true
                    let aNavi = UINavigationController(rootViewController: aViewController)
                    self.present(aNavi, animated: true, completion: nil)
                }
                else if self.gIsMyGigs == true {
                    self.navigationController?.dismiss(animated: true, completion: nil)
                    let aViewController = GSViewAllGigsViewController()
                    aViewController.gIsMyGigs = true
                    let aNavi = UINavigationController(rootViewController: aViewController)
                    self.present(aNavi, animated: true, completion: nil)
                }
                else if self.gIsFavourites == true {
                    self.navigationController?.dismiss(animated: true, completion: nil)
                    let aViewController = GSViewAllGigsViewController()
                    aViewController.gIsFavourites = true
                    let aNavi = UINavigationController(rootViewController: aViewController)
                    self.present(aNavi, animated: true, completion: nil)
                }
                else {
                    APPDELEGATE.loadHomeViewController()
                }
                
            } else {
                HELPER.hideLoadingAnimation()
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    // MARK: - Button Action
    
    @IBAction func myBtnLoginTapped(_ sender: UIButton) {
        
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
                
                if !HELPER.isConnectedToNetwork() {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                    return
                }
                
//                let isPassword = HELPER.isPasswordValid(password: self.myTxtFldPassword.text!)
                
                if (self.myTxtFldUserName.text?.isEmpty)! && (self.myTxtFldPassword.text?.isEmpty)! {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_REQUIRED_FIELDS)
                }
                    
                else if (self.myTxtFldUserName.text?.isEmpty)! {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_EMAIL_ID, aStrMessage: ALERT_EMPTY_FIELD)
                }
                    
                else if (self.myTxtFldPassword.text?.isEmpty)! {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_PASSWORD, aStrMessage: ALERT_PASSWORD_FIELD)
                }
                    
//                else if !isPassword {
//
//                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_PASSWORD, aStrMessage: ALERT_PASSWORD)
//                }
                    
                else {
                    
                    self.httpRequestForSignIn()
                    
                }
            }
        })
    }
    
    @IBAction func myBtnForgotPswdTapped(_ sender: Any) {
        
        let aViewController = GSForgetPasswordViewController()
        self.navigationController?.pushViewController(aViewController, animated: true)
    }
    
    @IBAction func myBtnRegisternowTapped(_ sender: Any) {
        
        let aViewController = GSRegisterViewController()
        self.navigationController?.pushViewController(aViewController, animated: true)
    }
    
    // MARK : - Left Bar Button Methods
    
    func setUpLeftBarBackButton() {
        
        let leftBtn = UIButton(type: .custom)
        leftBtn.setImage(UIImage(named: ICON_BACK), for: .normal)
        leftBtn.frame = CGRect(x: 320, y: 0, width: 30, height: 30)
        
        leftBtn.addTarget(self, action: #selector(questionBackBtnTapped), for: .touchUpInside)
        
        let leftBarBtnItem = UIBarButtonItem(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftBarBtnItem
    }
    
    @objc func questionBackBtnTapped() {
        
        if SESSION.isAppLaunchFirstTime() == false  {
            
            APPDELEGATE.loadHomeViewController()
        }
            
        else {
            let controllers =  self.navigationController?.viewControllers
            var isHaveHomeScreen = false
            for vc in controllers! {
                if vc.isKind(of: GSHomeViewController.self) {
                    isHaveHomeScreen = true
                    let vcontroller  = vc as! GSHomeViewController
                    self.navigationController?.popToViewController(vcontroller, animated: true)
                }
                
            }
            if isHaveHomeScreen == false {
                
                APPDELEGATE.loadHomeViewController()
            }
        }
        
    }
}

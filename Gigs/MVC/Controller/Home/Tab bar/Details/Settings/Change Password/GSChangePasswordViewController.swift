//
//  GSChangePasswordViewController.swift
//  Gigs
//
//  Created by Dreamguys on 13/03/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSChangePasswordViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var myContainerView: UIView!
    @IBOutlet var myTxtFldOldPwd: UITextField!
    @IBOutlet var myTxtFldNewPwd: UITextField!
    @IBOutlet var myTxtFldCnfrmPwd: UITextField!
    @IBOutlet var myBtnChangePassword: UIButton!
    
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
        
        NAVIGAION.setNavigationTitle(aStrTitle: SCREEN_TITLE_CHANGE_PASSWORD, aViewController: self)
        setUpLeftBarBackButton()
        
        self.myBtnChangePassword.backgroundColor = HELPER.hexStringToUIColor(hex: APP_GREEN_COLOR)
        HELPER.setRoundCornerView(aView: self.myBtnChangePassword, borderRadius: 7.0)
        HELPER.setBorderView(aView: myContainerView, borderWidth: 1, borderColor: UIColor.gray, cornerRadius: 5)
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
    }
    
    //MARK: - Textfield Delegate
    
    //MARK: - Text field delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == myTxtFldOldPwd) {
            
            myTxtFldOldPwd.resignFirstResponder()
            myTxtFldNewPwd.becomeFirstResponder()
        }
            
        else if (textField == myTxtFldNewPwd) {
            
            myTxtFldNewPwd.resignFirstResponder()
            myTxtFldCnfrmPwd.becomeFirstResponder()
            
        } else {
            
            myTxtFldCnfrmPwd.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    
    // MARK: - Api call
    
    func httpRequestForChangePassword() {

        var dictForgetPassword = [String:String]()
        dictForgetPassword["current_password"] = myTxtFldOldPwd.text
        dictForgetPassword["new_password"] = myTxtFldCnfrmPwd.text
        //dictForgetPassword["id"] = SESSION.getUserId()
        dictForgetPassword[kDEVICE_TYPE] = kDEVICE_TYPE_IOS

        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "Loading..")
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_CHANGE_PASSWORD, dictParameters: dictForgetPassword, sucessBlock: { (response) in

//        HTTPMANAGER.changePasswordRequest(parameter: dictForgetPassword, confirmPasswordSucessBlock: { response in

            HELPER.hideLoadingAnimation()

            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String

            if aIntResponseCode == RESPONSE_CODE_200 {

                HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse, okActionBlock: { (okAction) in

                    self.navigationController?.popViewController(animated: true)
                })
            }
            else {

                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }

        }, failureBlock: { error in

            HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    // MARK: - Button Action
    
    @IBAction func btnChangePasswordTapped(_ sender: Any) {
        
        
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        let isNewPassword = isPasswordValid(password: myTxtFldNewPwd.text!)
        let isConfirmPassword = isPasswordValid(password: myTxtFldCnfrmPwd.text!)
        
        if (myTxtFldNewPwd.text?.isEmpty)! && (myTxtFldCnfrmPwd.text?.isEmpty)! && (myTxtFldOldPwd.text?.isEmpty)! {

            let alert = UIAlertController(title: "", message: "Please provide the required information.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            
        else if (myTxtFldOldPwd.text?.isEmpty)! {
            
            let alert = UIAlertController(title: "Old Password", message: "Cannot be blank", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            
//        else if myTxtFldOldPwd.text != SESSION.getCurrentPassword() {
//
//            let alert = UIAlertController(title: "Old Password", message: "Old password is not match", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
            
        else if (myTxtFldNewPwd.text?.isEmpty)! {
            
            let alert = UIAlertController(title: "New Password", message: "Cannot be blank", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            
        else if !isNewPassword {
            
            let alert = UIAlertController(title: "New Password", message: ALERT_PASSWORD, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            
        else if (myTxtFldCnfrmPwd.text?.isEmpty)! {
            
            let alert = UIAlertController(title: "Confirm Password", message: "Cannot be blank", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            
        else if !isConfirmPassword {
            
            let alert = UIAlertController(title: "Confirm Password", message: ALERT_PASSWORD, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            
        else if (myTxtFldNewPwd.text) != (myTxtFldCnfrmPwd.text) {
            
            let alert = UIAlertController(title: "", message: "New Password and Confirm Password is not match", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            
        else {
            
            httpRequestForChangePassword()
        }
        
//        view.endEditing(true)
//
//        if !HELPER.isConnectedToNetwork() {
//
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
//            return
//        }
//
//        //        let isNewPassword = isPasswordValid(password: myTxtFldNewPwd.text!)
//        //        let isConfirmPassword = isPasswordValid(password: myTxtFldCnfrmPwd.text!)
//
//        if (myTxtFldNewPwd.text?.isEmpty)! && (myTxtFldCnfrmPwd.text?.isEmpty)! && (myTxtFldOldPwd.text?.isEmpty)! {
//
//            let alert = UIAlertController(title: "", message: "Please provide the required information.", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//
//        else if (myTxtFldOldPwd.text?.isEmpty)! {
//
//            let alert = UIAlertController(title: "Old Password", message: "Cannot be blank", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//
//        else if myTxtFldOldPwd.text != SESSION.getCurrentPassword() {
//
//            let alert = UIAlertController(title: "Old Password", message: "Old password is not correct", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//
//        else if (myTxtFldNewPwd.text?.isEmpty)! {
//
//            let alert = UIAlertController(title: "New Password", message: "Cannot be blank", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//        else if !HELPER.isPasswordValid(password: self.myTxtFldNewPwd.text!) {
//
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_PASSWORD, aStrMessage: ALERT_PASSWORD)
//        }
//
//        else if !HELPER.isPasswordValid(password: self.myTxtFldCnfrmPwd.text!) {
//
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_PASSWORD, aStrMessage: ALERT_PASSWORD)
//        }
//
//            //        else if !isNewPassword {
//            //
//            //            let alert = UIAlertController(title: "New Password", message: ALERT_PASSWORD, preferredStyle: UIAlertControllerStyle.alert)
//            //            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//            //            self.present(alert, animated: true, completion: nil)
//            //        }
//
//        else if (myTxtFldCnfrmPwd.text?.isEmpty)! {
//
//            let alert = UIAlertController(title: "Confirm Password", message: "Cannot be blank", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//
//            //        else if !isConfirmPassword {
//            //
//            //            let alert = UIAlertController(title: "Confirm Password", message: ALERT_PASSWORD, preferredStyle: UIAlertControllerStyle.alert)
//            //            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//            //            self.present(alert, animated: true, completion: nil)
//            //        }
//
//        else if (myTxtFldNewPwd.text) != (myTxtFldCnfrmPwd.text) {
//
//            let alert = UIAlertController(title: "", message: "New Password and Confirm Password is not match", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//
//        else {
//
//            httpRequestForChangePassword()
//        }
   
    }
    
    //MARK : Private Methods
    
    func isPasswordValid(password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,15}")
        return passwordTest.evaluate(with: password)
    }
    
    // MARK : - Left Bar Button Methods
    
    func setUpLeftBarBackButton() {
        
        let leftBtn = UIButton(type: .custom)
        leftBtn.setImage(UIImage(named: ICON_BACK), for: .normal)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        leftBtn.addTarget(self, action: #selector(questionBackBtnTapped), for: .touchUpInside)
        
        let leftBarBtnItem = UIBarButtonItem(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftBarBtnItem
    }
    
    @objc func questionBackBtnTapped() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}

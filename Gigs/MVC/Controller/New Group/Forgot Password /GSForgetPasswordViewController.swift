//
//  GSForgetPasswordViewController.swift
//  Gigs
//
//  Created by dreams on 03/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSForgetPasswordViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var myViewEmail: UIView!
    @IBOutlet weak var myTxtFldEmail: UITextField!
    @IBOutlet weak var myBtnSubmit: UIButton!
    @IBOutlet weak var myBtnLogin: UIButton!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        NAVIGAION.setNavigationTitle(aStrTitle: SCREEN_TITLE_FORGET_PASSSWORD, aViewController: self)
    }
    
    func setUpUI() {
        
        setUpLeftBarBackButton()
        self.myBtnSubmit.backgroundColor = HELPER.hexStringToUIColor(hex: APP_GREEN_COLOR)
        HELPER.setRoundCornerView(aView: self.myBtnSubmit, borderRadius: 7.0)
        HELPER.setBorderView(aView: myViewEmail, borderWidth: 1, borderColor: UIColor.gray, cornerRadius: 5)
        
        myTxtFldEmail.delegate = self
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
    }

    // MARK: - TextField Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true;
    }
    
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
    
        if textfield.returnKeyType == UIReturnKeyType.done {
            textfield.resignFirstResponder()
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Api Call

    func httpRequestForForgetPassword() {
        
        var dictForgetPassword = [String:String]()
        dictForgetPassword["forget_email"] = myTxtFldEmail.text!
        dictForgetPassword[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "Loading..")
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_FORGOT_PASSWORD, dictParameters: dictForgetPassword, sucessBlock: { (response) in
            
            HELPER.hideLoadingAnimation()
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse, okActionBlock: { (okAction) in
                    
                    let signInViewController = GSLoginViewController()
                    self.navigationController?.pushViewController(signInViewController, animated: true)
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
    @IBAction func myBtnSubmitTapped(_ sender: UIButton) {
        
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
        },completion: {(_ finished: Bool) -> Void in
            
            if finished {
                
                if !HELPER.isConnectedToNetwork() {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                    return
                }
                
                if (self.myTxtFldEmail.text?.isEmpty)!  {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_EMPTY_FIELD)
                }
                    
                else if !HELPER.isValidEmailAddress(emailAddressString: self.myTxtFldEmail.text!) {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_EMAIL_ID, aStrMessage: ALERT_EMAIL_ID_NOTVALID)
                }
                    
                else {
                    
                    self.httpRequestForForgetPassword()
                }
            }
        })
    }
    
    @IBAction func myBtnLoginTapped(_ sender: UIButton) {
        
//        let aViewCintroller = GSLoginViewController()
//        self.navigationController?.pushViewController(aViewCintroller, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK : - Left Bar Button Methods
    
    func setUpLeftBarBackButton() {
        
        let leftBtn = UIButton(type: .custom)
        leftBtn.setImage(UIImage(named: ICON_BACK), for: .normal)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        leftBtn.addTarget(self, action: #selector(forgotBackBtnTapped), for: .touchUpInside)
        
        let leftBarBtnItem = UIBarButtonItem(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftBarBtnItem
    }
    
    @objc func forgotBackBtnTapped() {
        
        self.navigationController?.popViewController(animated: true)
    }
}

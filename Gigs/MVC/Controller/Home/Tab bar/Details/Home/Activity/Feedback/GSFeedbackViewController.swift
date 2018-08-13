//
//  GSFeedbackViewController.swift
//  Gigs
//
//  Created by Dreamguys on 21/06/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit
import AARatingBar

class GSFeedbackViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var myLblRateContent: UILabel!
    @IBOutlet var myLblCommentContent: UILabel!
    @IBOutlet var myLblDate: UILabel!
    @IBOutlet var myViewComment: UIView!
    @IBOutlet var myTxtFldComment: UITextField!
    @IBOutlet var myBtnSubmit: UIButton!
    
    @IBOutlet weak var myViewRatingBar: AARatingBar!
    var gIsReview:Bool!
    var gIsComment:Bool!
    
    var gOrderId = String()
    var gGigId = String()
    var gFromUserId = String()
    
    var myFloatRate = Float()
    
    var myDictInfo = [String:Any]()
    var myDictReviewInfo = [String:Any]()

    var myAryInfo = [[String:Any]]()

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
        
        // myViewRatingBar.value = CGFloat(myFloatRate)
    }
    
    func setUpUI() {
    
        setUpLeftBarButton()
        myFloatRate = 4.0
        self.myBtnSubmit.backgroundColor = HELPER.hexStringToUIColor(hex: APP_GREEN_COLOR)
        HELPER.setBorderView(aView: myViewComment, borderWidth: 1, borderColor: UIColor.gray, cornerRadius: 5)
        myTxtFldComment.delegate = self
        
        if gIsReview == true {
            
            NAVIGAION.setNavigationTitle(aStrTitle: SCREEN_TITLE_REVIEW, aViewController: self)
            myViewRatingBar.isUserInteractionEnabled = false
            myTxtFldComment.isUserInteractionEnabled = false
            myBtnSubmit.isHidden = true
            myLblDate.isHidden = false
            
            myLblRateContent.text = "Thank you for your Feedback"
            myLblCommentContent.text = "Valuable comments"

            seeFeedBack()
            
            self.myViewRatingBar.value = CGFloat(self.myFloatRate)

//            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(5000)) {
//
//                self.myViewRatingBar.value = CGFloat(self.myFloatRate)
//
//            }
            
        }
            
        else if gIsComment == true {
            
            NAVIGAION.setNavigationTitle(aStrTitle: SCREEN_TITLE_COMMENT, aViewController: self)
            myTxtFldComment.isUserInteractionEnabled = true
            myBtnSubmit.isHidden = false
            myLblDate.isHidden = true
        }
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
    }
    
//    gigs/leave_feedback
//    token: 1oPvEoqxJpdOGGo
//    comment:GoodWork.Keep it up.
//    order_id:19
//    gig_id:11
//    rating:5.0
//    to_user_id:1oPvEoqxJpdOGGo
//    time_zone:Asia/Calcutta
//    type:1
//    from_user_id:4
    
    // MARK: - Button Action
    @IBAction func btnSbmitTapped(_ sender: Any) {
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
 
        if (myTxtFldComment.text?.isEmpty)! {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_COMMENTS)
        }
        else {
            
            leaveFeedBack()
        }
    }
    
    // MARK: - Api Call

    func leaveFeedBack() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingViewAnimation(viewController: self)
        
        let x = myViewRatingBar.value
        let stringRatingValue = String(format: "%.3f", Double(x))
        
        var dictParameters = [String:String]()
        dictParameters["comment"] = myTxtFldComment.text
        dictParameters["order_id"] = gOrderId
        dictParameters["gig_id"] = gGigId
        dictParameters["rating"] = stringRatingValue
        dictParameters["to_user_id"] = SESSION.getUserId()
        dictParameters["time_zone"] = TimeZone.current.identifier
        dictParameters["type"] = "1"
        dictParameters["from_user_id"] = gFromUserId

        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_LEAVE_FEEDBACK, dictParameters: dictParameters, sucessBlock: { (response) in
            
            HELPER.hideLoadingAnimation(viewController: self)
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
            else {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation(viewController: self)
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
        
    }
    
    //See Feedback
    func seeFeedBack() {
        

        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }

        HELPER.showLoadingViewAnimation(viewController: self)

        var dictParameters = [String:String]()
        dictParameters["gig_id"] = gGigId
        dictParameters["order_id"] = gOrderId
        dictParameters["from_user_id"] = gFromUserId

        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_SEE_FEEDBACK, dictParameters: dictParameters, sucessBlock: { (response) in

            HELPER.hideLoadingAnimation(viewController: self)

            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String

            if aIntResponseCode == RESPONSE_CODE_200 {

                self.myDictInfo = response["data"] as! [String : Any]
                self.myAryInfo = (self.myDictInfo["user_feed"] as? [[String : Any]])!
                self.myDictReviewInfo = self.myAryInfo[0]

                self.myTxtFldComment.text = self.myDictReviewInfo["fb_user_comment"] as? String
                self.myLblDate.text = self.myDictReviewInfo["fb_user_time"] as? String

                self.myFloatRate = ((self.myDictReviewInfo["fb_user_rating"] as? NSString)?.floatValue)!
                //self.myViewRatingBar.value = CGFloat(self.myFloatRate)
                
                //self.myViewRatingBar.value = 4

            }
            else {

                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }

        }, failureBlock: { error in

            HELPER.hideLoadingAnimation(viewController: self)

            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
        
    }
    
    
    // MARK: - Private functions
    
    func setUpLeftBarButton() {
        
        let close = UIBarButtonItem(image: UIImage(named: ICON_CLOSE), style: .plain, target: self, action: #selector(closeBarBtnTapped))
        
        self.navigationItem.leftBarButtonItems = [close]
        navigationController?.navigationBar.tintColor = .white
    }
    @objc func closeBarBtnTapped() {
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

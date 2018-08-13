//
//  Helper.swift
//  DriverUtilites
//
//  Created by admin on 13/05/2017.
//  Copyright © 2017 project. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary
import JKNotificationPanel
import JGProgressHUD

let TAG_LOADING = 100
let TAG_NO_DATA = 200
let TAG_RETRY = 300
let TAG_NO_INTERNET = 400
var  currentVc = UIViewController()

var hud = JGProgressHUD(style: .dark)

let panel = JKNotificationPanel()

typealias RetryCallBack = () -> Void

class Helper: NSObject {
    
    var myRetryCallBack:RetryCallBack!

    static let sharedInstance: Helper = {
        
        let instance = Helper()
        
        // setup code
        return instance
    }()
    
    func isConnectedToNetwork() -> Bool {
        
        if Reachability.isConnectedToNetwork() == true {
            
            return true
            
        } else {
            
            return false
        }
    }
    
    // MARK : Colo code Methods
    
    func hexStringToUIColor (hex:String) -> UIColor {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // MARK : Notification Alert
    
    func showNotificationInAlertSucess(aStrMessage : String, inView: UIView) {
        
        // CRNotifications.showNotification(type: .success, title: APP_NAME, message: aStrMessage, dismissDelay: 5)
        panel.showNotify(withStatus: .success, inView: inView, title: APP_NAME, message: aStrMessage)
        
    }
    
    func showNotificationInAlertError(aStrMessage : String) {
        
        //   CRNotifications.showNotification(type: .error, title: APP_NAME, message: aStrMessage, dismissDelay: 5)
        //        panel.showNotify(withStatus: .error, inView: self.view, title: aStrMessage)
        
    }
    
    func showNotificationInAlertInfo(aStrMessage : String) {
        
        //  CRNotifications.showNotification(type: .info, title: APP_NAME, message: aStrMessage, dismissDelay: 5)
    }
    
    
    // MARK : Alert Controller Methods
    
    func showDefaultAlertViewController(aViewController : UIViewController, alertTitle: String, aStrMessage : String)  {
        
        let aAlertController = UIAlertController(title: alertTitle, message: aStrMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        aAlertController.addAction(UIAlertAction(title: BTN_OK, style: UIAlertActionStyle.default, handler: nil))
        
        aViewController.present(aAlertController, animated: true, completion: nil)
    }
    
    func showAlertControllerWithOkActionBlock(aViewController : UIViewController, aStrMessage : String, okActionBlock : @escaping (UIAlertAction) ->())  {
        
        let aAlertController = UIAlertController(title: APP_NAME, message: aStrMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        aAlertController.addAction(UIAlertAction(title: BTN_OK, style: UIAlertActionStyle.default, handler: { (action) in
            
            okActionBlock(action)
        }))
        
        aViewController.present(aAlertController, animated: true, completion: nil)
    }
    
    func showAlertControllerWithCancelActionBlock(aViewController : UIViewController, aStrMessage : String, cancelActionBlock : @escaping (UIAlertAction) ->())  {
        
        let aAlertController = UIAlertController(title: APP_NAME, message: aStrMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        aAlertController.addAction(UIAlertAction(title: BTN_CANCEL, style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) in
            
            cancelActionBlock(UIAlertAction)
            
        }))
        
        aViewController.present(aAlertController, animated: true, completion: nil)
    }
    
    func showAlertControllerIn(aViewController : UIViewController, aStrMessage : String, okButtonTitle : String, cancelBtnTitle : String, okActionBlock : @escaping (UIAlertAction) ->() , cancelActionBlock : @escaping (UIAlertAction) ->())  {
        
        let aAlertController = UIAlertController(title: APP_NAME, message: aStrMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        aAlertController.addAction(UIAlertAction(title: okButtonTitle, style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            
            okActionBlock(UIAlertAction)
            
        }))
        
        aAlertController.addAction(UIAlertAction(title: cancelBtnTitle, style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            
            cancelActionBlock(UIAlertAction)
            
        }))
        
        aViewController.present(aAlertController, animated: true, completion: nil)
    }
        
    // MARK : Button
    
    func flatButton(aButton : UIButton)  {
        
        aButton.layer.shadowColor = UIColor.darkGray.cgColor
        aButton.layer.shadowOpacity = 1.0
        aButton.layer.shadowRadius = 1.0
        aButton.layer.cornerRadius = 20
        aButton.layer.shadowOffset = CGSize(width: -1, height: 1)
    }
    
    
    func isPasswordValid(password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,15}")
        return passwordTest.evaluate(with: password)
    }
    
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    //MARK: - Email Valadiation Function
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    // Mark Card View
    
    func setCardView(cardView : UIView)  {
        
        //        let cornerRadius: CGFloat = 2
        //        let shadowOffsetWidth: Int = 0
        //        let shadowOffsetHeight: Int = 3
        //        let shadowColor: UIColor? = UIColor.black
        //        let shadowOpacity: Float = 0.5
        //
        //        cardView.layer.cornerRadius = cornerRadius
        //        let shadowPath = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: cornerRadius)
        //
        //        cardView.layer.masksToBounds = false
        //        cardView.layer.shadowColor = shadowColor?.cgColor
        //        cardView.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        //        cardView.layer.shadowOpacity = shadowOpacity
        //        cardView.layer.shadowPath = shadowPath.cgPath
        
        
        
        cardView.layer.masksToBounds = false
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0);
        cardView.layer.cornerRadius = 5;
        cardView.layer.shadowRadius = 1;
        cardView.layer.shadowOpacity = 0.3;
//
        
//        var cornerRadius: CGFloat = 2
//        var shadowOffsetWidth: Int = 0
//        var shadowOffsetHeight: Int = 3
//        var shadowColor: UIColor? = UIColor.black
//        var shadowOpacity: Float = 0.5
//
//        layer.cornerRadius = cornerRadius
//        let shadowPath = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: 5)
//
//        layer.masksToBounds = false
//        layer.shadowColor = shadowColor?.CGColor
//        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
//        layer.shadowOpacity = shadowOpacity
//        layer.shadowPath = shadowPath.CGPath
//
//        cardView.layer=layer
        
    }
    
    
    
    // Round Corner View
    func setRoundCornerView(aView : UIView)  {
        
        aView.layer.masksToBounds = true
        aView.layer.cornerRadius = aView.frame.size.width / 2
    }
    
    
    // Round Corner View
    func setRoundCornerView(aView : UIView, borderRadius:CGFloat)  {
        
        aView.layer.masksToBounds = true
        aView.layer.cornerRadius = borderRadius
    }
    
    // Set border view
    
    func setBorderView(aView : UIView, borderWidth:CGFloat, borderColor:UIColor, cornerRadius:CGFloat)  {
        
        aView.layer.borderWidth = borderWidth
        aView.layer.borderColor = borderColor.cgColor
        aView.layer.masksToBounds = true
        aView.layer.cornerRadius = cornerRadius
    }
    
    // MARK : Loding Animation
    
    func showLoadingAnimation() {
        
        ACProgressHUD.shared.progressText = ""
        ACProgressHUD.shared.showHUD()
    }
    
    func showLoadingAnimationWithDefaultTitle() {
        
        ACProgressHUD.shared.showHUD()
    }
    
    func hideLoadingAnimation() {
        
        hud.dismiss()
    }
    
    func showLoadingAnimationWithTitle(aViewController:UIViewController, aStrText : String) {
        
        hud.textLabel.text = aStrText
        hud.show(in: aViewController.view)
    }
    
    func clearVideoDirectoryAllClips() {
        
        let fileManager = FileManager.default
        let documentsUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as NSURL
        let documentsPath = documentsUrl.path
        
        do {
            
            if let documentPath = documentsPath
            {
                let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                
                print("all files in cache: \(fileNames)")
                
                for fileName in fileNames {
                    
                    if (fileName.hasSuffix("mp4"))
                    {
                        let filePathName = "\(documentPath)/\(fileName)"
                        try fileManager.removeItem(atPath: filePathName)
                    }
                }
                
                let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                print("all files in cache after deleting images: \(files)")
            }
            
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
    
    func convertStringFormatToDate(inputString:String) -> Date {
        
        let dateInputFormat = DateFormatter()
        dateInputFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateInputFormat.date(from: inputString)
        
        return date!
    }
    
    func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
    }
    
    func changeTheButtonImageColorWithHex(hex:String,button:UIButton!,imageName:String) -> UIButton {
        
        let origImage = UIImage(named: imageName)
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = hexStringToUIColor(hex: hex)
        
        return button
    }
    
    
    func changeTheImageViewColorWithHex(hex:String,imageView:UIImageView!,imageName:String) -> UIImageView {
        
        let origImage = UIImage(named: imageName)
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        
        imageView.image = tintedImage
        imageView.tintColor = hexStringToUIColor(hex: hex)
        
        return imageView
    }
    
   @discardableResult func changeTheButtonImageColorWithDefault(color:UIColor,button:UIButton,imageName:String) -> UIButton {
        
        let origImage = UIImage(named: imageName)
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = color
        
        return button
    }
    
    func tapAnimationFor(aView: UIView, duration aDurationFloat: Double, withCallBack callBack: @escaping () -> Void) {
        UIView.animateKeyframes(withDuration: aDurationFloat, delay: 0.0, options: .calculationModeLinear, animations: {() -> Void in
            // Zoom out
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: Double((aDurationFloat / 2)), animations: {() -> Void in
                aView.transform = aView.transform.scaledBy(x: 0.9, y: 0.9)
            })
            // Back to orginal size
            UIView.addKeyframe(withRelativeStartTime: Double((aDurationFloat / 2)), relativeDuration: Double((aDurationFloat / 2)), animations: {() -> Void in
                aView.transform = .identity
            })
        }, completion: {(_ finished: Bool) -> Void in
            if finished {
                callBack()
            }
        })
    }
    
    func checkPhotoLibraryPermission() {
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized:
            SESSION.setIsPhotoLibraryPermisson(isAnswer: true)
            
        case .denied, .restricted :
            SESSION.setIsPhotoLibraryPermisson(isAnswer: false)
            
        default:
            break
        }
    }
    
    func requestPhotoLibraryPermission() {
        
        PHPhotoLibrary.requestAuthorization() { status in
            switch status {
                
            case .authorized:
                SESSION.setIsPhotoLibraryPermisson(isAnswer: true)
                
            case .denied, .restricted:
                SESSION.setIsPhotoLibraryPermisson(isAnswer: false)
                
            case .notDetermined:
                SESSION.setIsPhotoLibraryPermisson(isAnswer: false)
            }
        }
    }
    
    // Network Category
    
    //MARK:- Loading animation
    func showLoadingViewAnimation(viewController : UIViewController) {
        
        let aViewNetworkView = NetworkView().loadNib() as! NetworkView
        aViewNetworkView.gViewLoadingContainer.tag = TAG_LOADING
        
        showAndHideContainer(intTag: TAG_LOADING, netWorkView: aViewNetworkView)
        
        aViewNetworkView.gIndicatorLoading.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        aViewNetworkView.gIndicatorLoading.startAnimating()
       // aViewNetworkView.gIndicatorLoading.color = UIColor.darkGray
        
        aViewNetworkView.gLblLoading.isHidden = true
        
        aViewNetworkView.backgroundColor = UIColor.clear
        aViewNetworkView.gViewLoadingContainer?.backgroundColor = UIColor.white
        
        updateConstraints(viewController: viewController, inputView: aViewNetworkView.gViewLoadingContainer)
        
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            aViewNetworkView.gViewLoadingContainer?.alpha = 1.0
        }, completion: {(_ finished: Bool) -> Void in
            
        })
    }
    
    func showNoDataAlert(viewController : UIViewController) {
        
        let aViewNetworkView = NetworkView().loadNib() as! NetworkView
        aViewNetworkView.gViewNetworkContainer.tag = TAG_NO_DATA
        
        aViewNetworkView.gImgViewAlert.image =  UIImage(named:"icon_no_data")!
        aViewNetworkView.gLblAlertTtle.text = "No data"
        
        showAndHideContainer(intTag: TAG_NO_DATA, netWorkView: aViewNetworkView)
        
        updateConstraints(viewController: viewController, inputView: aViewNetworkView.gViewNetworkContainer)
    }
    
    func showNoDataWithRetryAlert(viewController: UIViewController, alertMessage: String, retryBlock aRetryCallBack: @escaping RetryCallBack)  {
        
        let aViewNetworkView = NetworkView().loadNib() as! NetworkView
        aViewNetworkView.gViewNetworkContainer.tag = TAG_RETRY
        
        aViewNetworkView.gImgViewAlert.image =  UIImage(named:"icon_no_data")!
        aViewNetworkView.gLblAlertTtle.text = alertMessage
        
        showAndHideContainer(intTag: TAG_RETRY, netWorkView: aViewNetworkView)
        
        myRetryCallBack = aRetryCallBack
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapEvent))
        aViewNetworkView.gViewNetworkContainer?.addGestureRecognizer(tapGesture)
        
        updateConstraints(viewController: viewController, inputView: aViewNetworkView.gViewNetworkContainer)
        
        //        UIView.animate(withDuration: 0.2, animations: {() -> Void in
        //            aViewNetworkView.gViewNetworkContainer.alpha = 1
        //        }) {() -> Void in }
        
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            aViewNetworkView.gViewNetworkContainer?.alpha = 1.0
        }, completion: {(_ finished: Bool) -> Void in
            
        })
        
    }
    
    func showNetworkWithRetryAlert(viewController: UIViewController,alertMessage: String, retryBlock aRetryCallBack: @escaping RetryCallBack)  {
        
        let aViewNetworkView = NetworkView().loadNib() as! NetworkView
        aViewNetworkView.gViewNetworkContainer.tag = TAG_RETRY
        
        aViewNetworkView.gImgViewAlert.image =  UIImage(named:"icon_no_internet")!
        aViewNetworkView.gLblAlertTtle.text = alertMessage + "Tap to retry"
        
        showAndHideContainer(intTag: TAG_RETRY, netWorkView: aViewNetworkView)
        
        myRetryCallBack = aRetryCallBack
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapEvent))
        aViewNetworkView.gViewNetworkContainer?.addGestureRecognizer(tapGesture)
        
        updateConstraints(viewController: viewController, inputView: aViewNetworkView.gViewNetworkContainer)
    }
    
    @objc func tapEvent(_ sender: UIGestureRecognizer) {
        //let aView = sender.view as? NetworkView
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            sender.view?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                sender.view?.transform = .identity
            }, completion: {(_ finished: Bool) -> Void in
                
                if (self.myRetryCallBack != nil) {
                    self.myRetryCallBack()
                }
            })
        })
    }
    
    func hideLoadingAnimation(viewController: UIViewController)  {
        
        let aLoadingView: UIView? = viewController.view.viewWithTag(TAG_LOADING)
        
        if (aLoadingView != nil) {
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                aLoadingView?.alpha = 0
            }, completion: {(_ finished: Bool) -> Void in
                aLoadingView?.removeFromSuperview()
            })
        }
    }
    
    func removeNetworlAlertIn(viewController: UIViewController)  {
        
        let aRetryView: UIView? = viewController.view.viewWithTag(TAG_RETRY)
        
        if (aRetryView != nil) {
            UIView.animate(withDuration: 0.1, animations: {() -> Void in
                aRetryView?.alpha = 0
            }, completion: {(_ finished: Bool) -> Void in
                aRetryView?.removeFromSuperview()
            })
        }
        
        aRetryView?.removeFromSuperview()
    }
    
    func updateConstraints(viewController : UIViewController, inputView:UIView) {
        
        viewController.view.addSubview(inputView)
        
        let aTopLayoutConstraint = NSLayoutConstraint(item: inputView, attribute: .top, relatedBy: .equal, toItem: viewController.view, attribute: .top, multiplier: 1.0, constant: 0)
        let aBottomLayoutConstraint = NSLayoutConstraint(item: inputView, attribute: .bottom, relatedBy: .equal, toItem: viewController.view, attribute: .bottom, multiplier: 1.0, constant: 0)
        let aLeftLayoutConstraint = NSLayoutConstraint(item: inputView, attribute: .left, relatedBy: .equal, toItem: viewController.view, attribute: .left, multiplier: 1.0, constant: 0)
        let aRightLayoutConstraint = NSLayoutConstraint(item: inputView, attribute: .right, relatedBy: .equal, toItem: viewController.view, attribute: .right, multiplier: 1.0, constant: 0)
        
        viewController.view.addConstraints([aTopLayoutConstraint, aBottomLayoutConstraint, aLeftLayoutConstraint, aRightLayoutConstraint])
        
        viewController.view.layoutIfNeeded()
    }
    
    func showAndHideContainer(intTag : NSInteger, netWorkView : NetworkView)  {
        
        if intTag == TAG_LOADING {
            
            netWorkView.gViewLoadingContainer.isHidden = false
            netWorkView.gViewNetworkContainer.isHidden = true
        }
            
        else if intTag == TAG_RETRY {
            
            netWorkView.gViewLoadingContainer.isHidden = true
            netWorkView.gViewNetworkContainer.isHidden = false
        }
            
        else if intTag == TAG_NO_DATA {
            
            netWorkView.gViewLoadingContainer.isHidden = true
            netWorkView.gViewNetworkContainer.isHidden = false
        }
    }
    
    func pushToLogInScreen(isFrom:UIViewController) {
        
        
        let loginViewController = GSLoginViewController(nibName: "GSLoginViewController", bundle: nil)
//        let navigationController = UINavigationController(rootViewController: loginViewController)
        isFrom.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    //Add and remove  favourites
    func addFavourites(from:UIViewController,gigid:String) {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: from, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        //        HELPER.showLoadingAnimationWithTitle(aViewController: from, aStrText: "Loading..")
        
        var dictLoginCrediental = [String:String]()
        dictLoginCrediental["gig_id"] = gigid
        //dictLoginCrediental[K_USER_ID] =  SESSION.getUserId()
        
        //        HTTPMANAGER.setAddFavourites(parameter: dictLoginCrediental, sucessblock: {response in
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_ADD_FAVOURITES, dictParameters: dictLoginCrediental, sucessBlock: { (response) in
            
            print(response)
            
            HELPER.hideLoadingAnimation()
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                //                HELPER.showDefaultAlertViewController(aViewController: from, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
                from.view.endEditing(true)
            }
                
            else if aIntResponseCode == RESPONSE_CODE_498 {
                
                HELPER.showAlertControllerWithOkActionBlock(aViewController: (APPDELEGATE.window?.rootViewController)!, aStrMessage: aMessageResponse, okActionBlock: { (action) in
                    
                    SESSION.setIsUserLogIN(isLogin: false)
                    SESSION.setUserImage(aStrUserImage: "")
                    SESSION.setUserPriceOption(option: "", price: "", extraprice: "")
                    SESSION.setUserId(aStrUserId: "")
                    APPDELEGATE.loadLogInSceen()
                    
                })
            }
            else {
                
                //                HELPER.showDefaultAlertViewController(aViewController: from, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
        }, failureBlock: { error in
            HELPER.hideLoadingAnimation()
            HELPER.showDefaultAlertViewController(aViewController: from, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    //Remove favourites
    func removeFavourites(from:UIViewController,gigid:String) {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: from, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        //        HELPER.showLoadingAnimationWithTitle(aViewController: from, aStrText: "Loading..")
        
        var dictLoginCrediental = [String:String]()
        dictLoginCrediental["gig_id"] = gigid
        //dictLoginCrediental[K_USER_ID] =  SESSION.getUserId()
        
        //        HTTPMANAGER.setRemoveFavourites(parameter: dictLoginCrediental, sucessblock: {response in
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_REMOVE_FAVOURITES, dictParameters: dictLoginCrediental, sucessBlock: { (response) in
            
            print(response)
            
            HELPER.hideLoadingAnimation()
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                //                HELPER.showDefaultAlertViewController(aViewController: from, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
                from.view.endEditing(true)
            }
                
            else if aIntResponseCode == RESPONSE_CODE_498 {
                
                HELPER.showAlertControllerWithOkActionBlock(aViewController: (APPDELEGATE.window?.rootViewController)!, aStrMessage: aMessageResponse, okActionBlock: { (action) in
                    
                    SESSION.setIsUserLogIN(isLogin: false)
                    SESSION.setUserImage(aStrUserImage: "")
                    SESSION.setUserPriceOption(option: "", price: "", extraprice: "")
                    SESSION.setUserId(aStrUserId: "")
                    APPDELEGATE.loadLogInSceen()
                    
                })
            }
            else {
                
                //                HELPER.showDefaultAlertViewController(aViewController: from, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
        }, failureBlock: { error in
            HELPER.hideLoadingAnimation()
            HELPER.showDefaultAlertViewController(aViewController: from, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    // MARK:- Side Menu
    
    func setUpLeftBarBackButton(fromVc:UIViewController) {
        
        currentVc = fromVc
        let leftBtn = UIButton(type: .custom)
        leftBtn.setImage(UIImage(named: ICON_MENU), for: .normal)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        leftBtn.addTarget(self, action: #selector(leftMenuBtnTapped), for: .touchUpInside)
        
        let leftBarBtnItem = UIBarButtonItem(customView: leftBtn)
        fromVc.navigationItem.leftBarButtonItem = leftBarBtnItem
    }
    
    @objc func leftMenuBtnTapped() {
        
        // self.navigationController?.popViewController(animated: true)
        currentVc.evo_drawerController?.toggleDrawerSide(.left, animated: true, completion: nil)
        
    }
    
    // MARK:- parse Dict without null value
    func removeNullValues(Arr:[[String:Any?]]) -> [[String:Any?]] {
        
        var finalArr:[[String:Any]]?
        for dict in Arr {
            let dictWithoutNilValues = dict.reduce([String : Any]()) { (dict, e) in
                guard let value = e.1 else { return dict }
                var dict = dict
                dict[e.0] = value
                return dict
            }
            finalArr?.append(dict)
        }
        return finalArr!
    }
    
    // Date Formatter
    func dateformate(getDate : String) -> String {
        
        if(getDate.isEmpty){
            return "";
        }
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY"
        
        let date: Date? = dateFormatterGet.date(from: getDate)
        
        return dateFormatter.string(from: date!)
    }
    
}

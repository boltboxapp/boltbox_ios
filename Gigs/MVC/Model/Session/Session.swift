//
//  Session.swift
//  DriverUtilites
//
//  Created by Guru Prasad chelliah on 10/24/17.
//  Copyright © 2017 project. All rights reserved.
//

import UIKit

class Session: NSObject {
    
    static let sharedInstance: Session = {
        
        let instance = Session()
        
        // setup code
        
        return instance
    }()
    
    
    // MARK: - Shared Methods
    
    // Set and get user id
    
    func setIsUserLogIN(isLogin : Bool) {
        
        UserDefaults.standard.set(isLogin, forKey: "user_log_in")
        userdefaultsSynchronize()
    }
    
    func isUserLogIn() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "user_log_in")
    }
    
    func setIsUserSellTap(isLogin : Bool) {
        
        UserDefaults.standard.set(isLogin, forKey: "user_Sell")
        userdefaultsSynchronize()
    }
    
    func isUserSellTap() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "user_Sell")
    }
    
    func setIsAppLaunchFirstTime(isLogin : Bool) {
        
        UserDefaults.standard.set(isLogin, forKey: "user_log_in_FirstTime")
        userdefaultsSynchronize()
    }
    
    func isAppLaunchFirstTime() -> Bool {
        
        let aBoolCheck = UserDefaults.standard.bool(forKey: "user_log_in_FirstTime") as Bool
        
        if aBoolCheck {
            
            return false
        }
        
        else {
            
            return true
        }
    }
    
    // Set and get user id
    func setUserId(aStrUserId : String) {
        
        UserDefaults.standard.set(aStrUserId, forKey: "user_id")
        userdefaultsSynchronize()
    }
    
    func getUserId() -> String {
        
        if let userid = UserDefaults.standard.string(forKey: "user_id") {
            return userid
        }
        return ""
        
    }
    
    // SET and get Token
    
    func setUserToken(aStrUserToken : String) {
        
        UserDefaults.standard.set(aStrUserToken, forKey: "user_Token")
        userdefaultsSynchronize()
    }
    
    func getUserToken() -> String {
        
        if let token = UserDefaults.standard.string(forKey: "user_Token") {
            return token
        }
        return ""
        
//        if let token = UserDefaults.standard.string(forKey: "user_Token") {
//            return token
//        }
//        return token
        
    }
    
    func setUserid(aStrUserid : String) {
        
        UserDefaults.standard.set(aStrUserid, forKey: "user_id")
        userdefaultsSynchronize()
    }
    
    func getUserid() -> String {
        
        return UserDefaults.standard.string(forKey: "user_id")!

    }
    
    // Set and get password
    func setCurrentPassword(password : String) {
        
        UserDefaults.standard.set(password, forKey: "current_pwd")
        userdefaultsSynchronize()
    }
    
    func getCurrentPassword() -> String {
        
        return UserDefaults.standard.string(forKey: "current_pwd")!
    }
    
    // Set and get Base iIage URL
    func setBaseImageUrl(aStrImageUrl : String) {
        
        UserDefaults.standard.set(aStrImageUrl, forKey: "base_image_url")
        userdefaultsSynchronize()
    }
    
    func getBaseImageUrl() -> String {
        
        return UserDefaults.standard.string(forKey: "base_image_url")!
    }
    
    // Set and get student id
    func setStudentId(aStrUserId : String) {
        
        UserDefaults.standard.set(aStrUserId, forKey: "student_id")
        userdefaultsSynchronize()
    }
    
    func getStudentId() -> String {
        
        return UserDefaults.standard.string(forKey: "student_id")!
    }
    
    // Set and get user name
    
    func setUserName(aStrUserName : String) {
        
        UserDefaults.standard.set(aStrUserName, forKey: "user_name")
        userdefaultsSynchronize()
    }
    
    func getUserName() -> String {
        if let name = UserDefaults.standard.string(forKey: "user_name") {
            return name
        }
        return ""
    }
    
    // Set and get device id
    func setDeviceId(aStrUserId : String) {
        
        UserDefaults.standard.set(aStrUserId, forKey: "device_id")
        userdefaultsSynchronize()
    }
    
    func getDeviceId() -> String {
        
        return UserDefaults.standard.string(forKey: "device_id")!
    }
    
    // Set and get paypal id
    
    func setPaypalId(aStrPaypalId : String) {
        
        UserDefaults.standard.set(aStrPaypalId, forKey: "paypal_email")
        userdefaultsSynchronize()
    }
    
    func getPaypalId() -> String {
        if let name = UserDefaults.standard.string(forKey: "paypal_email") {
            return name
        }
        return ""
    }
    
    // Set and get Currency sign
    
    func setCurrencySign(aStrCurrencySign : String) {
        
        UserDefaults.standard.set(aStrCurrencySign, forKey: "default_currency_sign")
        userdefaultsSynchronize()
    }
    
    func getCurrencySign() -> String {
        if let name = UserDefaults.standard.string(forKey: "default_currency_sign") {
            return name
        }
        return ""
    }
    
    // Set and get user image
    func setUserImage(aStrUserImage : String) {
        
        UserDefaults.standard.set(aStrUserImage, forKey: "user_image")
        userdefaultsSynchronize()
    }
    
    func getUserImage() -> String {
        
        if let image = UserDefaults.standard.string(forKey: "user_image") {
            return image
        }
        return ""
    }
    
    func setSessionId(strSessionId: String) {
        
        UserDefaults.standard.set(strSessionId, forKey: "session_id")
        userdefaultsSynchronize()
    }
    
    func getSessionId() -> String {
        
        return UserDefaults.standard.string(forKey: "session_id")!
    }
    
    
    // Set and get device token
    func setDeviceToken(deviceToken : String) {
        
        UserDefaults.standard.set(deviceToken, forKey: "device_token")
        userdefaultsSynchronize()
    }
    
    func getDeviceToken() -> String {
        
        if UserDefaults.standard.string(forKey: "device_token") != nil {
            return UserDefaults.standard.string(forKey: "device_token")! as String
        }
        
        return ""
    }
    
    //Stripe Account details
    func setUserStripeInfo(dictInfo: [String:String]) {
        
        UserDefaults.standard.set(dictInfo, forKey: "user_stripe_info")
        userdefaultsSynchronize()
    }
    
    func getUserStripeInfo() -> [String:String] {
        
        return UserDefaults.standard.dictionary(forKey: "user_stripe_info") as! [String : String]
    }
    
    
    func setBannerInfo(dictInfo: [[String:String]]) {
        
        UserDefaults.standard.set(dictInfo, forKey: "banner_info")
        userdefaultsSynchronize()
    }
    
    func getBannerInfo() -> [[String:String]] {
        
        if UserDefaults.standard.array(forKey: "banner_info") != nil {
            return UserDefaults.standard.array(forKey: "banner_info") as! [[String : String]]
        }
        
        let aAryInfo = [[String : String]]()
        return aAryInfo
    }
    
    func setIsUPushNotificationStatus(isLogin : Bool) {
        
        UserDefaults.standard.set(isLogin, forKey: "push_notification_status")
        userdefaultsSynchronize()
    }
    
    func getPushNotificationStatus() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "push_notification_status")
    }
    
    func setPassword(strSessionId: String) {
        
        UserDefaults.standard.set(strSessionId, forKey: "password")
        userdefaultsSynchronize()
    }
    
    func getPassword() -> String {
        
        return UserDefaults.standard.string(forKey: "password")!
    }
    
    // Set and get user id
    
    func setIsUploadAnswer(isAnswer : Bool) {
        
        UserDefaults.standard.set(isAnswer, forKey: "is_upload")
        userdefaultsSynchronize()
    }
    
    func isUploadAnswer() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "is_upload")
    }
    
    //Set and Get Upload Document Photos
    
    func setUploadDocument(dictInfo: [[String:AnyObject]]) {
        
        UserDefaults.standard.set(dictInfo, forKey: "imageupload")
        userdefaultsSynchronize()
    }
    
    func getUploadDocument() -> [[String:Any]] {
        
        if UserDefaults.standard.array(forKey: "imageupload") != nil {
            return UserDefaults.standard.array(forKey: "imageupload") as! [[String : Any]]
        }
        
        let aAryInfo = [[String : Any]]()
        return aAryInfo
    }
    
    // Set and get video recoreder permission
    
    func setIsPhotoLibraryPermisson(isAnswer : Bool) {
        
        UserDefaults.standard.set(isAnswer, forKey: "photo_permission")
        userdefaultsSynchronize()
    }
    
    func isPhotoLibraryPermisson() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "photo_permission")
    }
    
    // MARK: - Private Methods
    
    private func userdefaultsSynchronize() {
        
        UserDefaults.standard.synchronize()
    }
    
    // MARk:- Set and Get user price option
    
    func setUserPriceOption(option:String,price:String,extraprice:String) {
        
        UserDefaults.standard.set(option, forKey: "user_price_option")
        UserDefaults.standard.set(price, forKey: "gigs_price")
        UserDefaults.standard.set(extraprice, forKey: "extra_gig_price")
        userdefaultsSynchronize()
    }
    
    func getUserPriceOption() -> (String,String,String) {
        
        var priceoption = ""
        var gigsprice = ""
        var gigsextraprice = ""

        if let option = UserDefaults.standard.string(forKey: "user_price_option") {
            priceoption = option
        }
        if let price = UserDefaults.standard.string(forKey: "gigs_price") {
            gigsprice = price
        }
        if let extraprice = UserDefaults.standard.string(forKey: "extra_gig_price") {
            gigsextraprice = extraprice
        }
        return (priceoption, gigsprice, gigsextraprice)
        
    }
}

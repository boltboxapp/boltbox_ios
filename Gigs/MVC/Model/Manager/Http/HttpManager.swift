//
//  HttpManager.swift
//  VRS
//
//  Created by admin on 27/05/2017.
//  Copyright © 2017 project. All rights reserved.
//

import UIKit
import Alamofire

class HttpManager: NSObject {

    static let sharedInstance: HttpManager = {
       let instance = HttpManager()
        
        return instance
    }()
    
//    //SIGNIN REQUEST
//    func signInRequest(parameter:[String:String], sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_LOGIN, method: .post, parameters: parameter).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    //FORGET PASSWORD REQUEST
//    func forgetPasswordRequest(parameter:[String:String], forgetSucessBlock: @escaping (NSDictionary)->(), failureBlock:@escaping (String) ->()) {
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_FORGOT_PASSWORD, method: .post, parameters: parameter).responseJSON
//            {(response) in
//
//                if response.result.isSuccess {
//
//                    if let result = response.result.value {
//
//                        forgetSucessBlock(result as! NSDictionary)
//                    }
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    //Profile Request
//    func changePasswordRequest(parameter:[String:String], confirmPasswordSucessBlock: @escaping (NSDictionary)->(), failureBlock:@escaping (String) ->()) {
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_CHANGE_PASSWORD, method: .post, parameters: parameter).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    confirmPasswordSucessBlock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock(ALERT_UNABLE_TO_REACH_DESC)
//                }
//        }
//    }
    
//    //REGISTER REQUEST
//    func registerRequest(parameter:[String:String], forgetSucessBlock: @escaping (NSDictionary)->(), failureBlock:@escaping (String) ->()) {
//
//        var dictParameters = [String:String]()
//        dictParameters[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_REGISTER, method: .post, parameters:parameter).responseJSON
//            {(response) in
//
//                if response.result.isSuccess {
//
//                    if let result = response.result.value {
//
//                        forgetSucessBlock(result as! NSDictionary)
//                    }
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
    
//    //Get Country
//    func getCountryInfo(sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//
//        var dictParameters = [String:String]()
//        dictParameters[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_COUNTRY, method: .get, parameters: dictParameters).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
    
//    //Get state
//    
//    func getStateInfo(countryId:String, sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//        
//        var dictParameters = [String:String]()
//        dictParameters[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
//        
//        Alamofire.request(WEB_SERVICE_URL+CASE_STATE + "/" + countryId, method: .get, parameters: dictParameters).responseJSON
//            {(response) in
//                
//                let jsonDict = response.result.value as? [String:Any]
//                
//                if response.result.isSuccess {
//                    
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//                    
//                else if response.result.isFailure {
//                    
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    //Get Language
//    func getLanguageInfo(sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//        
//        var dictParameters = [String:String]()
//        dictParameters[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
//        
//        Alamofire.request(WEB_SERVICE_URL+CASE_LANGUAGE, method: .get, parameters: dictParameters).responseJSON
//            {(response) in
//                
//                let jsonDict = response.result.value as? [String:Any]
//                
//                if response.result.isSuccess {
//                    
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//                    
//                else if response.result.isFailure {
//                    
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    //Get Profession
//    func getProfessionInfo(sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//
//        var dictParameters = [String:String]()
//        dictParameters[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_PROFESSION, method: .get, parameters: dictParameters).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    //Get Home Details
//    func getHomeInfo(sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//
//        var dictParameters = [String:String]()
//        dictParameters[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
//        dictParameters[K_USER_ID] = SESSION.getUserId()
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_HOME_GIGS + SESSION.getUserId(), method: .get, parameters: dictParameters).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    //Get Category List
//    func categoryListRequest(sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//
//        var dictParameters = [String:String]()
//        dictParameters[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_HOME_VIEWALL_GIGS, method: .get , parameters: dictParameters).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }

//    //Get Sub Category List
//    func subCategoryListRequest(subCategoryId:String,sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//
//        var dictParameters = [String:String]()
//        dictParameters[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
//        dictParameters[kDEVICE_CATEGORY_iD] = subCategoryId //"29"
////        dictParameters[K_USER_ID] = "1"
////        dictParameters[K_SUB_CATEGORY_ID] = ""
//        dictParameters[kDEVICE_VIEWALL] = kDEVICE_VIEWALL_SERVICES
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_HOME_VIEWALL_GIGS, method: .post , parameters: dictParameters).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    //Get Gigs Details
//    func getDetailGigsInfo(gigId:String, sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//
//        var dictParameters = [String:String]()
//        dictParameters[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
//        dictParameters[K_GIG_ID] = gigId
//        dictParameters[K_USER_id] = SESSION.getUserId()
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_GIGS_DETAILS, method: .post, parameters: dictParameters).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    //Get Home View All Gigs(Popular Gigs)
//    func getViewAllInfo(sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//
//        var dictParameters = [String:String]()
//        //dictParameters[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
//        dictParameters[kDEVICE_VIEWALL] = kDEVICE_VIEWALL_SERVICES
//        dictParameters[K_USER_ID] = SESSION.getUserId()
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_HOME_VIEWALL_GIGS, method: .post, parameters: dictParameters).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
    //Get Category Gigs
    func getCategoryAllInfo(categoryId:String, isFromBuy:Bool, sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
        
        var dictParameters = [String:String]()
        //dictParameters[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
        dictParameters[kDEVICE_VIEWALL] = kDEVICE_VIEWALL_SERVICES
        //dictParameters[K_USER_ID] = "1"
        
        if isFromBuy {
            dictParameters[kUSER_ID] = categoryId
        }
            
        else {
            dictParameters[kDEVICE_CATEGORY_iD] = categoryId
        }
        
        Alamofire.request(WEB_SERVICE_URL+CASE_HOME_VIEWALL_GIGS, method: .post, parameters: dictParameters).responseJSON
            {(response) in
                
                let jsonDict = response.result.value as? [String:Any]
                
                if response.result.isSuccess {
                    
                    sucessblock(jsonDict! as NSDictionary)
                }
                    
                else if response.result.isFailure {
                    
                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
                }
        }
    }
    
    // STRIPE SUCCESS SERVICE
    func stripeSuccessRequest(parameter:[String:Any], sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
        
        //        var dictParameters = [String:String]()
        //        dictParameters[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
        //        dictParameters[K_PAYPAL_ID] = paypal_id
        //        dictParameters[K_ITEM_NUMBER] = item_number
        
        Alamofire.request(WEB_SERVICE_URL+CASE_STRIPE_PAYMENT, method: .post , parameters: parameter).responseJSON
            {(response) in
                
                let jsonDict = response.result.value as? [String:Any]
                
                if response.result.isSuccess {
                    
                    sucessblock(jsonDict! as NSDictionary)
                }
                    
                else if response.result.isFailure {
                    
                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
                }
        }
    }
    
    // PAYPAL SUCCESS SERVICE
    func paypalSuccessRequest(item_number:String, paypal_id:String, sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
        
        var dictParameters = [String:String]()
        dictParameters[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
        dictParameters[K_PAYPAL_ID] = paypal_id
        dictParameters[K_ITEM_NUMBER] = item_number
        
        Alamofire.request(WEB_SERVICE_URL+CASE_PAYPAL_SUCCESS_SERVICE, method: .post , parameters: dictParameters).responseJSON
            {(response) in
                
                let jsonDict = response.result.value as? [String:Any]
                
                if response.result.isSuccess {
                    
                    sucessblock(jsonDict! as NSDictionary)
                }
                    
                else if response.result.isFailure {
                    
                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
                }
        }
    }
    
//    //Get View All Reviews Gigs
//    func getViewAllReviewsInfo(sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//
//        var dictParameters = [String:String]()
//        dictParameters[K_USER_ID] = SESSION.getUserId()
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_HOME_VIEWALL_GIGS, method: .post, parameters: dictParameters).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    //Get Favourites Gigs
//    func getFavouritesGigsInfo(sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//
//        var dictParameters = [String:String]()
//        dictParameters[K_USER_ID] = SESSION.getUserId()
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_HOME_FAVOURTIES_GIGS, method: .post, parameters: dictParameters).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
    //Get Last Visited Gigs
//    func getLastVisitedGigsInfo(parameter:[String:String],sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_HOME_LAST_VISITED_GIGS, method: .post, parameters: parameter).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
//
//    //Get My Gigs
//    func getMyGigsInfo(sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_HOME_MY_GIGS+SESSION.getUserId(), method: .get).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    //Get Search
//    func getSearchInfo(parameter:[String:String],sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_HOME_SEARCH, method: .post, parameters: parameter).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    //Add to Favourites
//    func addToFavourites(gigId:String,sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//
//        var dictParameters = [String:String]()
//        dictParameters[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
//        dictParameters[K_USER_ID] = SESSION.getUserId()
//        dictParameters[K_GIG_ID] = gigId
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_HOME_ADD_FAVOURTIES_GIGS, method: .post, parameters: dictParameters).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
//
//    //Remove from Favourites
//    func removeFromFavourites(gigId:String,sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//
//        var dictParameters = [String:String]()
//        dictParameters[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
//        dictParameters[K_USER_ID] = SESSION.getUserId()
//        dictParameters[K_GIG_ID] = gigId
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_HOME_REMOVE_FAVOURTIES_GIGS, method: .post, parameters: dictParameters).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    //Create Gigs
//    func createGigsRequest(parameter:[String:String], sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_CREATE_GIGS, method: .post, parameters: parameter).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    //Profile Request
//    func PaypalRequest(parameter:[String:String], confirmPasswordSucessBlock: @escaping (NSDictionary)->(), failureBlock:@escaping (String) ->()) {
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_PAYPAL, method: .post, parameters: parameter).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    confirmPasswordSucessBlock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock(ALERT_UNABLE_TO_REACH_DESC)
//                }
//        }
//    }
    
//    //Get Settings
//    func settingsRequest(sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//
//        var dictParameters = [String:String]()
//        dictParameters[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_SETTINGS, method: .get , parameters: dictParameters).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }

//    //Terms and condition
//    func TermsandConditionRequest(sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_TERMS_AND_CONDITION, method: .get , parameters: nil).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    //User Price Type
//    func userPriceTypeRequest(sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_USER_PRICE_TYPE, method: .get , parameters: nil).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    //User edit information
//    func userProfileRequest(parameter:[String:String],sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//        
//        Alamofire.request(WEB_SERVICE_URL+CASE_VIEW_USER_PROFILE, method: .post, parameters: parameter).responseJSON
//            {(response) in
//                
//                let jsonDict = response.result.value as? [String:Any]
//                
//                if response.result.isSuccess {
//                    
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//                    
//                else if response.result.isFailure {
//                    
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    //Gig edit information
//    func editGigRequest(parameter:[String:String],sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_VIEW_EDIT_GIG_DETAIL, method: .post, parameters: parameter).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    //Get User Reviews Gigs
//
//    func getAllUserReviewsInfo(parameter:[String:String], sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//        
//        Alamofire.request(WEB_SERVICE_URL+CASE_VIEWALL_USERREVIEWS, method: .post, parameters: parameter).responseJSON
//            {(response) in
//                
//                let jsonDict = response.result.value as? [String:Any]
//                
//                if response.result.isSuccess {
//                    
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//                    
//                else if response.result.isFailure {
//                    
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    //Send contact message
//
//    func sendContactMessage(parameter:[String:String], sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_CONTACT_MESSAGE, method: .post, parameters: parameter).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    //Add Favourites
//
//    func setAddFavourites(parameter:[String:String], sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_ADD_FAVOURITES, method: .post, parameters: parameter).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
//
//    //Remove Favourites
//
//    func setRemoveFavourites(parameter:[String:String], sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_REMOVE_FAVOURITES, method: .post, parameters: parameter).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    //Last visited gigs
//
//    func sendLastVisitedGigs(parameter:[String:String], sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_LAST_VISITED_GIGS, method: .post, parameters: parameter).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    //BUY SERVICE REQUEST
//    func buySericeRequest(parameter:[String:Any], forgetSucessBlock: @escaping (NSDictionary)->(), failureBlock:@escaping (String) ->()) {
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_BUY_SERVICE, method: .post, parameters: parameter).responseJSON
//            {(response) in
//
//                if response.result.isSuccess {
//
//                    if let result = response.result.value {
//
//                        forgetSucessBlock(result as! NSDictionary)
//                    }
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    // PAYPAL SUCCESS SERVICE
//    func paypalSuccessRequest(item_number:String, paypal_id:String, sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//        
//        var dictParameters = [String:String]()
//        dictParameters[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
//        dictParameters[K_PAYPAL_ID] = paypal_id
//        dictParameters[K_ITEM_NUMBER] = item_number
//        
//        Alamofire.request(WEB_SERVICE_URL+CASE_PAYPAL_SUCCESS_SERVICE, method: .post , parameters: dictParameters).responseJSON
//            {(response) in
//                
//                let jsonDict = response.result.value as? [String:Any]
//                
//                if response.result.isSuccess {
//                    
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//                    
//                else if response.result.isFailure {
//                    
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
    func stripeBackendRequest(parameter:[String:Any], forgetSucessBlock: @escaping (NSDictionary)->(), failureBlock:@escaping (String) ->()) {
        
        print(parameter)
        
        let aUrl = URL(string: "https://iosgigs.herokuapp.com/charge")
        
        Alamofire.request(aUrl!, method: .post, parameters: parameter)
            .validate(statusCode: 200..<300)
            .responseString { response in
                
                print(response)
                
                switch response.result {
                case .success:
                    print("Success")
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
        
        //        Alamofire.request("https://iosgigs.herokuapp.com/charge", method: .post, parameters: parameter).responseJSON
        //            {(response) in
        //
        //                print(response)
        //
        //                if response.result.isSuccess {
        //
        //                    if let result = response.result.value {
        //
        //                        forgetSucessBlock(result as! NSDictionary)
        //                    }
        //                }
        //
        //                else if response.result.isFailure {
        //
        //                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
        //                }
        //        }
    }
    
    
//    //Get My Activity Gigs
//
//    func getMyActivity(userId:String, sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//
//        var dictParameters = [String:String]()
//        dictParameters[kDEVICE_VIEWALL] = kDEVICE_VIEWALL_SERVICES
//        dictParameters[K_USER_ID] = userId
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_MY_ACTIVITY, method: .post, parameters: dictParameters).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
    
//    // Paypal Payment Cancel
//
//    func paypalPaymentCancelSericeRequest(parameter:[String:Any], SucessBlock: @escaping (NSDictionary)->(), failureBlock:@escaping (String) ->()) {
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_PAYPAL_PAYMENT_CANCEL, method: .post, parameters: parameter).responseJSON
//            {(response) in
//
//                if response.result.isSuccess {
//
//                    if let result = response.result.value {
//
//                        SucessBlock(result as! NSDictionary)
//                    }
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    // Stripe Payment Cancel
//
//    func stripePaymentCancelSericeRequest(parameter:[String:Any], SucessBlock: @escaping (NSDictionary)->(), failureBlock:@escaping (String) ->()) {
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_STRIPE_PAYMENT_CANCEL, method: .post, parameters: parameter).responseJSON
//            {(response) in
//
//                if response.result.isSuccess {
//
//                    if let result = response.result.value {
//
//                        SucessBlock(result as! NSDictionary)
//                    }
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    // Stripe Payment Settings
//    
//    func stripePaymentEditSericeRequest(parameter:[String:Any], SucessBlock: @escaping (NSDictionary)->(), failureBlock:@escaping (String) ->()) {
//        
//        Alamofire.request(WEB_SERVICE_URL+CASE_STRIPE_PAYMENT_SETTINGS, method: .post, parameters: parameter).responseJSON
//            {(response) in
//                
//                if response.result.isSuccess {
//                    
//                    if let result = response.result.value {
//                        
//                        SucessBlock(result as! NSDictionary)
//                    }
//                }
//                    
//                else if response.result.isFailure {
//                    
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    // Amount Withdraw Api
//
//    func amountWithdrawApi(orderId:String, sucessblock: @escaping (NSDictionary) ->(), failureBlock: @escaping (String)->()) {
//
//        var dictParameters = [String:String]()
//        dictParameters[kDEVICE_VIEWALL] = kDEVICE_VIEWALL_SERVICES
//        dictParameters[K_ORDER_ID] = orderId
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_AMOUNT_WITHDRAW, method: .post, parameters: dictParameters).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessblock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    // Order Status Api
//    func orderStatusApiRequest(parameter:[String:Any], SucessBlock: @escaping (NSDictionary)->(), failureBlock:@escaping (String) ->()) {
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_ORDER_STATUS, method: .post, parameters: parameter).responseJSON
//            {(response) in
//
//                if response.result.isSuccess {
//
//                    if let result = response.result.value {
//
//                        SucessBlock(result as! NSDictionary)
//                    }
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    // Complete Request Api
//    func completeRequestApiRequest(parameter:[String:Any], SucessBlock: @escaping (NSDictionary)->(), failureBlock:@escaping (String) ->()) {
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_COMPLETE_REQUEST, method: .post, parameters: parameter).responseJSON
//            {(response) in
//
//                if response.result.isSuccess {
//
//                    if let result = response.result.value {
//
//                        SucessBlock(result as! NSDictionary)
//                    }
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock((ALERT_UNABLE_TO_REACH_DESC))
//                }
//        }
//    }
    
//    //Chat Request
//    func getChatList(parameter:[String:String], sucessBlock: @escaping (NSDictionary)->(), failureBlock:@escaping (String) ->()) {
//        
//        Alamofire.request(WEB_SERVICE_URL+CASE_CHAT_LIST, method: .post, parameters: parameter).responseJSON
//            {(response) in
//                
//                let jsonDict = response.result.value as? [String:Any]
//                
//                if response.result.isSuccess {
//                    
//                    sucessBlock(jsonDict! as NSDictionary)
//                }
//                    
//                else if response.result.isFailure {
//                    
//                    failureBlock(ALERT_UNABLE_TO_REACH_DESC)
//                }
//        }
//    }
    
//    //Chat Detail Request
//    func getChatDetail(parameter:[String:String], sucessBlock: @escaping (NSDictionary)->(), failureBlock:@escaping (String) ->()) {
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_CHAT_DETAIL, method: .post, parameters: parameter).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessBlock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock(ALERT_UNABLE_TO_REACH_DESC)
//                }
//        }
//    }
    
//    //User Chat Request
//    func getUserChat(parameter:[String:String], sucessBlock: @escaping (NSDictionary)->(), failureBlock:@escaping (String) ->()) {
//
//        Alamofire.request(WEB_SERVICE_URL+CASE_CHAT_USER, method: .post, parameters: parameter).responseJSON
//            {(response) in
//
//                let jsonDict = response.result.value as? [String:Any]
//
//                if response.result.isSuccess {
//
//                    sucessBlock(jsonDict! as NSDictionary)
//                }
//
//                else if response.result.isFailure {
//
//                    failureBlock(ALERT_UNABLE_TO_REACH_DESC)
//                }
//        }
//    }
    
    
    //Common GET method
    func callGetApi(strUrl:String, sucessBlock: @escaping (NSDictionary)->(), failureBlock:@escaping (String) ->()) {
        
        let headers = [
            "token": SESSION.getUserId().count == 0 ? "8338d6ff4f0878b222f312494c1621a9" : SESSION.getUserId(),
            ]
        
//        var headers = [String:Any]()
//
//        if SESSION.getUserId().count == 0 {
//            headers = ["token": "8338d6ff4f0878b222f312494c1621a9",]
//        }
//
//        else
//        {
//            headers = ["token": SESSION.getUserId(),]
//        }
        
        var dictParameters = [String:String]()
        dictParameters[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
        
        Alamofire.request(strUrl, method: .get, parameters: dictParameters, encoding: Alamofire.URLEncoding.default, headers: headers).responseJSON
            {(response) in
                
                let jsonDict = response.result.value as? [String:Any]
                
                if response.result.isSuccess {
                    
                    sucessBlock(jsonDict! as NSDictionary)
                    
                    let aIntResponseCode = jsonDict!["code"] as! Int
                    let aMessageResponse = jsonDict!["message"] as! String

                    if aIntResponseCode == RESPONSE_CODE_498 {

                        HELPER.showAlertControllerWithOkActionBlock(aViewController: (APPDELEGATE.window?.rootViewController)!, aStrMessage: aMessageResponse, okActionBlock: { (action) in

                            SESSION.setIsUserLogIN(isLogin: false)
                            SESSION.setUserImage(aStrUserImage: "")
                            SESSION.setUserPriceOption(option: "", price: "", extraprice: "")
                            SESSION.setUserId(aStrUserId: "")
                            APPDELEGATE.loadLogInSceen()

                        })
                    }
                }
                    
                else if response.result.isFailure {
                    
                    failureBlock(ALERT_TYPE_SERVER_ERROR)
                }
        }
    }
    
    //Common POST method
    func callPostApi(strUrl:String, dictParameters:[String : String], sucessBlock: @escaping (NSDictionary)->(), failureBlock:@escaping (String) ->()) {
        
        var headers:HTTPHeaders? = nil
        if SESSION.getUserId().count == 0 {
//            headers = ["Content-Type" : "application/json; charset=utf-8","token": SESSION.getUserToken().count == 0 ? "8338d6ff4f0878b222f312494c1621a9" : SESSION.getUserToken()]
            headers = ["Content-Type" : "application/json; charset=utf-8","token": "8338d6ff4f0878b222f312494c1621a9" ]
        }
        
        else
        {
            headers = ["Content-Type" : "application/json; charset=utf-8","token":  SESSION.getUserId()]
        }
        
        Alamofire.request(strUrl, method : .post, parameters : dictParameters, encoding : JSONEncoding.default , headers : headers).responseData {
            (dataResponse) in
            
            print(dataResponse.request as Any) // your request
            print(dataResponse.response as Any) // your response
            print(dataResponse.result.value as Any) // your response
            
            if dataResponse.result.isSuccess {
                
                var jsonResponse  = [String :Any]()
                
                if let encryptedData:NSData = dataResponse.result.value! as NSData {
                    
                    print(NSString(data: (encryptedData as Data) as Data, encoding: String.Encoding.utf8.rawValue)! as String)
                    
                    do {
                        jsonResponse = try JSONSerialization.jsonObject(with: encryptedData as Data, options: .mutableContainers) as! [String : Any]
                        print(jsonResponse as NSDictionary)
                        
                        let aIntResponseCode = jsonResponse["code"] as! Int
                        let aMessageResponse = jsonResponse["message"] as! String
                        
                        if aIntResponseCode == RESPONSE_CODE_498 {

                            HELPER.showAlertControllerWithOkActionBlock(aViewController: (APPDELEGATE.window?.rootViewController)!, aStrMessage: aMessageResponse, okActionBlock: { (action) in

                                SESSION.setIsUserLogIN(isLogin: false)
                                SESSION.setUserImage(aStrUserImage: "")
                                SESSION.setUserPriceOption(option: "", price: "", extraprice: "")
                                SESSION.setUserId(aStrUserId: "")
                                APPDELEGATE.loadLogInSceen()

                            })
                        }
                    }
                        
                    catch let error
                    {
                        print(error)
                    }
                }
                
                sucessBlock(jsonResponse as NSDictionary)
                
            }
                
            else if dataResponse.result.isFailure {
                
                failureBlock(ALERT_TYPE_SERVER_ERROR)
            }
        }
        
    }
    
    
    func callPaymentPostApi(strUrl:String, dictParameters:[String : Any], sucessBlock: @escaping (NSDictionary)->(), failureBlock:@escaping (String) ->()) {
        
        var headers:HTTPHeaders? = nil
        if SESSION.getUserId().count == 0 {
            //            headers = ["Content-Type" : "application/json; charset=utf-8","token": SESSION.getUserToken().count == 0 ? "8338d6ff4f0878b222f312494c1621a9" : SESSION.getUserToken()]
            headers = ["Content-Type" : "application/json; charset=utf-8","token": "8338d6ff4f0878b222f312494c1621a9" ]
        }
            
        else
        {
            headers = ["Content-Type" : "application/json; charset=utf-8","token":  SESSION.getUserId()]
        }
        
        Alamofire.request(strUrl, method : .post, parameters : dictParameters, encoding : JSONEncoding.default , headers : headers).responseData {
            (dataResponse) in
            
            print(dataResponse.request as Any) // your request
            print(dataResponse.response as Any) // your response
            print(dataResponse.result.value as Any) // your response
            
            if dataResponse.result.isSuccess {
                
                var jsonResponse  = [String :Any]()
                
                if let encryptedData:NSData = dataResponse.result.value! as NSData {
                    
                    print(NSString(data: (encryptedData as Data) as Data, encoding: String.Encoding.utf8.rawValue)! as String)
                    
                    do {
                        jsonResponse = try JSONSerialization.jsonObject(with: encryptedData as Data, options: .mutableContainers) as! [String : Any]
                        print(jsonResponse as NSDictionary)
                        
                        let aIntResponseCode = jsonResponse["code"] as! Int
                        let aMessageResponse = jsonResponse["message"] as! String
                        
                        if aIntResponseCode == RESPONSE_CODE_498 {
                            
                            HELPER.showAlertControllerWithOkActionBlock(aViewController: (APPDELEGATE.window?.rootViewController)!, aStrMessage: aMessageResponse, okActionBlock: { (action) in
                                
                                SESSION.setIsUserLogIN(isLogin: false)
                                SESSION.setUserImage(aStrUserImage: "")
                                SESSION.setUserPriceOption(option: "", price: "", extraprice: "")
                                SESSION.setUserId(aStrUserId: "")
                                APPDELEGATE.loadLogInSceen()
                                
                            })
                        }
                    }
                        
                    catch let error
                    {
                        print(error)
                    }
                }
                
                sucessBlock(jsonResponse as NSDictionary)
                
            }
                
            else if dataResponse.result.isFailure {
                
                failureBlock(ALERT_TYPE_SERVER_ERROR)
            }
        }
        
    }
    
    
    //    func callUploadImageApi(strUrl:String,params:[String:String], sucessBlock: @escaping (NSDictionary)->(), failureBlock:@escaping (String) ->()) {
    //
    //        let dict = params
    //        var myImageUrl = dict[""]
    //        var myCardImgUrl = dict[""]
    //        Alamofire.upload(multipartFormData: { (multipartFormData) in
    //
    //            if myImageUrl != nil {
    //
    //                multipartFormData.append(myImageUrl!, withName: "profile_img")
    //
    //            }
    //            if myCardImgUrl != nil {
    //
    //                multipartFormData.append(myCardImgUrl!, withName: "ic_card_image")
    //
    //            }
    //
    //            for (key, value) in dict {
    //
    //                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
    //            }
    //        }, to: WEB_SERVICE_URL + CASE_REGISTER) { (response) in
    //
    //            let jsonDict = response.result.value as? [String:Any]
    //
    //            if response.result.isSuccess {
    //
    //                sucessBlock(jsonDict! as NSDictionary)
    //            }
    //
    //            else if response.result.isFailure {
    //
    //                failureBlock(ALERT_UNABLE_TO_REACH_DESC)
    //            }
    //        }
    //    }
    
    
}

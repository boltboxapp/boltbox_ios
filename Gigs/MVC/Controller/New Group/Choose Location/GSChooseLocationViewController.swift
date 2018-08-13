//
//  GSChooseLocationViewController.swift
//  Gigs
//
//  Created by dreams on 05/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

let cellIdentifier: String = "GSChooseLocationTableViewCell"

class GSChooseLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var myTblView: UITableView!
    
    var gIsClickCountry = false
    var gIsClickState = false
    var gIsClickLanguage = false
    var gIsClickProfession = false
    var gIsClickCategory = false

    var myAryCountryInfo = [[String:Any]]()
    var myAryStateInfo = [[String:Any]]()
    var myAryProfessionInfo = [[String:Any]]()
    var myAryCategoryInfo = [[String:Any]]()

    var myAryLanguageInfo = [String]()

    var myAryCountryFilterInfo = [[String:Any]]()
    var myAryStateFilterInfo = [[String:Any]]()
    
    var gStrCountryId = String()
    var myStrStateId = String()
    var gStrProfessionId = String()
    var gStrCategoryId = String()

    var myStrCountryName = String()
    var myStrStateName = String()
    var myStrLanguageName = String()
    var myStrProfession = String()
    var myStrCategoryName = String()
    
    var selectedCountryIndexes = String()

    typealias CompletionBlock = (String?,String?) -> Void
    var completion: CompletionBlock = { reason,reason1  in print(reason ?? false) }
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpUI()
        setUpModel()
        loadModel()
        
        // Do any additional setup after loading the view.
        myTblView.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    func setUpUI() {
        
        NAVIGAION.setNavigationTitle(aStrTitle: gIsClickCountry ? "Choose your country" : gIsClickLanguage ? "Choose your Language": gIsClickProfession ? "Choose your Profession" :gIsClickCategory ?"Choose your Category" : "Choose your state", aViewController: self)
        
        setUpLeftBarBackButton()
        //setUpRightBarSearchButton()
        
        self.myTblView.tableFooterView = UIView()
    }
    
    func setUpModel() {
        
       
    }
    
    func loadModel() {
        
        if gIsClickCountry == true {
            
            callCountryApi()
        }
        else if gIsClickLanguage == true {
            
            callLanguageApi()
        }
        else if gIsClickProfession == true {
            
            callProfessionApi()
        }
        else if gIsClickCategory == true {
            
            callCategoryList()
        }
        else {
            
            callStateApi()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Table view delegate and datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if gIsClickLanguage == true {
            
            return myAryLanguageInfo.count
        }
        else if gIsClickProfession == true  {
            
            return myAryProfessionInfo.count
        }
        else if gIsClickCategory == true {
            
            return myAryCategoryInfo.count
        }
        else {
            
            return gIsClickCountry ? myAryCountryFilterInfo.count : myAryStateFilterInfo.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func getIndex() -> String? {
        
        var splittedArray = self.gStrCountryId.components(separatedBy: ",")
        for index in 0...splittedArray.count - 1 {

            let indexes = myAryLanguageInfo.index(of: splittedArray[index])
            
            if selectedCountryIndexes.count > 0 {
                selectedCountryIndexes.append(",\(indexes ?? 0)")
            }
            else {
                selectedCountryIndexes.append("\(indexes ?? 0)")
            }
        }
        
        return selectedCountryIndexes
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! GSChooseLocationTableViewCell
        
        if gIsClickCountry {
            
            aCell.gLblChooseLoc.text = myAryCountryFilterInfo[indexPath.row]["country"] as? String;
            
            if gStrCountryId.count != 0 {
                
                let aStrCountryId =  self.myAryCountryFilterInfo[indexPath.row]["id"] as! String
                
                if self.gStrCountryId == aStrCountryId {
                    
                    HELPER.changeTheImageViewColorWithHex(hex: APP_COLOR, imageView: aCell.gImgView, imageName: ICON_TICK)
                }
                
                else {
                    
                    aCell.gImgView.image = nil
                }
            }
            
        }
            
        else if gIsClickLanguage {
            
            aCell.gLblChooseLoc.text = myAryLanguageInfo[indexPath.row]
            aCell.gImgView.image = nil
            if gStrCountryId.count != 0 {
                    var splittedArray = gStrCountryId.components(separatedBy: ",")
                    splittedArray = splittedArray.filter { $0 != "" }
                    let aPredicateName = NSPredicate(format:"SELF == %@",myAryLanguageInfo[indexPath.row])
                    let aFilteredArray = splittedArray.filter {aPredicateName.evaluate(with: $0)};
                    
                    if aFilteredArray.count > 0 {
                        HELPER.changeTheImageViewColorWithHex(hex: APP_COLOR, imageView: aCell.gImgView, imageName: ICON_TICK)
                    }
                else {
                    
                    aCell.gImgView.image = nil
                }
            }
        }
            
        else if gIsClickProfession {
            
            aCell.gLblChooseLoc.text = myAryProfessionInfo[indexPath.row]["profession_name"] as? String;
            
            if gStrCountryId.count != 0 {
                
                let aStrCountryId =  self.myAryCountryFilterInfo[indexPath.row]["id"] as! String
                
                if self.gStrCountryId == aStrCountryId {
                    
                    HELPER.changeTheImageViewColorWithHex(hex: APP_COLOR, imageView: aCell.gImgView, imageName: ICON_TICK)
                }
                    
                else {
                    
                    aCell.gImgView.image = nil
                }
            }
        }
            
        else if gIsClickCategory {
            
            aCell.gLblChooseLoc.text = myAryCategoryInfo[indexPath.row]["name"] as? String;
            
            if gStrCountryId.count != 0 {
                
                let aStrCountryId =  self.myAryCategoryInfo[indexPath.row]["cid"] as! String
                
                if self.gStrCountryId == aStrCountryId {
                    
                    HELPER.changeTheImageViewColorWithHex(hex: APP_COLOR, imageView: aCell.gImgView, imageName: ICON_TICK)
                }
                    
                else {
                    
                    aCell.gImgView.image = nil
                }
            }
        }
            
        else {
            
            aCell.gLblChooseLoc.text = myAryStateFilterInfo[indexPath.row]["state_name"] as? String;
            
            if myStrStateId.count != 0 {
                
                let aStrStateId =  self.myAryStateFilterInfo[indexPath.row]["state_id"] as! String
                
                if self.myStrStateId == aStrStateId {
                    
                    HELPER.changeTheImageViewColorWithHex(hex: APP_COLOR, imageView: aCell.gImgView, imageName: ICON_TICK)
                }
                
                else {
                    
                    aCell.gImgView.image = nil
                }
            }
        }
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let aCell:GSChooseLocationTableViewCell = tableView.cellForRow(at: indexPath) as! GSChooseLocationTableViewCell
        
        if gIsClickCountry {
            
            gStrCountryId = myAryCountryFilterInfo[indexPath.row]["id"] as! String
            myStrCountryName = myAryCountryFilterInfo[indexPath.row]["country"] as! String
            self.completion(myStrCountryName, gStrCountryId)
            self.navigationController?.popViewController(animated: true)

        }
        else if gIsClickLanguage {
            
            let selectedLanguage = myAryLanguageInfo[indexPath.row] as String
            
            if  aCell.gImgView.image != nil {
                myStrLanguageName = gStrCountryId
                aCell.gImgView.image = nil
                
                if selectedLanguage.contains(",") {
                    
                }
                else {
                    let splitArr = myStrLanguageName.components(separatedBy: ",")
                    let firstStr = splitArr.first
                    
                    if firstStr != selectedLanguage {
                        myStrLanguageName = myStrLanguageName.replacingOccurrences(of: selectedLanguage, with: "\(selectedLanguage),")
                    }
                }
                if myStrLanguageName.contains(selectedLanguage) {
                    
                    let splitArr = myStrLanguageName.components(separatedBy: ",")
                    let firstStr = splitArr.first
                    
                    if firstStr == selectedLanguage {
                        if splitArr.count == 1 {
                            myStrLanguageName = myStrLanguageName.replacingOccurrences(of: "\(selectedLanguage)", with: "")
                        }
                        else {
                            myStrLanguageName = myStrLanguageName.replacingOccurrences(of: "\(selectedLanguage),", with: "")
                        }
                    }
                    else {
                        myStrLanguageName = myStrLanguageName.replacingOccurrences(of: ",\(selectedLanguage),", with: "")
                    }
                }
            }
            else {
                myStrLanguageName = gStrCountryId
                
                if myStrLanguageName.contains(selectedLanguage) {
                    
                }
                else {
                    if myStrLanguageName.count > 0 {
                        myStrLanguageName.append(",\(selectedLanguage)")
                    }
                    else {
                        myStrLanguageName.append("\(selectedLanguage)")
                    }
                }
                
                HELPER.changeTheImageViewColorWithHex(hex: APP_COLOR, imageView: aCell.gImgView, imageName: ICON_TICK)
                
                
            }
            gStrCountryId = myStrLanguageName
            self.completion(myStrLanguageName, "")
        }
        else if gIsClickProfession {
            
            gStrProfessionId = myAryProfessionInfo[indexPath.row]["id"] as! String
            myStrProfession = myAryProfessionInfo[indexPath.row]["profession_name"] as! String
           
            self.completion(myStrProfession, gStrProfessionId)
            self.navigationController?.popViewController(animated: true)

        }
        else if gIsClickCategory {
            
            if myAryCategoryInfo[indexPath.row]["subcategory"]as? String == "0" {
                
//                let aViewcontroller = GSViewAllGigsViewController()
//                aViewcontroller.gIsCategoryAll = true
//                aViewcontroller.gStrCategoryId = myAryCategoryInfo[indexPath.row]["cid"] as! String
//                aViewcontroller.gStrCategoryName = myAryCategoryInfo[indexPath.row]["name"] as! String
//                self.navigationController?.pushViewController(aViewcontroller, animated: true)
                
                gStrCategoryId = myAryCategoryInfo[indexPath.row]["cid"] as! String
                myStrCategoryName = myAryCategoryInfo[indexPath.row]["name"] as! String
                self.completion(myStrCategoryName, gStrCategoryId)
                self.navigationController?.popViewController(animated: true)
                
                
            } else if myAryCategoryInfo[indexPath.row]["subcategory"]as? String == "1" {
                
                let aViewcontroller = GSSubCategoryViewController()
                aViewcontroller.gStrCategoryId = myAryCategoryInfo[indexPath.row]["cid"] as! String
                aViewcontroller.gStrCategoryName = myAryCategoryInfo[indexPath.row]["name"] as! String
                self.navigationController?.pushViewController(aViewcontroller, animated: true)
            }
        }
        else {
            
            myStrStateId = myAryStateInfo[indexPath.row]["state_id"] as! String
            myStrStateName = myAryStateInfo[indexPath.row]["state_name"] as! String
            self.completion(myStrStateName, myStrStateId)
            self.navigationController?.popViewController(animated: true)

        }
     }

    
    // MARK:- Api

    //Country
    func callCountryApi() {

        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }

        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "Getting country..")
        
        HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL + CASE_COUNTRY, sucessBlock: {response in

            HELPER.hideLoadingAnimation()

            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String

            if aIntResponseCode == RESPONSE_CODE_200 {

                self.myAryCountryInfo = response["data"] as! [[String : Any]]

            } else {

                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }

            self.updateCountryFilterArrayInfo(filterArray: self.myAryCountryInfo)

            if self.gStrCountryId.count != 0  {

                for index in 0...self.myAryCountryInfo.count - 1 {

                    let aStrCountryId =  self.myAryCountryInfo[index]["id"] as! String

                    if self.gStrCountryId == aStrCountryId {

                        self.myTblView .scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)

                        return
                    }
                }
            }

        }, failureBlock: { error in

            HELPER.hideLoadingAnimation()
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
        })
    }

    //State
    func callStateApi() {

        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }

        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "Getting state..")

        HTTPMANAGER.callGetApi(strUrl:WEB_SERVICE_URL+CASE_STATE + "/" + gStrCountryId, sucessBlock: {response in
            
            HELPER.hideLoadingAnimation()
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                self.myAryStateInfo = response["data"] as! [[String : Any]]
                
            } else {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
            self.updateStateFilterArrayInfo(filterArray: self.myAryStateInfo)
            
            
            if self.myStrStateId.count != 0  {
                
                for index in 0...self.myAryStateInfo.count - 1 {
                    
                    let aStrStateId =  self.myAryStateInfo[index]["state_id"] as! String
                    
                    if self.myStrStateId == aStrStateId {
                        
                        self.myTblView .scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
                        return
                    }
                }
            }
            
        }, failureBlock: { error in

            HELPER.hideLoadingAnimation()
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
        })
    }
    
    //Language
    func callLanguageApi() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "Getting Language..")
        
          HTTPMANAGER.callGetApi(strUrl:WEB_SERVICE_URL+CASE_LANGUAGE, sucessBlock: {response in
            
            HELPER.hideLoadingAnimation()
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                self.myAryLanguageInfo = response["data"] as! [String]
                
                //                self.selectedCountryIndexes = self.getIndex()!
                
            } else {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
            self.updateLanguageFilterArrayInfo(filterArray: self.myAryLanguageInfo)
            
            if self.gStrCountryId.count != 0  {
                
                for index in 0...self.myAryLanguageInfo.count - 1 {
                    
                    let aStrCountryId =  self.myAryLanguageInfo[index]
                    
                    if self.gStrCountryId == aStrCountryId {
                        
                        self.myTblView .scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
                        
                        return
                    }
                }
            }
            
        }, failureBlock: { error in
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    //Profession
    func callProfessionApi() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "Getting Professions..")
        
        HTTPMANAGER.callGetApi(strUrl:WEB_SERVICE_URL+CASE_PROFESSION, sucessBlock: {response in
            
            HELPER.hideLoadingAnimation()
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                self.myAryProfessionInfo = response["data"] as! [[String : Any]]
                
                print(self.myAryProfessionInfo)
                
            } else {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
            self.updateProfessionFilterArrayInfo(filterArray: self.myAryProfessionInfo)
            
            if self.gStrProfessionId.count != 0  {
                
                for index in 0...self.myAryProfessionInfo.count - 1 {
                    
                    let aStrProfessionId =  self.myAryProfessionInfo[index]["id"] as! String
                    
                    if self.gStrProfessionId == aStrProfessionId {
                        
                        self.myTblView .scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
                        
                        return
                    }
                }
            }
            
        }, failureBlock: { error in
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    //Category
    func callCategoryList() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        //        HELPER.showLoadingViewAnimation(viewController: self)
        
        HTTPMANAGER.callGetApi(strUrl:WEB_SERVICE_URL+CASE_HOME_VIEWALL_GIGS, sucessBlock: {response in
    
            HELPER.hideLoadingAnimation(viewController: self)
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                print(response)
                
                self.myAryCategoryInfo = response["primary"] as! [[String : Any]] as! [[String : String]]
                
                self.myTblView.reloadData()
                
            }
            else {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation(viewController: self)
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    
    func callCountryAi() {

        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }

        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "Getting country..")

        HTTPMANAGER.callGetApi(strUrl:WEB_SERVICE_URL+CASE_COUNTRY, sucessBlock: {response in

//        HTTPMANAGER.getCountryInfo(sucessblock: {response in

            HELPER.hideLoadingAnimation()

            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String

            if aIntResponseCode == RESPONSE_CODE_200 {

                self.myAryCountryInfo = response["data"] as! [[String : Any]]

            } else {

                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }

            self.updateCountryFilterArrayInfo(filterArray: self.myAryCountryInfo)

            if self.gStrCountryId.count != 0  {

                for index in 0...self.myAryCountryInfo.count - 1 {

                    let aStrCountryId =  self.myAryCountryInfo[index]["id"] as! String

                    if self.gStrCountryId == aStrCountryId {

                        self.myTblView .scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)

                        return
                    }
                }
            }

        }, failureBlock: { error in

            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
//
//    //State
//    func callStateApi() {
//
//        if !HELPER.isConnectedToNetwork() {
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
//            return
//        }
//
//        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "Getting state..")
//
//        HTTPMANAGER.getStateInfo(countryId: gStrCountryId, sucessblock: {response in
//
//            HELPER.hideLoadingAnimation()
//
//            let aIntResponseCode = response["code"] as! Int
//            let aMessageResponse = response["message"] as! String
//
//            if aIntResponseCode == RESPONSE_CODE_200 {
//
//                self.myAryStateInfo = response["data"] as! [[String : Any]]
//
//            } else {
//
//                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
//            }
//
//            self.updateStateFilterArrayInfo(filterArray: self.myAryStateInfo)
//
//
//            if self.myStrStateId.count != 0  {
//
//                for index in 0...self.myAryStateInfo.count - 1 {
//
//                    let aStrStateId =  self.myAryStateInfo[index]["state_id"] as! String
//
//                    if self.myStrStateId == aStrStateId {
//
//                        self.myTblView .scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
//                        return
//                    }
//                }
//            }
//
//        }, failureBlock: { error in
//
//            HELPER.hideLoadingAnimation()
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
//        })
//    }
    
//    //Language
//    func callLanguageApi() {
//
//        if !HELPER.isConnectedToNetwork() {
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
//            return
//        }
//
//        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "Getting Language..")
//
//        HTTPMANAGER.getLanguageInfo(sucessblock: {response in
//
//            HELPER.hideLoadingAnimation()
//
//            let aIntResponseCode = response["code"] as! Int
//            let aMessageResponse = response["message"] as! String
//
//            if aIntResponseCode == RESPONSE_CODE_200 {
//
//                self.myAryLanguageInfo = response["data"] as! [String]
//
////                self.selectedCountryIndexes = self.getIndex()!
//
//            } else {
//
//                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
//            }
//
//            self.updateLanguageFilterArrayInfo(filterArray: self.myAryLanguageInfo)
//
//            if self.gStrCountryId.count != 0  {
//
//                for index in 0...self.myAryLanguageInfo.count - 1 {
//
//                    let aStrCountryId =  self.myAryLanguageInfo[index]
//
//                    if self.gStrCountryId == aStrCountryId {
//
//                        self.myTblView .scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
//
//                        return
//                    }
//                }
//            }
//
//        }, failureBlock: { error in
//
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
//        })
//    }
    
//    //Profession
//    func callProfessionApi() {
//
//        if !HELPER.isConnectedToNetwork() {//WEB_SERVICE_URL+CASE_PROFESSION
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
//            return
//        }
//
//        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "Getting Professions..")
//
//        HTTPMANAGER.getProfessionInfo(sucessblock: {response in
//
//            HELPER.hideLoadingAnimation()
//
//            let aIntResponseCode = response["code"] as! Int
//            let aMessageResponse = response["message"] as! String
//
//            if aIntResponseCode == RESPONSE_CODE_200 {
//
//                self.myAryProfessionInfo = response["data"] as! [[String : Any]]
//
//                print(self.myAryProfessionInfo)
//
//            } else {
//
//                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
//            }
//
//            self.updateProfessionFilterArrayInfo(filterArray: self.myAryProfessionInfo)
//
//            if self.gStrProfessionId.count != 0  {
//
//                for index in 0...self.myAryProfessionInfo.count - 1 {
//
//                    let aStrProfessionId =  self.myAryProfessionInfo[index]["id"] as! String
//
//                    if self.gStrProfessionId == aStrProfessionId {
//
//                        self.myTblView .scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
//
//                        return
//                    }
//                }
//            }
//
//        }, failureBlock: { error in
//
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
//        })
//    }
    
//    //Category
//    func callCategoryList() {
//
//        if !HELPER.isConnectedToNetwork() {
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
//            return
//        }
//
//        //        HELPER.showLoadingViewAnimation(viewController: self)
//
//        HTTPMANAGER.categoryListRequest(sucessblock: {response in
//
//            HELPER.hideLoadingAnimation(viewController: self)
//
//            let aIntResponseCode = response["code"] as! Int
//            let aMessageResponse = response["message"] as! String
//
//            if aIntResponseCode == RESPONSE_CODE_200 {
//
//                print(response)
//
//                self.myAryCategoryInfo = response["primary"] as! [[String : Any]] as! [[String : String]]
//
//                self.myTblView.reloadData()
//
//            }
//            else {
//
//                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
//            }
//
//        }, failureBlock: { error in
//
//            HELPER.hideLoadingAnimation(viewController: self)
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
//        })
//    }
    
    @objc func searchBarBtnTapped() {
        
        let searchBar = UISearchBar()
        
        searchBar.layer.cornerRadius = 3.0
        searchBar.clipsToBounds = true
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        
        searchBar.delegate = self
        searchBar.placeholder = "Search.."
        searchBar.textColor = UIColor.white
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        searchBar.becomeFirstResponder()
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        loadFilterInfo()
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        if gIsClickProfession {
            
            NAVIGAION.setNavigationTitle(aStrTitle: "Choose your Profession", aViewController: self)
            setUpRightBarSearchButton()
            
            searchBar.text = nil
            searchBar.showsCancelButton = false
            searchBar.endEditing(true)
            
            loadFilterInfo()
        }
        
        else if gIsClickLanguage {
            
            NAVIGAION.setNavigationTitle(aStrTitle: "Choose your Language", aViewController: self)
            setUpRightBarSearchButton()
            
            searchBar.text = nil
            searchBar.showsCancelButton = false
            searchBar.endEditing(true)
            
            loadFilterInfo()
        }
            
        else {
            
            NAVIGAION.setNavigationTitle(aStrTitle: gIsClickCountry ? "Choose your country" : "Choose your state", aViewController: self)
            setUpRightBarSearchButton()
            
            searchBar.text = nil
            searchBar.showsCancelButton = false
            searchBar.endEditing(true)
            
            loadFilterInfo()
        }
    }
    
    func dia(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        var aFilteredArray = [[String:Any]]()
        var aLangFilteredArray = [String]()

        var aPredicateName:NSPredicate!
        
        if gIsClickCountry {
            
            aPredicateName = NSPredicate(format:"country contains[c] %@",searchText)
            aFilteredArray = myAryCountryInfo.filter {aPredicateName.evaluate(with: $0)};
            self.updateCountryFilterArrayInfo(filterArray: aFilteredArray)
        }
        
        else if gIsClickLanguage {

//            aPredicateName = NSPredicate(format:"country contains[c] %@",searchText)
            
            let filteredData = searchText.isEmpty ? myAryLanguageInfo : myAryLanguageInfo.filter({(dataString: String) -> Bool in
                // If dataItem matches the searchText, return true to include it
                return dataString.range(of: searchText, options: .caseInsensitive) != nil
            })
            self.updateLanguageFilterArrayInfo(filterArray: filteredData)
            
//            aPredicateName = NSPredicate(format:"language[c] %@",searchText)
//            aLangFilteredArray = myAryLanguageInfo.filter {aPredicateName.evaluate(with: $0)};
//            self.updateLanguageFilterArrayInfo(filterArray: aLangFilteredArray)
        }
            
        else if gIsClickProfession {
            
            aPredicateName = NSPredicate(format:"profession_name contains[c] %@",searchText)
            aFilteredArray = myAryProfessionInfo.filter {aPredicateName.evaluate(with: $0)};
            self.updateProfessionFilterArrayInfo(filterArray: aFilteredArray)
        }

        else {
            
            aPredicateName = NSPredicate(format:"state_name contains[c] %@",searchText)
            aFilteredArray = myAryStateInfo.filter {aPredicateName.evaluate(with: $0)};
            self.updateStateFilterArrayInfo(filterArray: aFilteredArray)
        }
    }
    
    // MARK : - Private Methods

    func loadFilterInfo() {
        
        if gIsClickCountry {
            
            self.updateCountryFilterArrayInfo(filterArray: self.myAryCountryInfo)
        }
            
        else if gIsClickLanguage {

            self.updateLanguageFilterArrayInfo(filterArray: self.myAryLanguageInfo)
        }
        
        else if gIsClickProfession {
            
            self.updateProfessionFilterArrayInfo(filterArray: self.myAryProfessionInfo)

        }
        else {
            
            self.updateStateFilterArrayInfo(filterArray: self.myAryStateInfo)
        }
    }
    
    func updateCountryFilterArrayInfo(filterArray: [[String:Any]]) {
        
        myAryCountryFilterInfo = filterArray
        self.myTblView.reloadData()
    }
    
    func updateStateFilterArrayInfo(filterArray: [[String:Any]]) {
        
        myAryStateFilterInfo = filterArray
        self.myTblView.reloadData()
    }
    
    func updateLanguageFilterArrayInfo(filterArray: [String]) {

        myAryLanguageInfo = filterArray
        self.myTblView.reloadData()
    }
    
    func updateProfessionFilterArrayInfo(filterArray: [[String:Any]]) {
        
        myAryProfessionInfo = filterArray
        self.myTblView.reloadData()
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
    
    func setUpRightBarSearchButton() {
        
        let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchBarBtnTapped))
        self.navigationItem.rightBarButtonItems = [search]
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc func backBtnTapped() {
        
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
}

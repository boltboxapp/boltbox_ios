//
//  GSSearchViewController.swift
//  Gigs
//
//  Created by Dreamguys on 05/02/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit
import CZPicker

class GSSearchViewController: UIViewController,UITextFieldDelegate,CZPickerViewDelegate, CZPickerViewDataSource {
    
    @IBOutlet weak var myContainerView: UIView!
    @IBOutlet weak var myTxtFldTitle: UITextField!
    @IBOutlet weak var myBtnChooseCategory: UIButton!
    @IBOutlet weak var myBtnSearch: UIButton!
    
    var myArySearchInfo = [[String:Any?]]()
    var myAryCategoryInfo = [[String:String]]()
    
    var myStrCity = String()
    var myStrCityId = String()
    
    var myStrCountry = String()
    var myStrState = String()
    var myStrCategory = String()
    var myStrCountryId = String()
    var myStrStateId = String()
    var myStrCategoryId = String()
    
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
        
        NAVIGAION.setNavigationTitle(aStrTitle: SCREEN_TITLE_SEARCH_GIGS, aViewController: self)
        
        myBtnChooseCategory.setTitle(self.myStrCategory.count==0 ? "Select Category" : self.myStrCategory, for: .normal)

    }
    
    func setUpUI() {
        
        setUpLeftBarButton()
        self.myBtnSearch.backgroundColor = HELPER.hexStringToUIColor(hex: APP_GREEN_COLOR)
        HELPER.setRoundCornerView(aView: self.myBtnSearch, borderRadius: 7.0)
        HELPER.setBorderView(aView: myContainerView, borderWidth: 1, borderColor: UIColor.gray, cornerRadius: 5)
        
        myTxtFldTitle.delegate = self
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
        callCategoryList()
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
    
    //MARK: - CZPickerDelegate Methods
    
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        
        return myAryCategoryInfo.count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        
        return myAryCategoryInfo[row]["name"]
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {
        
        myStrCity = myAryCategoryInfo[row]["name"]!
        myStrCityId = myAryCategoryInfo[row]["cid"]!
    }
    
    // MARK: - Api Call
    //Search
    func callSearch() {
        
        var dictParameters = [String:String]()
        //dictParameters[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
        dictParameters[kDEVICE_TITLE] = myTxtFldTitle.text!
        dictParameters[kDEVICE_STATE] = myStrStateId
        dictParameters[kDEVICE_COUNTRY] = myStrCountryId
        dictParameters[kDEVICE_CATEGORY_iD] = myStrCategoryId
        
        print(dictParameters)
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "Loading..")
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_HOME_SEARCH, dictParameters: dictParameters, sucessBlock: { (response) in
        
//        HTTPMANAGER.getSearchInfo(parameter: dictParameters, sucessblock: {response in
        
            print(response)
            
            HELPER.hideLoadingAnimation()
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                self.myArySearchInfo = response["data"] as! [[String:Any?]]
                
                if self.myArySearchInfo.count > 0 {
                let aViewController = GSViewAllGigsViewController()
                aViewController.gIsSearchGigs = true
                aViewController.myAryInfo = self.myArySearchInfo //Fix issue here
                let aNavi = UINavigationController(rootViewController: aViewController)
                self.present(aNavi, animated: true, completion: nil)
                }
            }
//            else if aIntResponseCode == RESPONSE_CODE_404 {
//
//                HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse, okActionBlock: { (action) in
//
//                    self.navigationController?.popViewController(animated: true)
//                })
//
//            }
            else {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
        }, failureBlock: { error in
            HELPER.hideLoadingAnimation()
            HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    //Category
    func callCategoryList() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingViewAnimation(viewController: self)
        
        HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL+CASE_HOME_VIEWALL_GIGS, sucessBlock: {response in
        
//        HTTPMANAGER.categoryListRequest(sucessblock: {response in
            
            HELPER.hideLoadingAnimation(viewController: self)
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                self.myAryCategoryInfo = response["primary"] as! [[String : Any]] as! [[String : String]]
                
            }
            else {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation(viewController: self)
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    // MARK: - Button Action
    @IBAction func btnSearchTapped(_ sender: Any) {
        
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
            
        }
        if (self.myTxtFldTitle.text?.isEmpty)! && (self.myStrCategoryId.isEmpty) && (self.myStrCountryId.isEmpty) && (self.myStrStateId.isEmpty)  {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_REQUIRED_FIELDS)
        }
        else {
            
            callSearch()
            
           
        }
    }
    
    @IBAction func btnChooseCategoryTapped(_ sender: Any) {
        
        let btn = sender as! UIButton
        if btn.tag == 10 {
           
            let aViewController = GSChooseLocationViewController()
            aViewController.gIsClickCountry = false
            aViewController.gIsClickLanguage = false
            aViewController.gIsClickProfession = false
            aViewController.gIsClickCategory = true
            aViewController.gStrCountryId = self.myStrCountryId
            aViewController.myStrStateId = myStrStateId
            
            aViewController.completion = {(stateName,stateId) in
                
                btn.setTitle(stateName!, for: .normal)
                
                self.myStrCategory = stateName!
                self.myStrCategoryId = stateId!
            }
            
            self.navigationController?.pushViewController(aViewController, animated: true)
        }
        else  if btn.tag == 20 {
            
            let aViewController = GSChooseLocationViewController()
            aViewController.gIsClickCountry = true
            aViewController.gIsClickLanguage = false
            aViewController.gIsClickProfession = false
            aViewController.gIsClickCategory = false
            aViewController.gStrCountryId = myStrCountryId
            
            aViewController.completion = {(countryName,countryId) in
                
                btn.setTitle(countryName!, for: .normal)
                
                self.myStrCountry = countryName!
                self.myStrCountryId = countryId!
                
                self.myStrState = ""
                self.myStrStateId = ""
                let aBtnState = self.view.viewWithTag(30) as! UIButton
                aBtnState.setTitle(self.myStrState.count==0 ? "Choose state" : self.myStrState, for: .normal)
            }
            
            self.navigationController?.pushViewController(aViewController, animated: true)
        }
        else  if btn.tag == 30 {
            
            if self.myStrCountryId.count == 0 {
                
                HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: "Please select country", okActionBlock: { (okAction) in
                    
                })
                return
            }
            
            let aViewController = GSChooseLocationViewController()
            aViewController.gIsClickCountry = false
            aViewController.gIsClickLanguage = false
            aViewController.gIsClickProfession = false
            aViewController.gIsClickCategory = false
            aViewController.gStrCountryId = self.myStrCountryId
            aViewController.myStrStateId = myStrStateId
            
            aViewController.completion = {(stateName,stateId) in
                
                btn.setTitle(stateName!, for: .normal)
                
                self.myStrState = stateName!
                self.myStrStateId = stateId!
            }
            
            self.navigationController?.pushViewController(aViewController, animated: true)
        }
    }
    func setUpLeftBarButton() {
        
        let close = UIBarButtonItem(image: UIImage(named: ICON_CLOSE), style: .plain, target: self, action: #selector(closeBarBtnTapped))
        
        self.navigationItem.leftBarButtonItems = [close]
        navigationController?.navigationBar.tintColor = .white
    }
    @objc func closeBarBtnTapped() {
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

//
//  GSEditProfileViewController.swift
//  Gigs
//
//  Created by Dreamguys on 13/03/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit
import Alamofire
import Photos
import MobileCoreServices
import SDWebImage

class GSEditProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var myTblView: UITableView!
    @IBOutlet var myBtnSubmit: UIButton!
    
    let cellGigImageIdentifier = "GSGigImageTableViewCell"
    let cellTextFieldIdentifier: String = "GSTextFieldTableViewCell"
    let cellTextViewIdentifier: String = "GSTextViewTableViewCell"
    let cellCountryIdentifier: String = "GSCountryTableViewCell"
    
    let TAG_NAME : Int = 10
    let TAG_EMAIL : Int = 20
    let TAG_PHONE_NUMBER : Int = 30
    let TAG_ADDRESS_LINE : Int = 40
    let TAG_CITY : Int = 50
    let TAG_ZIP_CODE : Int = 60
    let TAG_SUGGESTION : Int = 70
    
    let TAG_IMG_VIEW : Int = 100
    
    let TAG_COUNTRY_BUTTON : Int = 2000
    let TAG_STATE_BUTTON : Int = 3000
    let TAG_LANGUAGE_BUTTON : Int = 4000
    let TAG_PROFESSION_BUTTON : Int = 5000

    var myStrName = String()
    var myStrPhoneNumber = String()
    var myStrAddressLine = String()
    var myStrCity = String()
    var myStrZipCode = String()
    var myStrSuggestion = String()
    
    var myStrLanguage = String()
    var myStrProfession = String()

    var myStrCountry = String()
    var myStrState = String()
    var myStrCountryId = String()
    var myStrStateId = String()
    var myStrProfessionId = String()
    var myStrLanguageId = String()
    
    var myStrProfilePic = String()

    var imageUrl: URL!
    var myImage: UIImage!
    
    var isBoolCamera = Bool()
    var isClickImage: Bool = false
    
    var myFileName = String()
    var myDataFile = Data()
    
    var myAryInfo = [[String:Any?]]()
    var myDictnfo = [String:Any?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpModel()
        loadModel()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        
        let indexpath = IndexPath(row: 0, section: 0)
        if let cell:GSTextViewTableViewCell = self.myTblView.cellForRow(at: indexpath) as? GSTextViewTableViewCell  {
            cell.gTxtView.textColor =  cell.gTxtView.text.count > 0 ? UIColor.black : UIColor.lightGray
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI() {
        
        NAVIGAION.setNavigationTitle(aStrTitle: SCREEN_TITLE_EDIT_PROFILE, aViewController: self)
        setUpLeftBarBackButton()
        
        myTblView.delegate = self
        myTblView.dataSource = self
        
        self.myBtnSubmit.backgroundColor = HELPER.hexStringToUIColor(hex: APP_GREEN_COLOR)
        //HELPER.setRoundCornerView(aView: self.myBtnSubmit, borderRadius: 7.0)
        
        myTblView.register(UINib.init(nibName: cellGigImageIdentifier, bundle: nil), forCellReuseIdentifier: cellGigImageIdentifier)
        myTblView.register(UINib.init(nibName: cellTextFieldIdentifier, bundle: nil), forCellReuseIdentifier: cellTextFieldIdentifier)
        myTblView.register(UINib.init(nibName: cellTextViewIdentifier, bundle: nil), forCellReuseIdentifier: cellTextViewIdentifier)
        myTblView.register(UINib.init(nibName: cellCountryIdentifier, bundle: nil), forCellReuseIdentifier: cellCountryIdentifier)
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
        getUserProfile()
    }
    
    //MARK: - Tableview delegate and datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 12
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.row == 0) {
            
            return 170
        }
        
        else if indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 10 {
            
            return 90
        }
            
        else if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 8 || indexPath.row == 9 {
            
            return 90
        }
        
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellGigImageIdentifier, for: indexPath) as! GSGigImageTableViewCell
            
            HELPER.setRoundCornerView(aView: aCell.gImgView)
            HELPER.setRoundCornerView(aView: aCell.gContainerView)
            
            aCell.gImgView.tag = TAG_IMG_VIEW
            
            aCell.gImgView.setShowActivityIndicator(true)
            aCell.gImgView.setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
            aCell.gImgView.sd_setImage(with: URL(string: (WEB_BASE_URL + myStrProfilePic)), placeholderImage: UIImage(named: "icon_profile_placeholder"))

            aCell.gBtnImage.addTarget(self, action: #selector(imageBtnTapped), for: .touchUpInside)
            
            return aCell
        }
        
        if indexPath.row == 1 { //Name
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellTextFieldIdentifier, for: indexPath) as! GSTextFieldTableViewCell
            
            aCell.gTxtFldRegister.tag = TAG_NAME
            aCell.gTxtFldRegister.placeholder = REG_NAME
            
            aCell.gLblName.text = REG_NAME
            HELPER.setBorderView(aView: aCell.gContainerView, borderWidth: 0.5, borderColor: UIColor.lightGray, cornerRadius: 3.0)
            
            aCell.gTxtFldRegister.text = myStrName //myDictnfo["fullname"] as? String ?? ""
            aCell.gTxtFldRegister.returnKeyType = UIReturnKeyType.next
            aCell.gTxtFldRegister.keyboardType = UIKeyboardType.alphabet
            aCell.gTxtFldRegister.isUserInteractionEnabled = true
            aCell.gTxtFldRegister.delegate = self
            
            return aCell
        }
            
        if indexPath.row == 2 { //Email
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellTextFieldIdentifier, for: indexPath) as! GSTextFieldTableViewCell
            
            aCell.gTxtFldRegister.tag = TAG_EMAIL
            aCell.gTxtFldRegister.placeholder = REG_EMAIL
            
            aCell.gLblName.text = REG_EMAIL
            HELPER.setBorderView(aView: aCell.gContainerView, borderWidth: 0.5, borderColor: UIColor.lightGray, cornerRadius: 3.0)
            
            aCell.gTxtFldRegister.text = myDictnfo["email"] as? String ?? ""
            aCell.gTxtFldRegister.returnKeyType = UIReturnKeyType.next
            aCell.gTxtFldRegister.keyboardType = UIKeyboardType.emailAddress
            aCell.gTxtFldRegister.isUserInteractionEnabled = false
            aCell.gTxtFldRegister.delegate = self
            
            return aCell
        }
            
        else if indexPath.row == 3 { //Phone number
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellTextFieldIdentifier, for: indexPath) as! GSTextFieldTableViewCell
            aCell.gTxtFldRegister.tag = TAG_PHONE_NUMBER
            aCell.gTxtFldRegister.placeholder = REG_MOBILE
            
            aCell.gLblName.text = REG_MOBILE
            HELPER.setBorderView(aView: aCell.gContainerView, borderWidth: 0.5, borderColor: UIColor.lightGray, cornerRadius: 3.0)
            
            aCell.gTxtFldRegister.text = myStrPhoneNumber //myDictnfo["contact"] as? String ?? ""
            aCell.gTxtFldRegister.returnKeyType = UIReturnKeyType.next
            aCell.gTxtFldRegister.keyboardType = UIKeyboardType.numberPad
            aCell.gTxtFldRegister.isUserInteractionEnabled = true
            aCell.gTxtFldRegister.delegate = self
            return aCell
        }
            
        else if indexPath.row == 4 { //Address line
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellTextViewIdentifier, for: indexPath) as! GSTextViewTableViewCell
            aCell.gTxtView.tag = TAG_ADDRESS_LINE
            
            aCell.gLblName.text = REG_ADDRESS_LINE
            HELPER.setBorderView(aView: aCell.gContainerView, borderWidth: 0.3, borderColor: UIColor.lightGray, cornerRadius: 3.0)
            
            let addressTxt:String = myStrAddressLine //myDictnfo["address"] as? String ?? ""
            aCell.gTxtView.text = addressTxt.count > 0 ? addressTxt : "Address Line"

             aCell.gTxtView.returnKeyType = UIReturnKeyType.next
            aCell.gTxtView.keyboardType = UIKeyboardType.alphabet
            aCell.gTxtView.isUserInteractionEnabled = true
            aCell.gTxtView.textColor =  UIColor.black
            if aCell.gTxtView.text == "Address Line" {
                aCell.gTxtView.textColor = UIColor.lightGray
            }
            aCell.gTxtView.delegate = self
            return aCell
        }
            
        else if indexPath.row == 5 { //Select Language
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellCountryIdentifier, for: indexPath) as! GSCountryTableViewCell
            
            aCell.gLblCountry.text = REG_LANGUAGE
            HELPER.setBorderView(aView: aCell.gContainerView, borderWidth: 0.3, borderColor: UIColor.lightGray, cornerRadius: 3.0)
            aCell.gBtnCity.setTitle(REG_LANGUAGE, for: UIControlState.normal)
            aCell.gBtnCity.removeTarget(self, action: nil, for: .allEvents)
            aCell.gBtnCity.addTarget(self, action: #selector(languageBtnTapped), for: .touchUpInside)
            aCell.gBtnCity.tag = TAG_LANGUAGE_BUTTON
            let lang:String = myDictnfo["lang_speaks"] as? String ?? ""
            
            if lang == "" {
                aCell.gBtnCity.setTitle("Choose language", for: .normal)
            }
            else {
                aCell.gBtnCity.setTitle(self.myStrLanguage.count==0 ? lang : self.myStrLanguage, for: .normal)
            }
            
            return aCell
        }
            
        else if indexPath.row == 6 { //Select Country
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellCountryIdentifier, for: indexPath) as! GSCountryTableViewCell
            
            aCell.gLblCountry.text = REG_COUNTRY
            aCell.gBtnCity.removeTarget(self, action: nil, for: .allEvents)
            aCell.gBtnCity.addTarget(self, action: #selector(countryBtnTapped), for: .touchUpInside)
            HELPER.setBorderView(aView: aCell.gContainerView, borderWidth: 0.3, borderColor: UIColor.lightGray, cornerRadius: 3.0)

            aCell.gBtnCity.tag = TAG_COUNTRY_BUTTON
            myStrCountry = myDictnfo["country_name"] as? String ?? ""
            
            if myStrCountry == "" {
                aCell.gBtnCity.setTitle("Choose country", for: .normal)
            }
            else {
                aCell.gBtnCity.setTitle(self.myStrCountry.count==0 ? "Choose country" : self.myStrCountry, for: .normal)
            }
            
            //aCell.gBtnCity.setTitle(self.myStrCountry.count==0 ? country : self.myStrCountry, for: .normal)
            
            return aCell
        }
            
        else if indexPath.row == 7 { //Select State
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellCountryIdentifier, for: indexPath) as! GSCountryTableViewCell
            
            aCell.gLblCountry.text = REG_STATE
            HELPER.setBorderView(aView: aCell.gContainerView, borderWidth: 0.3, borderColor: UIColor.lightGray, cornerRadius: 3.0)

            aCell.gBtnCity.setTitle(REG_STATE, for: UIControlState.normal)
            aCell.gBtnCity.removeTarget(self, action: nil, for: .allEvents)
            aCell.gBtnCity.addTarget(self, action: #selector(stateBtnTapped), for: .touchUpInside)
            
            aCell.gBtnCity.tag = TAG_STATE_BUTTON
            
            if myStrState == "" {
                aCell.gBtnCity.setTitle("Choose state", for: .normal)
            }
            else {
                aCell.gBtnCity.setTitle(self.myStrState.count==0 ? "Choose state" : self.myStrState, for: .normal)
            }
            return aCell
        }
            
        else if indexPath.row == 8 { //City
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellTextFieldIdentifier, for: indexPath) as! GSTextFieldTableViewCell
            aCell.gTxtFldRegister.tag = TAG_CITY
            aCell.gTxtFldRegister.placeholder = REG_CITY
            
            aCell.gLblName.text = REG_CITY
            HELPER.setBorderView(aView: aCell.gContainerView, borderWidth: 0.5, borderColor: UIColor.lightGray, cornerRadius: 3.0)
            
            aCell.gTxtFldRegister.text = myStrCity//myDictnfo["city"] as? String ?? ""
            aCell.gTxtFldRegister.returnKeyType = UIReturnKeyType.next
            aCell.gTxtFldRegister.keyboardType = UIKeyboardType.alphabet
            aCell.gTxtFldRegister.isUserInteractionEnabled = true
            aCell.gTxtFldRegister.delegate = self
            return aCell
        }
            
        else if indexPath.row == 9 { //ZipCode
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellTextFieldIdentifier, for: indexPath) as! GSTextFieldTableViewCell
            aCell.gTxtFldRegister.tag = TAG_ZIP_CODE
            aCell.gTxtFldRegister.placeholder = REG_ZIPCODE

            aCell.gLblName.text = REG_ZIPCODE
            HELPER.setBorderView(aView: aCell.gContainerView, borderWidth: 0.5, borderColor: UIColor.lightGray, cornerRadius: 3.0)
            
            aCell.gTxtFldRegister.text = myDictnfo["zipcode"] as? String ?? ""
            aCell.gTxtFldRegister.returnKeyType = UIReturnKeyType.next
            aCell.gTxtFldRegister.keyboardType = UIKeyboardType.numberPad
            aCell.gTxtFldRegister.isUserInteractionEnabled = true
            aCell.gTxtFldRegister.delegate = self
            return aCell
        }
            
        else if indexPath.row == 10 { //Select profession
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellCountryIdentifier, for: indexPath) as! GSCountryTableViewCell
            
            aCell.gLblCountry.text = REG_PROFESSION
            HELPER.setBorderView(aView: aCell.gContainerView, borderWidth: 0.3, borderColor: UIColor.lightGray, cornerRadius: 3.0)
            aCell.gBtnCity.setTitle(REG_PROFESSION, for: UIControlState.normal)
            aCell.gBtnCity.removeTarget(self, action: nil, for: .allEvents)
            aCell.gBtnCity.addTarget(self, action: #selector(professionBtnTapped), for: .touchUpInside)
            aCell.gBtnCity.tag = TAG_PROFESSION_BUTTON
            
            if myStrProfession == "" {
                aCell.gBtnCity.setTitle("Choose profession", for: .normal)
            }
            else {
                aCell.gBtnCity.setTitle(self.myStrProfession.count==0 ? "Choose profession" : self.myStrProfession, for: .normal)
            }
            return aCell
        }
            
        else { //Suggestion
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellTextViewIdentifier, for: indexPath) as! GSTextViewTableViewCell
            aCell.gTxtView.tag = TAG_SUGGESTION
            
            aCell.gLblName.text = REG_SUGGESTION
            HELPER.setBorderView(aView: aCell.gContainerView, borderWidth: 0.5, borderColor: UIColor.lightGray, cornerRadius: 3.0)
            
            let addressTxt:String = myStrSuggestion//myDictnfo["description"] as? String ?? ""
            aCell.gTxtView.text = addressTxt.count > 0 ? addressTxt : "Suggestion about you"
            
            aCell.gTxtView.textColor =  UIColor.black
            if aCell.gTxtView.text == "Suggestion about you" {
                aCell.gTxtView.textColor = UIColor.lightGray
            }
            aCell.gTxtView.returnKeyType = UIReturnKeyType.done
            aCell.gTxtView.keyboardType = UIKeyboardType.alphabet
            aCell.gTxtView.isUserInteractionEnabled = true
            aCell.gTxtView.delegate = self
            return aCell
        }
    }
    
    //MARK: - Textfield Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
        if textField.tag == TAG_NAME {
            
            do {
                let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
                
                if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
                    
                    return false
                    
                } else {
                    
                    myStrName = txtAfterUpdate
                    return true
                }
            }
            catch {
                
            }
        }
            
        else if textField.tag == TAG_PHONE_NUMBER {
            
            if txtAfterUpdate.count <= 15 {
                
                myStrPhoneNumber = txtAfterUpdate
                
                return true
            }
                
            else {
                
                return false
            }
        }
            
        else if textField.tag == TAG_CITY {
            
            myStrCity = txtAfterUpdate
        }
            
        else if textField.tag == TAG_ZIP_CODE {
            
            myStrZipCode = txtAfterUpdate
        }
        
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.returnKeyType == UIReturnKeyType.next {
            
            self.myTblView.viewWithTag(textField.tag + 10)?.becomeFirstResponder()
        }
            
        else {
            
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    //MARK: - TextView Delegate
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.tag == TAG_ADDRESS_LINE {
            
            if textView.textColor == UIColor.lightGray {
                textView.text = ""
                textView.textColor = UIColor.black
            }
        }
        else if textView.tag == TAG_SUGGESTION {
            
            if textView.textColor == UIColor.lightGray {
                textView.text = ""
                textView.textColor = UIColor.black
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.tag == TAG_ADDRESS_LINE {
            
            if textView.text == "" {
                
                textView.text = "Address Line"
                textView.textColor = UIColor.lightGray
            }
        }
        else if textView.tag == TAG_SUGGESTION {
            
            if textView.text == "" {
                
                textView.text = "Suggestion about you"
                textView.textColor = UIColor.lightGray
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let textViewText: NSString = (textView.text ?? "") as NSString
        let txtAfterUpdate = textViewText.replacingCharacters(in: range, with: text)
        
        if textView.tag == TAG_ADDRESS_LINE {
            
            myStrAddressLine = txtAfterUpdate
        }
            
        else if textView.tag == TAG_SUGGESTION {
            
            myStrSuggestion = txtAfterUpdate
        }
        
        return true
    }
    
    //MARK:- Imagae picker Delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if let data = UIImageJPEGRepresentation(image, 0.1) {
            
            myDataFile = data
        }
        
         let aImgViewProfile = self.myTblView.viewWithTag(TAG_IMG_VIEW) as! UIImageView
        aImgViewProfile.image = image
        
//        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//        let aImgViewProfile = self.myTblView.viewWithTag(TAG_IMG_VIEW) as! UIImageView
//        aImgViewProfile.image = image
//
//        let image_data = info[UIImagePickerControllerOriginalImage] as? UIImage
//        myDataFile = (UIImageJPEGRepresentation(image_data!, 0.5))!
//
//        if (isClickImage) {
//
//            if #available(iOS 11.0, *) {
//                if let imageURL = info[UIImagePickerControllerImageURL] as? URL {
//                    imageUrl1 = imageURL
//                }
//            } else {
//
//
//                if let asset = PHAsset.fetchAssets(withALAssetURLs: [info[UIImagePickerControllerReferenceURL] as! URL], options: nil).firstObject {
//
//                    PHImageManager.default().requestImageData(for: asset, options: nil, resultHandler: { _, _, _, info in
//
//                        if let fileName = (info?["PHImageFileURLKey"] as? NSURL) {
//
//                            self.imageUrl = fileName as URL?
//                        }
//                    })
//                }
//            }
//
//            isClickImage = false
//        }
//        else {
//
//
//            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//
//            let aImgViewProfile = self.myTblView.viewWithTag(TAG_IMG_VIEW) as! UIImageView
//            aImgViewProfile.image = image
//
//            checkCheckPathNameIsOrNot()
//
//            let aStrPathName = "capture.png"
//
//            let docsurl = try! FileManager.default.url(for:.cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//
//            imageUrl1 = (docsurl.appendingPathComponent(aStrPathName) as NSURL) as URL?
//
//            if let data = UIImagePNGRepresentation(image) {
//
//                try? data.write(to: imageUrl1 as URL)
//            }
//            dismiss(animated:true, completion: nil)
//        }
        
        dismiss(animated:true, completion: nil)
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//
//        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//        let aImgViewProfile = self.myTblView.viewWithTag(TAG_IMG_VIEW) as! UIImageView
//        aImgViewProfile.image = image
//
//        let image_data = info[UIImagePickerControllerOriginalImage] as? UIImage
//        myDataFile = (UIImageJPEGRepresentation(image_data!, 0.5))!
//
//        if (isClickImage) {
//
//            isClickImage = false
//
//            if let asset = PHAsset.fetchAssets(withALAssetURLs: [info[UIImagePickerControllerReferenceURL] as! URL], options: nil).firstObject {
//
//                PHImageManager.default().requestImageData(for: asset, options: nil, resultHandler: { _, _, _, info in
//
//                    if let fileName = (info?["PHImageFileURLKey"] as? NSURL)?.lastPathComponent {
//
//                        self.myFileName = fileName
//                    }
//                })
//            }
//        }
//
//        else {
//
//            if let data = UIImageJPEGRepresentation(image, 0.8) {
//
//                let filename = getDocumentsDirectory().appendingPathComponent("imagetest.png")
//
//                imageUrl =  getDocumentsDirectory().appendingPathComponent("imagetest.png") as URL
//
//                self.myFileName = "imagetest.png"
//
//                try? data.write(to: filename)
//            }
//        }
//        dismiss(animated:true, completion: nil)
//    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        isClickImage = false
        dismiss(animated:true, completion: nil)
    }
    
    //MARK: - Button Action
    @IBAction func btnSubmitTapped(_ sender: Any) {
        
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        if (self.myStrName.isEmpty)  {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_USER_NAME)
        }
//        else if (self.myStrPhoneNumber.isEmpty) {
//            
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_MOBILE_NO, aStrMessage: ALERT_EMPTY_FIELD)
//        }
//        else if (self.myStrAddressLine.isEmpty) {
//            
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_ADDRESS_LINE, aStrMessage: ALERT_EMPTY_FIELD)
//        }
        else if (self.myStrLanguage.isEmpty) {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_LANGUAGE, aStrMessage: ALERT_EMPTY_FIELD)
        }
        else if (self.myStrCountryId.isEmpty) ||  (self.myStrCountryId == "0") {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_COUNTRY, aStrMessage: ALERT_EMPTY_FIELD)
        }
        else if (self.myStrStateId.isEmpty) {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_STATE, aStrMessage: ALERT_EMPTY_FIELD)
        }
//        else if (self.myStrCity.isEmpty) {
//            
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_CITY, aStrMessage: ALERT_EMPTY_FIELD)
//        }
//        else if (self.myStrZipCode.isEmpty) {
//            
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_ZIP_CODE, aStrMessage: ALERT_EMPTY_FIELD)
//        }
//        else if (self.myStrProfessionId.isEmpty) ||  (self.myStrProfessionId == "0") {
//            
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_PROFESSION, aStrMessage: ALERT_EMPTY_FIELD)
//        }
//        else if (self.myStrSuggestion.isEmpty) {
//            
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_SUGGESTION, aStrMessage: ALERT_EMPTY_FIELD)
//        }
        else {
            
            httpRequestForRegister()
        }
    }
    
    // MARK:- Api Request
    
    func httpRequestForRegister() {
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "Updating..")

        let dictRegisteration = ["user_contact":myStrPhoneNumber,"user_zip":myStrZipCode,"user_city":myStrCity,"user_addr":myStrAddressLine,"user_desc":myStrSuggestion,"country_id":myStrCountryId,"state_id":myStrStateId,"profession":myStrProfessionId,"user_name":myStrName,"language_tags":self.myStrLanguage] as [String : Any]
        
//        "user_id":SESSION.getUserId(),
        
        print(dictRegisteration)
        
        let headers = ["Content-Type" : "application/json; charset=utf-8","token":  SESSION.getUserId()]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if self.myDataFile != nil {
                
                multipartFormData.append(self.myDataFile, withName: "profile_img", fileName: "iosimg.jpg", mimeType: "image/jpg")
            }
            
//            if imageUrl1 != nil {
//
////                multipartFormData.append(self.myDataFile, withName: "profile_img", fileName: self.myFileName, mimeType: "image/png")
//                multipartFormData.append(imageUrl1, withName: "profile_img")
//
//            }
            
            for (key, value) in dictRegisteration {
                
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        },
            
        usingThreshold: UInt64.init(), to: WEB_SERVICE_URL + CASE_UPDATE_PROFILE, method: .post, headers: headers) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    print(progress)
                })
                
                upload.responseJSON { response in
                    
                    let jsonDict = response.result.value as? [String:Any]
                    
                    //print(jsonDict!)
                    
                    let aIntResponseCode = jsonDict!["code"] as! Int
                    let aMessageResponse = jsonDict!["message"] as! String
                    
                    if aIntResponseCode == RESPONSE_CODE_200 {
                        
//                        NotificationCenter.default.post(name: Notification.Name("callUpdateProfile"), object: nil)
                        HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse, okActionBlock: { (Action) in
                            
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                        
                    else {
                        
                        HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
                    }
                    
                    HELPER.hideLoadingAnimation()
                }
                
            case .failure(let encodingError):
                print (encodingError.localizedDescription)
                HELPER.hideLoadingAnimation()
            }
        }
    }
    
    func getUserProfile() {
        
        var dictParameters = [String:String]()
        dictParameters[kUSER_ID] = SESSION.getUserId()
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "Loading..")
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_VIEW_USER_PROFILE, dictParameters: dictParameters, sucessBlock: { (response) in
        
//        HTTPMANAGER.userProfileRequest(parameter: dictParameters, sucessblock: {response in
            
            HELPER.hideLoadingAnimation()
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                self.myAryInfo = response["data"] as! [[String:Any?]]
                self.myDictnfo = self.myAryInfo[0]
                
                self.myStrProfilePic = self.myDictnfo["user_profile_image"] as? String ?? ""
                SESSION.setUserImage(aStrUserImage: self.myStrProfilePic)

                self.myStrState = self.myDictnfo["state_name"] as? String ?? ""
                self.myStrCountryId = self.myDictnfo["country"] as? String ?? ""
                self.myStrStateId = self.myDictnfo["state_id"] as? String ?? ""
                
                self.myStrPhoneNumber = self.myDictnfo["contact"] as? String ?? ""
                self.myStrAddressLine = self.myDictnfo["address"] as? String ?? ""
                self.myStrName = self.myDictnfo["fullname"] as? String ?? ""
                self.myStrZipCode = self.myDictnfo["zipcode"] as? String ?? ""
                self.myStrCity = self.myDictnfo["city"] as? String ?? ""
                self.myStrProfession = self.myDictnfo["profession_name"] as? String ?? ""
                self.myStrProfessionId = self.myDictnfo["profession"] as? String ?? ""
                self.myStrSuggestion = self.myDictnfo["description"] as? String ?? ""
                
                self.myStrLanguage = self.myDictnfo["lang_speaks"] as? String ?? ""
                //self.myStrLanguage = self.myDictnfo["lang_speaks"]!
                
                self.myTblView.reloadData()
            }
            else {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    //MARK: - Private Functions
    
    @objc func imageBtnTapped(sender: UIButton) {
        
        isClickImage = true
        let aActionSheetController: UIAlertController = UIAlertController(title: "Choose a photo via", message: nil, preferredStyle: .actionSheet)
        
        let aActionCancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { void in
            print("Cancel")
        }
        aActionSheetController.addAction(aActionCancel)
        
        
        let aActionCamera: UIAlertAction = UIAlertAction(title: "Camera", style: .default)
        { void in
            
            self.loadCamera()
        }
        aActionSheetController.addAction(aActionCamera)
        
        
        let aActionGallery: UIAlertAction = UIAlertAction(title: "Gallery", style: .default)
        { void in
            
            self.loadGallery()
        }
        aActionSheetController.addAction(aActionGallery)
        
        self.present(aActionSheetController, animated: true, completion: nil)
    }
    
    func loadGallery() {
        
        isClickImage = true

        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.navigationBar.barTintColor = HELPER.hexStringToUIColor(hex: APP_COLOR)
        picker.navigationBar.tintColor = .white
        //        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.mediaTypes = ([(kUTTypeImage as? String)] as? [String])!
        self.present(picker, animated: true, completion: nil)
    }
    
    func loadCamera() {
        
        isClickImage = false
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        // picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
        self.present(picker, animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func checkCheckPathNameIsOrNot() {
        
        let fileManager = FileManager.default
        let documentsUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as NSURL
        let documentsPath = documentsUrl.path
        
        do {
            
            if let documentPath = documentsPath
            {
                let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                
                print("all files in cache: \(fileNames)")
                
                for fileName in fileNames {
                    
                    if (fileName.hasSuffix("capture.png"))
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
    
    @objc func countryBtnTapped(sender: UIButton) {
        
        let aViewController = GSChooseLocationViewController()
        aViewController.gIsClickCountry = true
        aViewController.gIsClickLanguage = false
        aViewController.gIsClickProfession = false
        aViewController.gIsClickCategory = false
        aViewController.gStrCountryId = myStrCountryId
        
        aViewController.completion = {(countryName,countryId) in
            
            let aBtnCountry = self.myTblView.viewWithTag(self.TAG_COUNTRY_BUTTON) as! UIButton
            
            aBtnCountry.setTitle(countryName!, for: .normal)
            
            self.myStrCountry = countryName!
            self.myStrCountryId = countryId!
            
            self.myStrState = ""
            self.myStrStateId = ""
            let aBtnState = self.myTblView.viewWithTag(self.TAG_STATE_BUTTON) as! UIButton
            aBtnState.setTitle(self.myStrState.count==0 ? "Choose state" : self.myStrState, for: .normal)
        }
        
        self.navigationController?.pushViewController(aViewController, animated: true)
    }
    
    @objc func stateBtnTapped(sender: UIButton) {
        
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
            
            let aBtnState = self.myTblView.viewWithTag(self.TAG_STATE_BUTTON) as! UIButton
            aBtnState.setTitle(stateName!, for: .normal)
            
            self.myStrState = stateName!
            self.myStrStateId = stateId!
        }
        
        self.navigationController?.pushViewController(aViewController, animated: true)
    }
    
    @objc func languageBtnTapped(sender: UIButton) {
        
//        if self.myStrLanguage.count == 0 {
//
//            HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: "Please select language", okActionBlock: { (okAction) in
//
//            })
//
//            return
//        }
        
        let aViewController = GSChooseLocationViewController()
        aViewController.gIsClickCountry = false
        aViewController.gIsClickLanguage = true
        aViewController.gIsClickProfession = false
        aViewController.gIsClickCategory = false
        aViewController.gStrCountryId = self.myStrLanguage
        //aViewController.myStrStateId = myStrStateId
        
        aViewController.completion = {(languageName,stateId) in

            let aBtnState = self.myTblView.viewWithTag(self.TAG_LANGUAGE_BUTTON) as! UIButton
            if let langName = languageName {
            aBtnState.setTitle(langName, for: .normal)
                self.myStrLanguage = languageName!
                aViewController.gStrCountryId = self.myStrLanguage
                self.myStrLanguageId = stateId!
            }
            
        }
        
        self.navigationController?.pushViewController(aViewController, animated: true)
    }
    
    @objc func professionBtnTapped(sender: UIButton) {
        
//        if self.myStrProfession.count == 0 {
//
//            HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: "Please select language", okActionBlock: { (okAction) in
//
//            })
//
//            return
//        }

        let aViewController = GSChooseLocationViewController()
        aViewController.gIsClickCountry = false
        aViewController.gIsClickLanguage = false
        aViewController.gIsClickProfession = true
        aViewController.gIsClickCategory = false

        aViewController.completion = {(professionName,professionId) in
            
            let aBtnState = self.myTblView.viewWithTag(self.TAG_PROFESSION_BUTTON) as! UIButton
            aBtnState.setTitle(professionName, for: .normal)
            
            self.myStrProfession = professionName!
            self.myStrProfessionId = professionId!

        }
        
        self.navigationController?.pushViewController(aViewController, animated: true)
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

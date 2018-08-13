//
//  GSRegisterViewController.swift
//  Gigs
//
//  Created by dreams on 03/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos
import Alamofire

class GSRegisterViewController: UIViewController,UITableViewDelegate,UITextFieldDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate {

    @IBOutlet var imgviewTemp: UIImageView!
    @IBOutlet weak var myTblViewRegister: UITableView!
    @IBOutlet weak var myBtnRegister: UIButton!
    @IBOutlet weak var myBtnRegLogin: UIButton!
    @IBOutlet weak var myBtnTrmsandCnd: UIButton!
    
    let cellProfileIdentifier: String = "GSGigImageTableViewCell"
    let cellTextFieldIdentifier: String = "GSTextFieldTableViewCell"
    let cellCountryIdentifier: String = "GSCountryTableViewCell"
    
    var imageUrl: URL!
    var myImage: UIImage!
    
    var isClickImage: Bool!
    var isAgreeTerms: Bool!
    
    let TAG_PROFILE_IMAGE_VIEW : Int = 1000
    let TAG_NAME : Int = 10
    let TAG_EMAIL : Int = 20
    let TAG_USER_NAME : Int = 30
    let TAG_PASSWORD : Int = 40
    let TAG_REPEAT_PASSWORD : Int = 50
    
    let TAG_COUNTRY_BUTTON : Int = 2000
    let TAG_STATE_BUTTON : Int = 3000

    var myStrName = String()
    var myStrEmail = String()
    var myStrUsername = String()
    var myStrPassword = String()
    var myStrRepeatPassword = String()
    var myStrCountry = String()
    var myStrState = String()
    var myStrCountryId = String()
    var myStrStateId = String()
    
    var myFileName = String()
    var myDataFile = Data()
    
    var myDictTermsInfo = [String:String]()
    
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
        
        NAVIGAION.setNavigationTitle(aStrTitle: SCREEN_TITLE_REGISTER, aViewController: self)
        
        setUpLeftBarBackButton()
        self.myBtnRegister.backgroundColor = HELPER.hexStringToUIColor(hex: APP_GREEN_COLOR)
        HELPER.setRoundCornerView(aView: self.myBtnRegister, borderRadius: 7.0)
        
        myTblViewRegister.delegate = self
        myTblViewRegister.dataSource = self
        
        myBtnRegister.isUserInteractionEnabled = false
        myBtnRegister.backgroundColor = UIColor.lightGray
        
        myTblViewRegister.register(UINib.init(nibName: cellProfileIdentifier, bundle: nil), forCellReuseIdentifier: cellProfileIdentifier)
        myTblViewRegister.register(UINib.init(nibName: cellTextFieldIdentifier, bundle: nil), forCellReuseIdentifier: cellTextFieldIdentifier)
        myTblViewRegister.register(UINib.init(nibName: cellCountryIdentifier, bundle: nil), forCellReuseIdentifier: cellCountryIdentifier)
    }
    
    func setUpModel() {
        
        isAgreeTerms = false
    }
    
    func loadModel() {
        
    }

    //MARK: - Table view delegate and datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            return 170
        }
            
        else if indexPath.row == 6 {
            
            return 95
        }
            
        else if indexPath.row == 7 {
            
            return 95
        }
            
        else {
            
            return 85
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellProfileIdentifier, for: indexPath) as! GSGigImageTableViewCell
            
            
            aCell.gImgView.tag = TAG_PROFILE_IMAGE_VIEW
            
            aCell.gImgView.setShowActivityIndicator(true)
            aCell.gImgView.setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
            aCell.gBtnImage.addTarget(self, action: #selector(profileBtnTapped), for: .touchUpInside)
            HELPER.setRoundCornerView(aView: aCell.gImgView, borderRadius: aCell.gImgView.frame.size.height / 2)
            HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: aCell.gContainerView.frame.size.height / 2)

            return aCell
        }
            
        else if (indexPath.row == 1) {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellTextFieldIdentifier, for: indexPath) as! GSTextFieldTableViewCell
            aCell.gTxtFldRegister.tag = TAG_NAME
            aCell.gTxtFldRegister.placeholder = REG_NAME
            aCell.gLblName.text = REG_NAME
            HELPER.setBorderView(aView: aCell.gContainerView, borderWidth: 0.5, borderColor: UIColor.lightGray, cornerRadius: 3.0)
            aCell.gTxtFldRegister.text = myStrName
            aCell.gTxtFldRegister.returnKeyType = UIReturnKeyType.next
            aCell.gTxtFldRegister.keyboardType = UIKeyboardType.alphabet
            aCell.gTxtFldRegister.delegate = self
            return aCell
        }
            
        else if (indexPath.row == 2) {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellTextFieldIdentifier, for: indexPath) as! GSTextFieldTableViewCell
            aCell.gTxtFldRegister.tag = TAG_EMAIL
            aCell.gTxtFldRegister.placeholder = REG_EMAIL
            aCell.gLblName.text = REG_EMAIL
            HELPER.setBorderView(aView: aCell.gContainerView, borderWidth: 0.5, borderColor: UIColor.lightGray, cornerRadius: 3.0)
            aCell.gTxtFldRegister.text = myStrEmail
            aCell.gTxtFldRegister.returnKeyType = UIReturnKeyType.next
            aCell.gTxtFldRegister.keyboardType = UIKeyboardType.emailAddress
            aCell.gTxtFldRegister.delegate = self
            return aCell
        }
            
        else if (indexPath.row == 3) {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellTextFieldIdentifier, for: indexPath) as! GSTextFieldTableViewCell
            aCell.gTxtFldRegister.tag = TAG_USER_NAME
            aCell.gTxtFldRegister.placeholder = REG_USER_NAME
            aCell.gLblName.text = REG_USER_NAME
            HELPER.setBorderView(aView: aCell.gContainerView, borderWidth: 0.5, borderColor: UIColor.lightGray, cornerRadius: 3.0)
            aCell.gTxtFldRegister.text = myStrUsername
            aCell.gTxtFldRegister.returnKeyType = UIReturnKeyType.next
            aCell.gTxtFldRegister.keyboardType = UIKeyboardType.alphabet
            aCell.gTxtFldRegister.delegate = self
            return aCell
        }
            
        else if (indexPath.row == 4) {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellTextFieldIdentifier, for: indexPath) as! GSTextFieldTableViewCell
            aCell.gTxtFldRegister.tag = TAG_PASSWORD
            aCell.gTxtFldRegister.placeholder = REG_PASSWORD
            aCell.gLblName.text = REG_PASSWORD
            HELPER.setBorderView(aView: aCell.gContainerView, borderWidth: 0.5, borderColor: UIColor.lightGray, cornerRadius: 3.0)
            aCell.gTxtFldRegister.text = myStrPassword
            aCell.gTxtFldRegister.isSecureTextEntry = true
            aCell.gTxtFldRegister.returnKeyType = UIReturnKeyType.next
            aCell.gTxtFldRegister.keyboardType = UIKeyboardType.alphabet
            aCell.gTxtFldRegister.delegate = self
            return aCell
        }
            
        else if (indexPath.row == 5) {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellTextFieldIdentifier, for: indexPath) as! GSTextFieldTableViewCell
            aCell.gTxtFldRegister.tag = TAG_REPEAT_PASSWORD
            aCell.gTxtFldRegister.placeholder = REG_REPEAT_PASSWORD
            aCell.gLblName.text = REG_REPEAT_PASSWORD
            HELPER.setBorderView(aView: aCell.gContainerView, borderWidth: 0.5, borderColor: UIColor.lightGray, cornerRadius: 3.0)
            aCell.gTxtFldRegister.text = myStrRepeatPassword
            aCell.gTxtFldRegister.isSecureTextEntry = true
            aCell.gTxtFldRegister.returnKeyType = UIReturnKeyType.done
            aCell.gTxtFldRegister.keyboardType = UIKeyboardType.alphabet
            aCell.gTxtFldRegister.delegate = self
            return aCell
        }
            
        else if (indexPath.row == 6) {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellCountryIdentifier, for: indexPath) as! GSCountryTableViewCell
            aCell.gBtnCity.tag = TAG_COUNTRY_BUTTON
            aCell.gLblCountry.text = REG_COUNTRY
            aCell.gContainerView.tag = 7777
            HELPER.setBorderView(aView: aCell.gContainerView, borderWidth: 0.3, borderColor: UIColor.lightGray, cornerRadius: 3.0)

            aCell.gBtnCity.removeTarget(self, action: nil, for: .allEvents)
            aCell.gBtnCity.addTarget(self, action: #selector(countryBtnTapped), for: .touchUpInside)
            aCell.gBtnCity.setTitle(self.myStrCountry.count==0 ? "Choose country" : self.myStrCountry, for: .normal)
            
            return aCell
        }
        
        else {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellCountryIdentifier, for: indexPath) as! GSCountryTableViewCell
            aCell.gBtnCity.tag = TAG_STATE_BUTTON
            aCell.gLblCountry.text = REG_STATE
            aCell.gContainerView.tag = 8888
            HELPER.setBorderView(aView: aCell.gContainerView, borderWidth: 0.3, borderColor: UIColor.lightGray, cornerRadius: 3.0)

            aCell.gBtnCity.setTitle(REG_STATE, for: UIControlState.normal)
            aCell.gBtnCity.removeTarget(self, action: nil, for: .allEvents)
            aCell.gBtnCity.addTarget(self, action: #selector(stateBtnTapped), for: .touchUpInside)
            
            aCell.gBtnCity.setTitle(self.myStrState.count==0 ? "Choose state" : self.myStrState, for: .normal)
            
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
            
        else if textField.tag == TAG_EMAIL {
            
            myStrEmail = txtAfterUpdate
        }
            
        else if textField.tag == TAG_USER_NAME {
            
            myStrUsername = txtAfterUpdate
        }
            
        else if textField.tag == TAG_PASSWORD {
            
            if txtAfterUpdate.count <= 15 {
                
                myStrPassword = txtAfterUpdate
                
                return true
            }
                
            else {
                
                return false
            }
        }
            
        else if textField.tag == TAG_REPEAT_PASSWORD {
            
            if txtAfterUpdate.count <= 15 {
                
                myStrRepeatPassword = txtAfterUpdate
                
                return true
            }
                
            else {
                
                return false
            }
        }
        
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.returnKeyType == UIReturnKeyType.next {
            
            self.myTblViewRegister .viewWithTag(textField.tag + 10)?.becomeFirstResponder()
        }
            
        else {
            
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    //MARK:- Imagae picker Delegates

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage

        if let data = UIImageJPEGRepresentation(image, 0.1) {
            
            myDataFile = data
        }
      
        let aImgViewProfile = self.myTblViewRegister.viewWithTag(TAG_PROFILE_IMAGE_VIEW) as! UIImageView
        aImgViewProfile.image = image
//
////        let image_data = info[UIImagePickerControllerOriginalImage] as? UIImage
////        myDataFile = (UIImageJPEGRepresentation(image_data!, 0.5))!
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
//            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//
//            let aImgViewProfile = self.myTblViewRegister.viewWithTag(TAG_PROFILE_IMAGE_VIEW) as! UIImageView
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated:true, completion: nil)
    }
    
    func showPhotoAction () {
        
        let aActionSheetController: UIAlertController = UIAlertController(title: "Choose a photo via", message: nil, preferredStyle: .actionSheet)
        
        let aActionCancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { void in
            print("Cancel")
        }
        aActionSheetController.addAction(aActionCancel)
        
        let aActionCamera: UIAlertAction = UIAlertAction(title: "Camera", style: .default)
        { void in
            
            self.openCamera()
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
        picker.mediaTypes = ([(kUTTypeImage as? String)] as? [String])!
        
        picker.navigationBar.barTintColor = HELPER.hexStringToUIColor(hex: APP_COLOR)
        picker.navigationBar.tintColor = .white

//        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(picker, animated: true, completion: nil)
    }
    
    func openCamera() {
        
        isClickImage = false

        let picker = UIImagePickerController()
        
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .camera
        picker.mediaTypes = ([(kUTTypeImage as? String)] as? [String])!
//        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
        self.present(picker, animated: true, completion: nil)
    }
    
    // MARK:- Api Request
    
    func httpRequestForRegister() {

        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "User registering..")

        let dictRegisteration = ["fullname":myStrName,"username":myStrUsername,"email":myStrEmail,"password":myStrPassword,"state":myStrStateId,"country":myStrCountryId,"user_timezone":TimeZone.current.identifier] as [String : Any]
        
        print(dictRegisteration)
        
        let headers = ["Content-Type" : "application/json; charset=utf-8","token": "8338d6ff4f0878b222f312494c1621a9"]

        Alamofire.upload(multipartFormData: { (multipartFormData) in

            if self.myDataFile != nil {
                
                multipartFormData.append(self.myDataFile, withName: "profile_img", fileName: "iosimg.jpg", mimeType: "image/jpg")
            }
                
//            if imageUrl1 != nil {
//
//                multipartFormData.append(imageUrl1, withName: "profile_img")
//
//            }
            
            for (key, value) in dictRegisteration {

                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        },

        usingThreshold: UInt64.init(), to: WEB_SERVICE_URL + CASE_REGISTER, method: .post, headers: headers) { (result) in
            
            switch result {
            case .success(let upload, _, _):

                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    
                    print(progress)
                })

                upload.responseJSON { response in
                    
                HELPER.hideLoadingAnimation()
                    
                    if response.result.isSuccess {
                        
                        let jsonDict = response.result.value as? [String:Any]
                        
                        let aIntResponseCode = jsonDict!["code"] as! Int
                        let aMessageResponse = jsonDict!["message"] as! String
                        
                        if aIntResponseCode == RESPONSE_CODE_200 {
                            
                            HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse, okActionBlock: { (Action) in
                                
                                self.navigationController?.popViewController(animated: true)
                            })
                        }
                            
                        else {
                            HELPER.hideLoadingAnimation()
                            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
                        }
                    }
                    
                    else {
                        
                        HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: "debug")

                    }
                }

            case .failure(let encodingError):
                print (encodingError.localizedDescription)
                HELPER.hideLoadingAnimation()
            }
        }
    }
    
    //Language
    func TermsandConditionApi() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "Terms and condition..")
        
        HTTPMANAGER.callGetApi(strUrl:WEB_SERVICE_URL+CASE_TERMS_AND_CONDITION, sucessBlock: {response in
            
            HELPER.hideLoadingAnimation()
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                self.myDictTermsInfo = response["data"] as! [String:Any] as! [String : String]
                
                if self.myDictTermsInfo.count > 0 {
                    
                    let aViewController = GSFAQsViewController()
                    aViewController.gStrTitle = "Terms and Condition"
                    aViewController.gStrContent = self.myDictTermsInfo["user_terms_and_conditions"] as! String
                    self.navigationController?.pushViewController(aViewController, animated: true)
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
    
//    func TermsandConditionApi() {
//
//        if !HELPER.isConnectedToNetwork() {
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
//            return
//        }
//
//        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "Terms and condition..")
//
//        HTTPMANAGER.TermsandConditionRequest(sucessblock: {response in
//
//            HELPER.hideLoadingAnimation()
//
//            let aIntResponseCode = response["code"] as! Int
//            let aMessageResponse = response["message"] as! String
//
//            if aIntResponseCode == RESPONSE_CODE_200 {
//
//                self.myDictTermsInfo = response["data"] as! [String:Any] as! [String : String]
//
//                if self.myDictTermsInfo.count > 0 {
//
//                    let aViewController = GSFAQsViewController()
//                    aViewController.gStrTitle = "Terms and Condition"
//                    aViewController.gStrContent = self.myDictTermsInfo["user_terms_and_conditions"] as! String
//                    self.navigationController?.pushViewController(aViewController, animated: true)
//                }
//
//            } else {
//                HELPER.hideLoadingAnimation()
//                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
//            }
//            
//        }, failureBlock: { error in
//
//            HELPER.hideLoadingAnimation()
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
//        })
//    }
    
    // MARK:- Button Actions
    
    @IBAction func myBtnRegisterTapped(_ sender: UIButton) {
        
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
                
                if (self.myStrName.count == 0) && (self.myStrEmail.count == 0) && (self.myStrUsername.count == 0) && (self.myStrPassword.count == 0) && (self.myStrRepeatPassword.count == 0) {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_REQUIRED_FIELDS)
                }
                    
                else if (self.myStrName.count == 0) {

                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_NAME, aStrMessage: ALERT_EMPTY_FIELD)
                }
                    
                else if (self.myStrEmail.count == 0) {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_EMAIL_ID, aStrMessage: ALERT_EMPTY_FIELD)
                }
                    
                else if !HELPER.isValidEmailAddress(emailAddressString: self.myStrEmail) {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_EMAIL_ID, aStrMessage: ALERT_EMAIL_ID_NOTVALID)
                }
                    
                else if (self.myStrUsername.count == 0) {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_USERNAME, aStrMessage: ALERT_EMPTY_FIELD)
                }
                    
                else if (self.myStrPassword.isEmpty) {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_PASSWORD, aStrMessage: ALERT_EMPTY_FIELD)
                }
                    
                else if !HELPER.isPasswordValid(password: self.myStrPassword) {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_PASSWORD, aStrMessage: ALERT_PASSWORD)
                }
                    
                else if (self.myStrRepeatPassword.isEmpty) {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_REPEAT_PASSWORD, aStrMessage: ALERT_EMPTY_FIELD)
                }
                    
                else if (self.myStrPassword != self.myStrRepeatPassword) {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_PASSWORD, aStrMessage: ALERT_PASSWORD_MATCH)
                }
                    
                else if (self.myStrCountryId.isEmpty) {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_COUNTRY, aStrMessage: ALERT_EMPTY_FIELD)
                }
                    
                else if (self.myStrStateId.isEmpty) {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_STATE, aStrMessage: ALERT_EMPTY_FIELD)
                }
                    
                else {
                    
                    self.httpRequestForRegister()
                }
            }
        })
    }
    

    @IBAction func myBtnTmsAndCndtTapped(_ sender: UIButton) {
        
        TermsandConditionApi()
        
    }
    
    @IBAction func myBtnLoginTapped(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnTermsandConditionTapped(_ sender: UIButton) {
        
        myBtnTrmsandCnd.setImage(UIImage(named:ICON_CHECKED_BOX), for: .normal)
        
        isAgreeTerms = isAgreeTerms ? false : true
        
//        isAgreeTerms = true ? ICON_CHECKED_BOX : ICON_UNCHECKED_BOX
        
        myBtnRegister.isUserInteractionEnabled = isAgreeTerms
//        myBtnTrmsandCnd.setImage(UIImage(named: ICON_BACK), for: .normal)
        myBtnRegister.backgroundColor = isAgreeTerms ? HELPER.hexStringToUIColor(hex: APP_GREEN_COLOR) : UIColor.lightGray
    }
    
    // MARK:- Private functions
    
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
    
    @objc func profileBtnTapped(sender: UITapGestureRecognizer!) {
        
        showPhotoAction()
    }
    
    @objc func countryBtnTapped(sender: UIButton) {
        
        let aViewController = GSChooseLocationViewController()
        aViewController.gIsClickCountry = true
        aViewController.gStrCountryId = myStrCountryId

        aViewController.completion = {(countryName,countryId) in
            
            let aBtnCountry = self.myTblViewRegister.viewWithTag(self.TAG_COUNTRY_BUTTON) as! UIButton

            aBtnCountry.setTitle(countryName!, for: .normal)
            
            self.myStrCountry = countryName!
            self.myStrCountryId = countryId!
            
            self.myStrState = ""
            self.myStrStateId = ""
            let aBtnState = self.myTblViewRegister.viewWithTag(self.TAG_STATE_BUTTON) as! UIButton
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
//        aViewController.gIsClickState = true
        aViewController.gStrCountryId = self.myStrCountryId
        aViewController.myStrStateId = myStrStateId

        aViewController.completion = {(stateName,stateId) in
            
            let aBtnState = self.myTblViewRegister.viewWithTag(self.TAG_STATE_BUTTON) as! UIButton
            aBtnState.setTitle(stateName!, for: .normal)
            
            self.myStrState = stateName!
            self.myStrStateId = stateId!
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
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}

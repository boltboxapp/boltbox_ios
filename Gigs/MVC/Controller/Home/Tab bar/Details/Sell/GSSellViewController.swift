//
//  GSSellViewController.swift
//  Gigs
//
//  Created by dreams on 08/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit
import Alamofire
import Photos
import MobileCoreServices

var myStrCategoryNameForSell = String()
var Updatedimage:UIImage?
var myStrGigDeliveryDay = String()
var myStrGigPrice = String()
var myStrGigDescription = String()
var myStrGigTitle = String()
var myAryExtrasInfo = [[String:Any]]()
var myDictExtrasInfo = [String:Any]()
var myStrWorkOption = String()
var myStrGigDescriptionSuperFast = String()
var myStrGigTitleSuperFast = String()
var myStrGigDeliveryDaySuperFast = String()
var myStrGigPriceSuperFast = String()
var myStrGigImage = String()
var myStrTermsAndConditionCheck = String()
var myStrCategoryId = String()
var myFileName = String()
var imageUrl1: URL!
var myDataFile = Data()
var myStrCostType = String()
var myStrCostTypeFromGigs = String()

class GSSellViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var myTblView: UITableView!
    @IBOutlet weak var myBtnTandC: UIButton!
    @IBOutlet weak var myBtnTandCList: UIButton!
    @IBOutlet weak var myBtnCreateGig: UIButton!
    @IBOutlet var myLblTandC: UILabel!
    
    let cellGigImageIdentifier = "GSGigImageTableViewCell"
    let cellDetailsIdentifier = "GSGigsDetailsTableViewCell"
    let cellCategoryIdentifier = "GSGigsCategoryTableViewCell"
    let cellDeliveryDetailsIdentifier = "GSDeliveryDetailsTableViewCell"
    let cellAddIdentifier = "GSAddButtonTableViewCell"
    let cellSuperFastIdentifier = "GSSuperFastTableViewCell"

    let TAG_GIG_TITLE : Int = 10
    let TAG_GIG_DELIVERY_DAY : Int = 20
    let TAG_GIG_PRICE : Int = 30
    let TAG_GIG_DESCRIPTION : Int = 40
    let TAG_GIG_TITLE_EXTRA : Int = 50
    let TAG_GIG_DELIVERY_DAY_EXTRA : Int = 70
    let TAG_GIG_PRICE_EXTRA : Int = 60
    let TAG_GIG_TITLE_EXTRA_SUPERFAST : Int = 80
    let TAG_GIG_DELIVERY_DAY_EXTRA_SUPERFAST : Int = 90
    let TAG_GIG_PRICE_EXTRA_SUPERFAST : Int = 99
    let TAG_GIG_DESCRIPTION_EXTRA_SUPERFAST : Int = 110
    
    let TAG_IMG_VIEW : Int = 200
    
    let TAG_ONSITE_BUTTON = 300
    let TAG_REMOTE_BUTTON = 400
    let TAG_CATEGORY = 500

    var myStrSuperFastCheck = String()

    var isBoolCamera = Bool()
    var isClickImage: Bool!

//    var isClickImage: Bool = false

//    var imageUrl: URL!
    
    var gStrGigId = String()
    
    var myStrGigTitleExtra = String()
    var myStrGigDeliveryDayExtra = String()
    var myStrGigPriceExtra = String()
    
//    var myStrCategoryName = String()

    var myAryCategoryInfo = [[String:Any]]()
    
    var myDictTermsInfo = [String:Any]()
    var myDictPriceTypeInfo = [String:String]()

    var isFromEditGigs = false
    
    let TITLE = "extra_gigs"
    let PRICE = "extra_gigs_amount"
    let DAYS = "extra_gigs_delivery"

    override func viewDidLoad() {
        super.viewDidLoad()
       
//        setUpUI()
//        
//        if isSellTabSelected {
//            setUpModel()
//            loadModel()
//            isSellTabSelected = false
//        }
        // Do any additional setup after loading the view.
        
        let priceOption = SESSION.getUserPriceOption()
        if priceOption.0 == "fixed" {
            myStrCostType = "0"
        }
        else {
            myStrCostType = "1"
        }
        
        setUpUI()
        setUpModel()
        loadModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        setUpUI()
        if isSellTabSelected {

            let priceOption = SESSION.getUserPriceOption()
            if priceOption.0 == "fixed" {
                myStrCostType = "0"
            }
            else {
                myStrCostType = "1"
            }

            setUpModel()
            loadModel()
            isSellTabSelected = false
            self.myTblView.reloadData()
        }
        self.navigationController?.navigationBar.topItem?.title = "Sell Service"
    }
    func setUpUI() {
        
        userPriceType()
        
        if isFromEditGigs {
        self.setUpLeftBarBackButton()
        }
        NAVIGAION.setNavigationTitle(aStrTitle: "Sell Service", aViewController: self)
//        self.navigationController?.navigationBar.topItem?.title = "Sell Service"
        self.myBtnCreateGig.backgroundColor = HELPER.hexStringToUIColor(hex: APP_GREEN_COLOR)
        HELPER.setRoundCornerView(aView: self.myBtnCreateGig, borderRadius: 7.0)
        
        myTblView.delegate = self
        myTblView.dataSource = self
        
        myTblView.register(UINib.init(nibName: cellGigImageIdentifier, bundle: nil), forCellReuseIdentifier: cellGigImageIdentifier)
        myTblView.register(UINib.init(nibName: cellDetailsIdentifier, bundle: nil), forCellReuseIdentifier: cellDetailsIdentifier)
        myTblView.register(UINib.init(nibName: cellCategoryIdentifier, bundle: nil), forCellReuseIdentifier: cellCategoryIdentifier)
        myTblView.register(UINib.init(nibName: cellDeliveryDetailsIdentifier, bundle: nil), forCellReuseIdentifier: cellDeliveryDetailsIdentifier)
        myTblView.register(UINib.init(nibName: cellAddIdentifier, bundle: nil), forCellReuseIdentifier: cellAddIdentifier)
        myTblView.register(UINib.init(nibName: cellSuperFastIdentifier, bundle: nil), forCellReuseIdentifier: cellSuperFastIdentifier)
        
       
        myBtnCreateGig.isUserInteractionEnabled = false
        
        myBtnCreateGig.setTitle("Create a Gig", for: .normal)
        
        if isFromEditGigs {
            
            myBtnCreateGig.setTitle("Update Gigs", for: .normal)
            myBtnTandC.isHidden = true
            myLblTandC.isHidden = true
            myBtnTandCList.isHidden = true
            myStrTermsAndConditionCheck = "1"
            myBtnCreateGig.isUserInteractionEnabled = true
        }
        myBtnCreateGig.backgroundColor = myStrTermsAndConditionCheck == "1" ? HELPER.hexStringToUIColor(hex: APP_GREEN_COLOR) : UIColor.lightGray
        myTblView.keyboardDismissMode = .onDrag
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
        if isFromEditGigs != true {
            myDictExtrasInfo = [TITLE:"",PRICE:"",DAYS:""]
            myAryExtrasInfo.removeAll()
            myAryExtrasInfo.append(myDictExtrasInfo)
            
        }
        else {
//            if myAryExtrasInfo.count < 1 {
                self .getGigDetails()
//            }
        }
        
    }

    
    // MARK: - TableView Delegate and Datasource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 0) {
            
            return 3
        }
        else if (section == 1) {
            
            return myAryExtrasInfo.count + 1
        }
        else {
            return 1

        }
        
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        if (indexPath.row == 0) {
//
//            return 150
//        }
//
//        else if (indexPath.row == 1) {
//
//            return 280
//        }
//
//        else if (indexPath.row == 2) {
//
//            return 80
//        }
//
//        else if (indexPath.row == 3) {
//
//            return 60
//        }
//
//        else if (indexPath.row == 4) {
//
//            return 40
//        }
//
//        return 240
//    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if (indexPath.row == 0) {
                
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellGigImageIdentifier, for: indexPath) as! GSGigImageTableViewCell
                
                HELPER.setRoundCornerView(aView: aCell.gImgView)
                HELPER.setRoundCornerView(aView: aCell.gContainerView)
                
                aCell.gImgView.tag = TAG_IMG_VIEW
                
                if let image = Updatedimage {
                    
                     aCell.gImgView.image = image
                }
                else  {
                    aCell.gImgView.setShowActivityIndicator(true)
                    aCell.gImgView.setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
                    aCell.gImgView.sd_setImage(with: URL(string: SESSION.getBaseImageUrl() + myStrGigImage), placeholderImage: UIImage(named: ICON_PROFILE_PLACEHOLDER_IMAGE))
                }
                
                aCell.gBtnImage.addTarget(self, action: #selector(imageBtnTapped), for: .touchUpInside)
                
                return aCell
            }
                
            else if (indexPath.row == 1) {
                
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellDetailsIdentifier, for: indexPath) as! GSGigsDetailsTableViewCell
                
                aCell.gTxtFldTitle.delegate = self
                aCell.gTxtFldDays.delegate = self
                aCell.gTxtFldCost.delegate = self
                
                aCell.gTxtFldCost.keyboardType = UIKeyboardType.decimalPad
                
                aCell.gTxtViewGigDetails.delegate = self
                aCell.gTxtFldTitle.tag = TAG_GIG_TITLE 
                aCell.gTxtFldDays.tag = TAG_GIG_DELIVERY_DAY
                
                aCell.gTxtFldCost.text = myStrGigPrice
                aCell.gTxtFldCost.isUserInteractionEnabled = true
                
                let aStrPriceOption = myDictPriceTypeInfo["price_option"]
                let aStrPrice = myDictPriceTypeInfo["gig_price"]
//                let aStrExtraPrice1 = myDictPriceTypeInfo["extra_gig_price"]
                
                if aStrPriceOption == "fixed" {
                    myStrGigPrice = aStrPrice!
                    aCell.gTxtFldCost.text = myStrGigPrice
                    aCell.gTxtFldCost.isUserInteractionEnabled = false
                }
                
                 if isFromEditGigs { //add cost function here!
                    
                    if myStrCostTypeFromGigs == "0" {
                        
                        aCell.gTxtFldCost.isUserInteractionEnabled = false
                    }
                    else {
                        aCell.gTxtFldCost.isUserInteractionEnabled = true
                    }
                }
                
                aCell.gTxtFldCost.tag = TAG_GIG_PRICE
                aCell.gTxtViewGigDetails.tag = TAG_GIG_DESCRIPTION
                aCell.gTxtFldTitle.text =  myStrGigTitle
                aCell.gTxtFldDays.text = myStrGigDeliveryDay
                
//                var addressTxt:String = myDictnfo["address"] ?? ""
                aCell.gTxtViewGigDetails.text = myStrGigDescription.count > 0 ? myStrGigDescription : "Enter gig description.."
                aCell.gTxtViewGigDetails.textColor =  UIColor.black
                if aCell.gTxtViewGigDetails.text == "Enter gig description.." {
                    aCell.gTxtViewGigDetails.textColor = UIColor.lightGray
                }
                
                return aCell
            }
                
            else if (indexPath.row == 2) {
                
                
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellCategoryIdentifier, for: indexPath) as! GSGigsCategoryTableViewCell
                
                aCell.gBtnCategory.addTarget(self, action: #selector(categoryBtnTapped), for: .touchUpInside)
                aCell.gBtnCategory.tag = TAG_CATEGORY
                
                if myStrCategoryNameForSell == "" {
                    aCell.gBtnCategory.setTitle("Choose category", for: .normal)
                }
                else {
                    aCell.gBtnCategory.setTitle(myStrCategoryNameForSell.count==0 ? "Choose category" : myStrCategoryNameForSell, for: .normal)
                }
                return aCell
            }
        }
        if indexPath.section == 1 {
            
            if myAryExtrasInfo.count == indexPath.row {
                
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellAddIdentifier, for: indexPath) as! GSAddButtonTableViewCell
                
                HELPER.changeTheButtonImageColorWithDefault(color: .gray, button: (aCell.gBtnAdd)!, imageName: ICON_PLUS)
                
                aCell.gBtnAdd.addTarget(self, action: #selector(addBtnTapped), for: .touchUpInside)
                
                return aCell
            }
            else {
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellDeliveryDetailsIdentifier, for: indexPath) as! GSDeliveryDetailsTableViewCell
                
                aCell.gTxtFldContent.delegate = self
                aCell.gTxtFldPrice.delegate = self
                aCell.gTxtFldDays.delegate = self
                
                aCell.gTxtFldPrice.keyboardType = UIKeyboardType.decimalPad
                
                let aStrCurrency = SESSION.getCurrencySign()
                aCell.gTxtFldPrice.placeholder = aStrCurrency
                
                let aStrPriceOption = myDictPriceTypeInfo["price_option"]
                let aStrPrice = myDictPriceTypeInfo["extra_gig_price"]
                
                if aStrPriceOption == "fixed" {
                    
                    let tempmyStrGigPrice = aStrPrice!
//                    aCell.gTxtFldPrice.text = tempmyStrGigPrice
//                    aCell.gTxtFldPrice.isUserInteractionEnabled = false
                    
                    if myAryExtrasInfo.count > 0 {
                        var dict:[String:Any] = myAryExtrasInfo[indexPath.row]
                        aCell.gTxtFldContent.text = dict[TITLE] as? String
                        aCell.gTxtFldDays.text = dict[DAYS] as? String
                        myStrGigPriceExtra = tempmyStrGigPrice
                        aCell.gTxtFldPrice.text = tempmyStrGigPrice//dict[PRICE] as? String
                        aCell.gTxtFldPrice.isUserInteractionEnabled = true
                        
                         if isFromEditGigs {
                            
                            aCell.gTxtFldPrice.text = dict[PRICE] as? String
                            
                            if myStrCostTypeFromGigs == "0" {
                                
                                aCell.gTxtFldPrice.isUserInteractionEnabled = true
                            }
                            else {
                                aCell.gTxtFldPrice.isUserInteractionEnabled = true
                            }
                            
                        }
                    }
                    else {
                        aCell.gTxtFldContent.text = ""
                        aCell.gTxtFldDays.text = ""
                        aCell.gTxtFldPrice.text = ""
                        aCell.gTxtFldPrice.isUserInteractionEnabled = true
                    }
                    
                }else {
                    aCell.gTxtFldPrice.isUserInteractionEnabled = true
                }
                
                aCell.gTxtFldContent.tag = TAG_GIG_TITLE_EXTRA + indexPath.row
                aCell.gTxtFldDays.tag = TAG_GIG_DELIVERY_DAY_EXTRA + indexPath.row
                aCell.gTxtFldPrice.tag = TAG_GIG_PRICE_EXTRA + indexPath.row
                
                
                aCell.deletegigsBtn.isHidden = false
                aCell.deletegigsBtn.tag = indexPath.row
                aCell.deletegigsBtn.addTarget(self, action: #selector(deleteGigsBtnTapped), for: .touchUpInside)
                
                if isFromEditGigs {
                aCell.deletegigsBtn.isHidden = false
                aCell.deletegigsBtn.tag = indexPath.row
                aCell.deletegigsBtn.addTarget(self, action: #selector(deleteGigsBtnTapped), for: .touchUpInside)
                }
                
                if myAryExtrasInfo.count > 0 {
                var dict:[String:Any] = myAryExtrasInfo[indexPath.row]
                aCell.gTxtFldContent.text = dict[TITLE] as? String
                aCell.gTxtFldDays.text = dict[DAYS] as? String
                aCell.gTxtFldPrice.text = dict[PRICE] as? String
                }
                else {
                    aCell.gTxtFldContent.text = ""
                    aCell.gTxtFldDays.text = ""
                    aCell.gTxtFldPrice.text = ""
                }
                return aCell
            }
            
        }
        else  {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellSuperFastIdentifier, for: indexPath) as! GSSuperFastTableViewCell
            
            aCell.gLblSuperFastCheck.constant = 0
            aCell.gBtnSuperfastCheckHeight.constant = 0
            
            if myStrGigDeliveryDay.count > 0 {
                
                aCell.gLblSuperFastCheck.constant = 21
                aCell.gBtnSuperfastCheckHeight.constant = 21
            }
            
            aCell.gTxtFldContent.delegate = self
            aCell.gTxtFldDays.delegate = self
            aCell.gTxtFldAmount.delegate = self
            
            aCell.gTxtFldAmount.keyboardType = UIKeyboardType.decimalPad
            
            let aStrCurrency = SESSION.getCurrencySign()
            aCell.gTxtFldAmount.placeholder = aStrCurrency
            
            aCell.gTxtViewDescription.delegate = self
            aCell.gTxtFldContent.tag = TAG_GIG_TITLE_EXTRA_SUPERFAST
            aCell.gTxtFldDays.tag = TAG_GIG_DELIVERY_DAY_EXTRA_SUPERFAST
            aCell.gTxtFldAmount.tag = TAG_GIG_PRICE_EXTRA_SUPERFAST
            
            aCell.gBtnSuperfastCheck.addTarget(self, action: #selector(superfastBtnTapped), for: .touchUpInside)
            aCell.gBtnSuperfastCheck.tag =  indexPath.row
            aCell.gBtnOnSiteCheck.tag = TAG_ONSITE_BUTTON + indexPath.row
            aCell.gBtnRemoteCheck.tag = TAG_REMOTE_BUTTON + indexPath.row
            aCell.gBtnRemoteCheck.addTarget(self, action: #selector(superfastBtnTapped), for: .touchUpInside)
            aCell.gBtnOnSiteCheck.addTarget(self, action: #selector(superfastBtnTapped), for: .touchUpInside)
            
            aCell.gTxtViewDescription.tag = TAG_GIG_DESCRIPTION_EXTRA_SUPERFAST
            aCell.superFastViewHeight.constant = 0
            aCell.gBtnSuperfastCheck.isSelected = false
            if myStrSuperFastCheck == "Yes" {
                
                let aStrPrice = myDictPriceTypeInfo["extra_gig_price"]
                
//                myStrGigPriceSuperFast = aStrPrice!
            //    myStrGigPriceSuperFast = ""

                aCell.superFastViewHeight.constant = 40
                aCell.gTxtFldContent.text = myStrGigTitleSuperFast
                aCell.gTxtFldDays.text = myStrGigDeliveryDaySuperFast
                aCell.gTxtFldAmount.text = myStrGigPriceSuperFast
                aCell.gBtnSuperfastCheck.isSelected = true
            }
            
//            var addressTxt:String = myDictnfo["address"] ?? ""
            aCell.gTxtViewDescription.text = myStrGigDescriptionSuperFast.count > 0 ? myStrGigDescriptionSuperFast : "What do you need from buyer to get start.."
            aCell.gTxtViewDescription.textColor =  UIColor.black
            if aCell.gTxtViewDescription.text == "What do you need from buyer to get start.." {
                aCell.gTxtViewDescription.textColor = UIColor.lightGray
            }
            
            if myStrWorkOption == "1" {
                aCell.gBtnOnSiteCheck.isSelected = true
            }
            else if myStrWorkOption == "0" {
                aCell.gBtnRemoteCheck.isSelected = true
            }
            else {
                aCell.gBtnRemoteCheck.isSelected = false
                aCell.gBtnOnSiteCheck.isSelected = false
            }
            
            return aCell
            
        }
    }
    
    
    //MARK: - Textfield Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
        if textField.tag == TAG_GIG_TITLE {
            
            myStrGigTitle = txtAfterUpdate
        }
            
        else if textField.tag == TAG_GIG_DELIVERY_DAY {
            
            if txtAfterUpdate.count > 0 {
                
                let text:Int = Int(txtAfterUpdate)!
                if text > 30 {
                    myStrGigDeliveryDaySuperFast = myStrGigDeliveryDay
                    textField.text = "29"
                    return false
                }
            }
            myStrGigDeliveryDay = txtAfterUpdate
        }
            
        else if textField.tag == TAG_GIG_PRICE {
            
            myStrGigPrice = txtAfterUpdate
        }
            
        else if textField.tag < TAG_GIG_PRICE_EXTRA {

            myStrGigTitleExtra = txtAfterUpdate
        }

        else if textField.tag < TAG_GIG_DELIVERY_DAY_EXTRA {

            myStrGigPriceExtra = txtAfterUpdate
        }

        else if textField.tag < TAG_GIG_TITLE_EXTRA_SUPERFAST {

            if txtAfterUpdate.count > 0 {
                
                let text:Int = Int(txtAfterUpdate)!
                if text > 15 {
                    myStrGigDeliveryDaySuperFast = myStrGigDeliveryDay
                    textField.text = "14"
                    return false
                }
            }
            myStrGigDeliveryDayExtra = txtAfterUpdate
        }
            
        else if textField.tag == TAG_GIG_TITLE_EXTRA_SUPERFAST {
            
            myStrGigTitleSuperFast = txtAfterUpdate
        }
            
        else if textField.tag == TAG_GIG_DELIVERY_DAY_EXTRA_SUPERFAST {
            
             myStrGigDeliveryDaySuperFast = txtAfterUpdate
            
            if txtAfterUpdate.count > 0 {
                let days:Int = Int(myStrGigDeliveryDay)!
                let text:Int = Int(txtAfterUpdate)!
                if text > days {
                    myStrGigDeliveryDaySuperFast = myStrGigDeliveryDay
                    textField.text = myStrGigDeliveryDaySuperFast
                    return false
                }
            }
        }
            
        else if textField.tag == TAG_GIG_PRICE_EXTRA_SUPERFAST {
            
            myStrGigPriceSuperFast = txtAfterUpdate
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
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    
        myDictExtrasInfo = [TITLE:myStrGigTitleExtra,PRICE:myStrGigPriceExtra,DAYS:myStrGigDeliveryDayExtra]
        if textField.tag >= 70 && textField.tag <= 79 {
        var dict = myAryExtrasInfo[textField.tag - TAG_GIG_DELIVERY_DAY_EXTRA]
        dict = myDictExtrasInfo
        myAryExtrasInfo.remove(at: textField.tag - TAG_GIG_DELIVERY_DAY_EXTRA)
        myAryExtrasInfo.insert(dict, at: textField.tag - TAG_GIG_DELIVERY_DAY_EXTRA)
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
        
        if textView.tag == TAG_GIG_DESCRIPTION {
            
            if textView.textColor == UIColor.lightGray {
                textView.text = ""
                textView.textColor = UIColor.black
            }
        }
        else if textView.tag == TAG_GIG_DESCRIPTION_EXTRA_SUPERFAST {
            
            if textView.textColor == UIColor.lightGray {
                textView.text = ""
                textView.textColor = UIColor.black
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.tag == TAG_GIG_DESCRIPTION {
            
            if textView.text == "" {
                
                textView.text = "Enter gig description.."
                textView.textColor = UIColor.lightGray
            }
        }
        else if textView.tag == TAG_GIG_DESCRIPTION_EXTRA_SUPERFAST {
            
            if textView.text == "" {
                
                textView.text = "What do you need from buyer to get start.."
                textView.textColor = UIColor.lightGray
            }
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let textViewText: NSString = (textView.text ?? "") as NSString
        let txtAfterUpdate = textViewText.replacingCharacters(in: range, with: text)
        
        if textView.tag == TAG_GIG_DESCRIPTION {

            myStrGigDescription = txtAfterUpdate
        }
        
        else if textView.tag == TAG_GIG_DESCRIPTION_EXTRA_SUPERFAST {
            
            myStrGigDescriptionSuperFast = txtAfterUpdate
        }
        
        return true
    }
    
    //MARK: - Imagepicker Delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        Updatedimage = info[UIImagePickerControllerOriginalImage] as? UIImage
        let aImgViewProfile = self.myTblView.viewWithTag(TAG_IMG_VIEW) as! UIImageView
        aImgViewProfile.image = Updatedimage
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if let data = UIImageJPEGRepresentation(image, 0.1) {
            
            myDataFile = data
        }
        
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
//                            imageUrl1 = fileName as URL?
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
//            //dismiss(animated:true, completion: nil)
//        }
        
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        isClickImage = false
        dismiss(animated:true, completion: nil)
    }
    
    func generateJsonStringForExtragigs() -> String  {
        
//        var jsonString = ""
//        let jsonArr = NSMutableArray()
//        for i in 0 ... myAryExtrasInfo.count - 1 {
//
//            let dict:[String:Any] = myAryExtrasInfo[i]
//            let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
//            jsonString = String(data: jsonData!, encoding: .utf8)!
//            print(jsonString )
//            jsonArr.add(jsonString)
//        }
//        return jsonArr
        
        var theJSONText = String()
        var jsonData = Data()
        
        if myAryExtrasInfo.count > 0 {
            
            self .getLastGigsValuesinArray()
            if self.myStrGigTitleExtra.count == 0 && self.myStrGigPriceExtra.count == 0 && self.myStrGigDeliveryDayExtra.count == 0 {
                myAryExtrasInfo.remove(at: myAryExtrasInfo.count - 1)
            }
        }
        do {
            
            jsonData = try JSONSerialization.data(withJSONObject: myAryExtrasInfo, options: .prettyPrinted)
            theJSONText =  String(bytes: jsonData, encoding: String.Encoding.utf8)!
            
        } catch {
            
            print(theJSONText)
        }
        
        return theJSONText
    }
    
    func getLastGigsValuesinArray()  {
        
        if myAryExtrasInfo.count != 0 {
            
            var dict = myAryExtrasInfo[myAryExtrasInfo.count - 1]
            self.myStrGigTitleExtra = dict[self.TITLE] as! String
            self.myStrGigPriceExtra = dict[self.PRICE] as! String
            self.myStrGigDeliveryDayExtra = dict[self.DAYS] as! String
        }
    }
    
    // MARK: - Api call
    
    func httpRequestForCreateGig() {
        
        let gigid = isFromEditGigs ? gStrGigId :"0"
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "Loading..")
//        let dictRegisteration = ["title":"Gig App version 49999998884","delivering_time":"5","gig_price":"10","gig_details":"this is sample gis testing way API","category_id":"1","super_fast_delivery":"yes","super_fast_delivery_desc":"this sample","super_fast_charges":"15","super_fast_delivery_date":"3","requirements":"this ur option","terms_conditions":"1","work_option":"1","gig_tags":"app,gigs","extra_gigs":self.generateJsonStringForExtragigs(),"user_id":SESSION.getUserId(),"gig_id":gigid] as [String : Any] //default "user_id":SESSION.getUserId(),
        
        let dictRegisteration = ["title":myStrGigTitle,"delivering_time":myStrGigDeliveryDay,"gig_price":myStrGigPrice,"gig_details":myStrGigDescription,"category_id":myStrCategoryId,"super_fast_delivery":myStrSuperFastCheck,"super_fast_delivery_desc":myStrGigTitleSuperFast,"super_fast_charges":myStrGigPriceSuperFast,"super_fast_delivery_date":myStrGigDeliveryDaySuperFast,"requirements":myStrGigDescriptionSuperFast,"terms_conditions":myStrTermsAndConditionCheck,"work_option":myStrWorkOption,"gig_tags":"","extra_gigs":self.generateJsonStringForExtragigs(), "gig_id":gigid,"cost_type":myStrCostType] as [String : Any]

        callGigsEditOrUpdateApi(Parmeters: dictRegisteration)
    }
    
    func callGigsEditOrUpdateApi(Parmeters:[String : Any]) {
        
            let gigsUpdate = isFromEditGigs ? CASE_UPDATE_GIGS : CASE_CREATE_GIGS
        
        let headers = ["Content-Type" : "application/json; charset=utf-8","token":  SESSION.getUserId()]
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                if myDataFile != nil {
                    
                    multipartFormData.append(myDataFile, withName: "image", fileName: "iosimg.jpg", mimeType: "image/jpg")
//                    multipartFormData.append(myDataFile, withName: "image", fileName: "iosimg.png", mimeType: "image/png")

                }
                
                for (key, value) in Parmeters {
                    
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                    
                    
                }
            },
//                             to:WEB_SERVICE_URL + gigsUpdate)
        
            usingThreshold: UInt64.init(), to: WEB_SERVICE_URL + gigsUpdate, method: .post, headers: headers) { (result) in
                
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        
                        print(progress)
                        //Print progress
                    })
                    
                    upload.responseJSON { response in
                        
                        HELPER.hideLoadingAnimation()
                        
                        if response.result.isSuccess {
                            
                            if response.result.value is [String:Any]  {
                                
                                let jsonDict = response.result.value as? [String:Any]
                                
                                let aIntResponseCode = jsonDict!["code"] as! Int
                                let aMessageResponse = jsonDict!["message"] as! String
                                
                                if aIntResponseCode == RESPONSE_CODE_200 {
                                    
                                    HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse, okActionBlock: { (action) in
                                        self.navigationController?.popViewController(animated: true)
                                    })
                                }
                                else if aIntResponseCode == RESPONSE_CODE_404 {
                                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
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
                            }
                            else {
                                
                                let jsonDict = response.result.value as? String
                                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: jsonDict ?? "")
                            }
                            
                        } else {
                            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_UNABLE_TO_REACH_DESC)
                        }
                    }
                    
                case .failure(let encodingError):
                    print (encodingError.localizedDescription)
                    HELPER.hideLoadingAnimation()
                }
            }
        
    }
    
    func getGigDetails() {
        
        var dictParameters = [String:String]()
        //dictParameters[kUSER_ID] = SESSION.getUserId()
        dictParameters["gig_id"] = gStrGigId
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "Loading..")
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_VIEW_EDIT_GIG_DETAIL, dictParameters: dictParameters, sucessBlock: { (response) in

//        HTTPMANAGER.editGigRequest(parameter: dictParameters, sucessblock: {response in
            
            HELPER.hideLoadingAnimation()
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                var myAryInfo = response["data"] as! [[String:Any]]
                                
                var myDictnfo = myAryInfo[0]
                var myDictgiginfo = myDictnfo["gig_details"] as! [String:Any]
                
                myStrCostTypeFromGigs = myDictgiginfo["cost_type"] as! String
                
                var myArrImageinfo = myDictnfo["gig_images"] as! [[String:Any]]
                if myArrImageinfo.count > 0 {
                    
                    var myDictImageinfo = myArrImageinfo[0]
                    myStrGigImage = myDictImageinfo["gig_image_medium"] as! String
                }
                
                myStrGigTitle = myDictgiginfo["title"] as! String
                myStrGigDeliveryDay = myDictgiginfo["delivering_time"] as! String
                myStrGigPrice = myDictgiginfo["gig_price"] as! String
                myStrGigDescription = myDictgiginfo["gig_details"] as! String
                myStrCategoryId = myDictgiginfo["category_id"] as! String
                myStrCategoryNameForSell = myDictgiginfo["category_name"] as! String
                
                self.myStrSuperFastCheck = myDictgiginfo["super_fast_delivery"] as! String
                if self.myStrSuperFastCheck == "Yes" {
                    
                    myStrGigTitleSuperFast = myDictgiginfo["super_fast_delivery_desc"] as! String
                    myStrGigDeliveryDaySuperFast = myDictgiginfo["super_fast_delivery_date"] as! String
                    myStrGigPriceSuperFast = myDictgiginfo["super_fast_charges"] as! String
                }
                
                myStrWorkOption = myDictgiginfo["work_option"] as! String
                myStrGigDescriptionSuperFast = myDictgiginfo["requirements"] as! String
                myAryExtrasInfo = myDictnfo["extra_gigs"] as! [[String:Any]]
                
                self .getLastGigsValuesinArray()
                self.myTblView.reloadData()
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
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }

    func callCategoryList() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
//        HELPER.showLoadingViewAnimation(viewController: self)
        
        HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL+CASE_HOME_VIEWALL_GIGS, sucessBlock: {response in
        
//        HTTPMANAGER.categoryListRequest(sucessblock: {response in
            
            HELPER.hideLoadingAnimation(viewController: self)
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                print(response)
                
                self.myAryCategoryInfo = response["primary"] as! [[String : Any]] as! [[String : String]]
                
                self.myTblView.reloadData()
                
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
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation(viewController: self)
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    func TermsandConditionApi() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "Terms and condition..")
        
//        HTTPMANAGER.TermsandConditionRequest(sucessblock: {response in
        
            HTTPMANAGER.callGetApi(strUrl:WEB_SERVICE_URL+CASE_TERMS_AND_CONDITION, sucessBlock: {response in
        
            HELPER.hideLoadingAnimation()
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                self.myDictTermsInfo = response["data"] as! [String:Any]
                
                if self.myDictTermsInfo.count > 0 {
                    
                    let aViewController = GSFAQsViewController()
                    aViewController.gStrTitle = "Terms and Condition"
                    aViewController.gStrContent = self.myDictTermsInfo["gigs_terms_and_conditions"] as! String
                    self.navigationController?.pushViewController(aViewController, animated: true)
                }
                
            } else {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    
    func userPriceType() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "Loading")
        
        HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL+CASE_USER_PRICE_TYPE, sucessBlock: {response in
        
//        HTTPMANAGER.userPriceTypeRequest(sucessblock: {response in
        
            HELPER.hideLoadingAnimation()
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                self.myDictPriceTypeInfo = response["data"] as! [String:String]
                
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
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    // MARK: - Button Actions
    @IBAction func btnTermsAndCdtTapped(_ sender: Any) {
        
        let btn = sender as! UIButton
        btn.isSelected = !btn.isSelected
        myBtnCreateGig.backgroundColor = UIColor.lightGray
        myBtnCreateGig.isUserInteractionEnabled = false
        myStrTermsAndConditionCheck = "0"
        if btn.isSelected {
            myStrTermsAndConditionCheck = "1"
            myBtnCreateGig.isUserInteractionEnabled = true
            myBtnCreateGig.backgroundColor = myStrTermsAndConditionCheck == "1" ? HELPER.hexStringToUIColor(hex: APP_GREEN_COLOR) : UIColor.lightGray

        }
        
    }
    
    @IBAction func btnTandCListTapped(_ sender: Any) {
        
        TermsandConditionApi()
        
//        let aViewController = GSFAQsViewController()
//        aViewController.gStrTitle = "Terms and Condition"
//        aViewController.gStrContent = myDictTermsInfo["gigs_terms_and_conditions"] as! String
//        self.navigationController?.pushViewController(aViewController, animated: true)
    }
    @IBAction func btnCreateTapped(_ sender: Any) {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        if (myStrGigTitle.count == 0)  && (myStrGigPrice.count == 0) && (myStrGigDeliveryDay.count == 0) && (myStrGigDescription.count == 0) && (myStrGigDescriptionSuperFast.count == 0) && (myStrWorkOption.count == 0) {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_REQUIRED_FIELDS)
        }
        else if myDataFile.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_IMAGE, aStrMessage: ALERT_EMPTY_FIELD)
        }
            
        else if (myStrGigTitle.count == 0) {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_TITLE, aStrMessage: ALERT_EMPTY_FIELD)
        }
            
        else if (myStrGigPrice.count == 0) {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_GIG_PRICE, aStrMessage: ALERT_EMPTY_FIELD)
        }
            
        else if (myStrGigDeliveryDay.count == 0) {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_GIG_DELIVERY_DAYS, aStrMessage: ALERT_EMPTY_FIELD)
        }
            
        else if (myStrGigDescription.count == 0) {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_GIG_DESCRIPTION, aStrMessage: ALERT_EMPTY_FIELD)
        }
            
        else if (myStrGigDescriptionSuperFast.count == 0) {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_GIG_SUPER_DESCRIPTION, aStrMessage: ALERT_EMPTY_FIELD)
        }
            
        else if (myStrWorkOption.count == 0) {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_ALERT_TITLE_WORK_OPTION, aStrMessage: ALERT_EMPTY_FIELD)
        }
        else {
            
            self.httpRequestForCreateGig()
        }
    }
    
    @objc func categoryBtnTapped(sender: UIButton) {
        
        let aViewController = GSChooseLocationViewController()
        aViewController.gIsClickCountry = false
        aViewController.gIsClickLanguage = false
        aViewController.gIsClickProfession = false
        aViewController.gIsClickCategory = true
        aViewController.gStrCountryId = myStrCategoryId
        aViewController.completion = {(professionName,professionId) in
            
            myStrCategoryNameForSell = professionName!
            myStrCategoryId = professionId!
            let aBtnState = self.myTblView.viewWithTag(self.TAG_CATEGORY) as! UIButton
            aBtnState.setTitle(professionName, for: .normal)
            
        }
        
        self.navigationController?.pushViewController(aViewController, animated: true)
    }
    
    @objc func addBtnTapped(sender: UIButton) {
        
        self.view.endEditing(true)
        if myStrGigTitleExtra.count > 0 && myStrGigPriceExtra.count > 0 && myStrGigDeliveryDayExtra.count > 0 && myAryExtrasInfo.count < 10 {
            myDictExtrasInfo = [TITLE:"",PRICE:"",DAYS:""]
            myAryExtrasInfo.append(myDictExtrasInfo)
            myStrGigTitleExtra = ""
            myStrGigPriceExtra = ""
            myStrGigDeliveryDayExtra = ""
            myTblView.reloadData()
        }
    }
    
    @objc func deleteGigsBtnTapped(sender: UIButton) {
        
        if myAryExtrasInfo.count > 1  {
            myAryExtrasInfo.remove(at: sender.tag)
            self .getLastGigsValuesinArray()
            myTblView.reloadData()
        }
    }
    
    @objc func superfastBtnTapped(sender: UIButton) {
        
        let btn = sender
        btn.isSelected = !btn.isSelected
        myStrWorkOption = ""
        if btn.tag == TAG_ONSITE_BUTTON {
            if btn.isSelected {
                myStrWorkOption = "1"
                let cell:GSSuperFastTableViewCell = myTblView.cellForRow(at: IndexPath(row: sender.tag - TAG_ONSITE_BUTTON, section: 2)) as! GSSuperFastTableViewCell
                cell.gBtnRemoteCheck.isSelected = false
            }
        }
        else if btn.tag == TAG_REMOTE_BUTTON {
            if btn.isSelected {
                myStrWorkOption = "0"
                let cell:GSSuperFastTableViewCell = myTblView.cellForRow(at: IndexPath(row: sender.tag - TAG_REMOTE_BUTTON, section: 2)) as! GSSuperFastTableViewCell
                cell.gBtnOnSiteCheck.isSelected = false
            }
        }
        else {
            myStrSuperFastCheck = "No"
            if btn.isSelected {
                myStrSuperFastCheck = "Yes"
                myTblView.reloadData()
            }
//            myTblView.reloadData()
            
        }
    }
    
    @objc func imageBtnTapped(sender: UIButton) {
        
       // isClickImage = true
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
    
    // MARK: - Private functions
    
    func setUpLeftBarBackButton() {
        
        let leftBtn = UIButton(type: .custom)
        leftBtn.setImage(UIImage(named: ICON_BACK), for: .normal)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        leftBtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        
        let leftBarBtnItem = UIBarButtonItem(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftBarBtnItem
    }
    
    @objc func backBtnTapped() {
        
        self.navigationController?.popViewController(animated: true)
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
}

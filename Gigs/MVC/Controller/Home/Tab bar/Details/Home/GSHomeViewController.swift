// 
//  GSHomeViewController.swift
//  Gigs
//
//  Created by dreams on 08/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit
import SDWebImage
import AMScrollingNavbar
import netfox
import GoogleMobileAds


class GSHomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,GADBannerViewDelegate {
    
    @IBOutlet weak var myTblView: UITableView!
    
    var myDictInfo = [String:Any]()
    
    var myAryInfo = [[String:Any]]()
    
    var myStrImageBaseUrl = String()
    var myStrCurrencySign = String()

    let K_TITLE = "title"
    let K_TITLE_BANNER = "Banner"
    let K_TITLE_CATEGORY = "Top Category"
    let K_TITLE_POPULAR_GIGS = "Popular Gigs"
    let K_TITLE_RECENT_GIGS = "Latest Gigs"
    let K_ARRAYINFO = "aryinfo"
    var gStrGigIdHome = ""
    
    let cellHeaderIdentifier = "GSHomeHeaderTableViewCell"
    let cellBannerIdentifier = "GSHomeBannerTableViewCell"
    let cellCategoryIdentifier = "GSCategoryTableViewCell"
    let cellPopularIdentifier = "GSPopularTableViewCell"
    
    let cellBannerCollectionIdentifier = "GSBannerCollectionViewCell"
    let cellPopularCollectionIdentifier = "GSPopularGigsCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpModel()
        loadModel()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.barTintColor = HELPER.hexStringToUIColor(hex: APP_COLOR)
        self.navigationController?.navigationBar.topItem?.title = "Home"
        
        callHomeApi()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        if let navigationController = navigationController as? ScrollingNavigationController {
//            navigationController.followScrollView(myTblView, delay: 50.0)
//        }
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//
//        if let navigationController = navigationController as? ScrollingNavigationController {
//            navigationController.stopFollowingScrollView()
//        }
//    }
//
    func setUpUI() {
        
//        HELPER.setUpLeftBarBackButton(fromVc: self)
//        setUpRightBarEditButton()
        
        NAVIGAION.setNavigationTitle(aStrTitle: "Home", aViewController: self)
//        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = UIImage.sd_animatedGIFNamed("icon_menu")
        
        myTblView.delegate = self
        myTblView.dataSource = self
        
        myTblView.register(UINib.init(nibName: cellBannerIdentifier, bundle: nil), forCellReuseIdentifier: cellBannerIdentifier)
        myTblView.register(UINib.init(nibName: cellHeaderIdentifier, bundle: nil), forCellReuseIdentifier: cellHeaderIdentifier)
        myTblView.register(UINib.init(nibName: cellCategoryIdentifier, bundle: nil), forCellReuseIdentifier: cellCategoryIdentifier)
        myTblView.register(UINib.init(nibName: cellPopularIdentifier, bundle: nil), forCellReuseIdentifier: cellPopularIdentifier)
        
        let dummyViewHeight = CGFloat(40)
        self.myTblView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.myTblView.bounds.size.width, height: dummyViewHeight))
        self.myTblView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0)
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
       // callHomeApi()
        
    }
    
    // MARK: - Table View delegate and datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return myAryInfo.count != 0 ? myAryInfo.count : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let aAryInfo = myAryInfo[section][K_ARRAYINFO] as! [[String:Any]]
        
        return myAryInfo[section][K_TITLE] as? String == K_TITLE_CATEGORY ? aAryInfo.count : 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return myAryInfo[section][K_TITLE] as? String == K_TITLE_BANNER ? 0 : 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var aCell:GSHomeHeaderTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellHeaderIdentifier) as? GSHomeHeaderTableViewCell
        
        aCell?.gBtnViewAll.tag = section
        aCell?.gBtnViewAll.addTarget(self, action: #selector(self.viewAllBtnTapped(sender:)), for: .touchUpInside)
        
        aCell?.backgroundColor = UIColor.clear
        
        if  (aCell == nil) {
            
            let nib:NSArray=Bundle.main.loadNibNamed(cellHeaderIdentifier, owner: self, options: nil)! as NSArray
            aCell = nib.object(at: 0) as? GSHomeHeaderTableViewCell
        }
            
        else {
            
            aCell?.gLblHeader.text = myAryInfo[section][K_TITLE] as? String
        }
        
        aCell?.gLblHeader.text = myAryInfo[section][K_TITLE] as? String
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if myAryInfo[indexPath.section][K_TITLE] as? String == K_TITLE_BANNER {
            
            return 50
        }
            
        else if myAryInfo[indexPath.section][K_TITLE] as? String == K_TITLE_CATEGORY {
            
            return 60
        }
            
        else {
            
            return  250
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if myAryInfo[indexPath.section][K_TITLE] as? String == K_TITLE_CATEGORY {
            
             let aAryCategory = myAryInfo[indexPath.section][K_ARRAYINFO] as! [[String:Any]]
            
            if aAryCategory[indexPath.row]["subcategory"]as? String == "0" {
                
                let aViewcontroller = GSViewAllGigsViewController()
                aViewcontroller.gIsCategoryAll = true
                aViewcontroller.gStrCategoryId = aAryCategory[indexPath.row]["id"] as! String
                aViewcontroller.gStrCategoryName = aAryCategory[indexPath.row]["category"] as! String
                self.navigationController?.pushViewController(aViewcontroller, animated: true)
                
            } else if aAryCategory[indexPath.row]["subcategory"]as? String == "1" {
                
                let aViewcontroller = GSSubCategoryViewController()
                aViewcontroller.gStrCategoryId = aAryCategory[indexPath.row]["id"] as! String
                aViewcontroller.gStrCategoryName = aAryCategory[indexPath.row]["category"] as! String
                aViewcontroller.isfromhome = true
                self.navigationController?.pushViewController(aViewcontroller, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if myAryInfo[indexPath.section][K_TITLE] as? String == K_TITLE_BANNER {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellBannerIdentifier, for: indexPath) as! GSHomeBannerTableViewCell
            
            aCell.gContainerView.adUnitID = "ca-app-pub-6730391055847892/5593245253"
            aCell.gContainerView.rootViewController = self
            aCell.gContainerView.load(GADRequest())
            aCell.gContainerView.delegate = self
            
            return aCell
        }
            
        else if myAryInfo[indexPath.section][K_TITLE] as? String == K_TITLE_CATEGORY {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellCategoryIdentifier, for: indexPath) as! GSCategoryTableViewCell
            
            HELPER.setRoundCornerView(aView: aCell.gImgView)
            aCell.selectionStyle = .none
            
            var aStrSubCategory = String()
            var aArySubCategory = [[String:Any]]()
            
            let aAryCategory = myAryInfo[indexPath.section][K_ARRAYINFO] as! [[String:Any]]
            
            aArySubCategory = aAryCategory[indexPath.row]["sub_category"] as! [[String:Any]]
            
            var aAryJoinSubCategory = [String]()
            
            for index in 0..<aArySubCategory.count {
                
                aAryJoinSubCategory.append(aArySubCategory[index]["name"]! as! String)
            }
            
            if aAryJoinSubCategory.count != 0 {
                
                aStrSubCategory = aAryJoinSubCategory.joined(separator: ", ")
            }
            
            aCell.gLblCategory.text = aAryCategory[indexPath.row]["category"] as? String
            aCell.gLblSubCategory.text = aStrSubCategory
            
            if aArySubCategory.count == 0 {
                
                aCell.gConstraintCategpryTitleBottom.constant = 0
            }
            
            return aCell
        }
            
        else if myAryInfo[indexPath.section][K_TITLE] as? String == K_TITLE_POPULAR_GIGS {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellPopularIdentifier, for: indexPath) as! GSPopularTableViewCell
            
            aCell.gCollectionView.delegate = self
            aCell.gCollectionView.dataSource = self
            aCell.gCollectionView.tag = indexPath.section
            
            aCell.gCollectionView.register(UINib(nibName: cellPopularCollectionIdentifier, bundle: nil), forCellWithReuseIdentifier: cellPopularCollectionIdentifier)
            
            aCell.gCollectionView.reloadData()
            
            return aCell
        }
            
        else {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellPopularIdentifier, for: indexPath) as! GSPopularTableViewCell
            
            aCell.gCollectionView.delegate = self
            aCell.gCollectionView.dataSource = self
            aCell.gCollectionView.tag = indexPath.section
            
            aCell.gCollectionView.register(UINib(nibName: cellPopularCollectionIdentifier, bundle: nil), forCellWithReuseIdentifier: cellPopularCollectionIdentifier)
            
            aCell.gCollectionView.reloadData()

            return aCell
        }
    }
    
    // MARK: - Collection View Delegate and Datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let aAryInfo:[[String:String]] = myAryInfo[collectionView.tag][K_ARRAYINFO] as! [[String : String]]  {
            return aAryInfo.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if myAryInfo[collectionView.tag][K_TITLE] as? String == K_TITLE_BANNER {
            
            let aAryInfo = myAryInfo[collectionView.tag][K_ARRAYINFO] as! [[String:String]]
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellBannerCollectionIdentifier, for: indexPath) as! GSBannerCollectionViewCell
            aCell.gImgView.setShowActivityIndicator(true)
            aCell.gImgView.setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
            
            
            aCell.gImgView.sd_setImage(with: URL(string: myStrImageBaseUrl + aAryInfo[indexPath.row]["image"]!), placeholderImage: nil,options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                
                var ogSize = CGSize()
                
                ogSize.width = aCell.gImgView.frame.size.width
                ogSize.height = aCell.gImgView.frame.size.height

                self.imageByScalingProportionally(sourceImage: image!, targetSize: ogSize, ogImageView: aCell.gImgView)
                
                // Perform operation.
            })
            
            
            
          //  aCell.gImgView.sd_setImage(with: URL(string: myStrImageBaseUrl + aAryInfo[indexPath.row]["image"]!), placeholderImage: nil)
            
            
            return aCell
        }
            
        else if myAryInfo[collectionView.tag][K_TITLE] as? String == K_TITLE_POPULAR_GIGS {
            
            let aAryInfo = myAryInfo[collectionView.tag][K_ARRAYINFO] as! [[String:String]]

            print(aAryInfo)
            
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellPopularCollectionIdentifier, for: indexPath) as! GSPopularGigsCollectionViewCell
            
            //HELPER.setRoundCornerView(aView: aCell.gView, borderRadius: 5)

            HELPER.setCardView(cardView: aCell.gView)
            aCell.gLblPrice.textColor = HELPER.hexStringToUIColor(hex: APP_COLOR)
            aCell.gImgView.setShowActivityIndicator(true)
            aCell.gImgView.setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
           
            aCell.gImgView.sd_setImage(with: URL(string:"http://dreamguys.co.in/thegigs/" + aAryInfo[indexPath.row]["image"]!), placeholderImage: UIImage(named: ICON_PLACEHOLDER_IMAGE))
            //aCell.gImgView.contentMode = .scaleToFill

            
//            aCell.gImgView.sd_setImage(with: URL(string:"http://dreamguys.co.in/gigs/" + aAryInfo[indexPath.row]["image"]!), placeholderImage: nil,options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
//
////                var ogSize = CGSize()
////
////                ogSize.width = aCell.gImgView.frame.size.width
////                ogSize.height = aCell.gImgView.frame.size.height
////
////                self.imageByScalingProportionally(sourceImage: image!, targetSize: ogSize, ogImageView: aCell.gImgView)
////
//                // Perform operation.
//            })
//
            
            aCell.gLblTitle.text = aAryInfo[indexPath.row]["title"]
            
            aCell.gBtnFavourites.isSelected = false
            
            if aAryInfo[indexPath.row]["favourite"] == "1" {
                
                aCell.gBtnFavourites.isSelected = true
            }
            if SESSION.isUserLogIn() {
                aCell.gBtnFavourites.addTarget(self, action: #selector(FavouriteBtnTapped), for: .touchUpInside)
                aCell.gBtnFavourites.row = indexPath.row
                aCell.gBtnFavourites.section = 2
                aCell.gBtnFavourites.isHidden = false
                
                if aAryInfo[indexPath.row]["user_id"] == SESSION.getUserId() {
                    aCell.gBtnFavourites.isHidden = true
                }
            }
            else {
                aCell.gBtnFavourites.isHidden = true
            }
            let yourAttributes = [NSAttributedStringKey.foregroundColor: HELPER.hexStringToUIColor(hex: "EFCE49"), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)]
            let yourOtherAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)]
            
            let partOne = NSMutableAttributedString(string: aAryInfo[indexPath.row]["gig_rating"]!, attributes: yourAttributes)
            let partTwo = NSMutableAttributedString(string: " (" + aAryInfo[indexPath.row]["gig_usercount"]! + ")", attributes: yourOtherAttributes)
            
            let combination = NSMutableAttributedString()
            
            combination.append(partOne)
            combination.append(partTwo)
            
            aCell.gLblReview.attributedText = combination
            
            myStrCurrencySign = aAryInfo[indexPath.row]["currency_sign"]!

            aCell.gLblPrice.text = myStrCurrencySign + aAryInfo[indexPath.row]["gig_price"]!
            
            return aCell
        }
            
        else  {
            
            let aAryInfo = myAryInfo[collectionView.tag][K_ARRAYINFO] as! [[String:String]]
            
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellPopularCollectionIdentifier, for: indexPath) as! GSPopularGigsCollectionViewCell
            
            HELPER.setCardView(cardView: aCell.gView)
            aCell.gLblPrice.textColor = HELPER.hexStringToUIColor(hex: APP_COLOR)
            aCell.gImgView.setShowActivityIndicator(true)
            aCell.gImgView.setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
//            aCell.gImgView.sd_setImage(with: URL(string: myStrImageBaseUrl + aAryInfo[indexPath.row]["image"]!), placeholderImage: nil)
            
            aCell.gImgView.sd_setImage(with: URL(string: myStrImageBaseUrl + aAryInfo[indexPath.row]["image"]!), placeholderImage:
                UIImage(named: ICON_PLACEHOLDER_IMAGE), options: SDWebImageOptions(),
                                                            completed: { (image: UIImage?, error: Error?, cachetype: SDImageCacheType,
                                                                imageURL: URL?) in
            })
            aCell.gLblTitle.text = aAryInfo[indexPath.row]["title"]
            
            let yourAttributes = [NSAttributedStringKey.foregroundColor: HELPER.hexStringToUIColor(hex: "EFCE49"), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)]
            let yourOtherAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)]
            
            let partOne = NSMutableAttributedString(string: aAryInfo[indexPath.row]["gig_rating"]!, attributes: yourAttributes)
            let partTwo = NSMutableAttributedString(string: " (" + aAryInfo[indexPath.row]["gig_usercount"]! + ")", attributes: yourOtherAttributes)

            let combination = NSMutableAttributedString()
            
            combination.append(partOne)
            combination.append(partTwo)
            
            aCell.gBtnFavourites.isSelected = false
            
            if aAryInfo[indexPath.row]["favourite"] == "1" {
                
                aCell.gBtnFavourites.isSelected = true
            }
            if SESSION.isUserLogIn() {
                aCell.gBtnFavourites.addTarget(self, action: #selector(FavouriteBtnTapped), for: .touchUpInside)
                aCell.gBtnFavourites.row = indexPath.row
                aCell.gBtnFavourites.section = 2
                aCell.gBtnFavourites.isHidden = false
                
                if aAryInfo[indexPath.row]["user_id"] == SESSION.getUserId() {
                    aCell.gBtnFavourites.isHidden = true
                }
            }
            else {
                aCell.gBtnFavourites.isHidden = true
            }
            aCell.gBtnFavourites.addTarget(self, action: #selector(FavouriteBtnTapped), for: .touchUpInside)
            aCell.gBtnFavourites.row = indexPath.row
            aCell.gBtnFavourites.section = 3
            
            aCell.gLblReview.attributedText = combination
            
            myStrCurrencySign = aAryInfo[indexPath.row]["currency_sign"]!
            
            aCell.gLblPrice.text = myStrCurrencySign + aAryInfo[indexPath.row]["gig_price"]!
            
            return aCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if myAryInfo[collectionView.tag][K_TITLE] as? String == K_TITLE_BANNER {
            
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
        
        return CGSize(width: 180, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //        let aAryInfo = myAryInfo[collectionView.tag][K_ARRAYINFO] as! [[String:String]]
        //        print(aAryInfo.count)
        //        if indexPath.row == aAryInfo.count {
        
        if myAryInfo[collectionView.tag][K_TITLE] as? String != K_TITLE_BANNER {
            
            let aCell = collectionView.cellForItem(at: indexPath) as? GSPopularGigsCollectionViewCell
            
            HELPER.tapAnimationFor(aView: (aCell?.gView)!, duration: 0.5) {
                
                let aAryInfo = self.myAryInfo[collectionView.tag][self.K_ARRAYINFO] as! [[String:String]]
                
                let aViewController = GSDetailViewController()
                aViewController.gAryHomeInfo = self.myAryInfo
                aViewController.gStrGigId = aAryInfo[indexPath.row]["id"]!
                aViewController.gStrGigName = (aAryInfo[indexPath.row]["title"])!
                aViewController.gStrGigPrice = Float(aAryInfo[indexPath.row]["gig_price"]!)!
                aViewController.gStrCurrencySign = aAryInfo[indexPath.row]["currency_sign"]!
                self.navigationController?.pushViewController(aViewController, animated: true)
            }
        }
    }
    
    //MARK: - GAD Banner Delegate
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        handleAdView(isShowAdView: true)
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        
        handleAdView(isShowAdView: false)
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
    
    func handleAdView(isShowAdView : Bool) {
        
        let index = IndexPath(item: 0, section: 0)
        if let cell:GSHomeBannerTableViewCell = self.myTblView.cellForRow(at: index) as? GSHomeBannerTableViewCell {
        cell.gContainerViewHeight.constant = isShowAdView ? 50 : 0
        }
        
    }
    
    // MARK: - Api Call getHomeInfo
    
    func callHomeApi() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingViewAnimation(viewController: self)
        
        var dictParameters = [String:String]()
        dictParameters[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
        dictParameters[K_USER_ID] = SESSION.getUserId()
        
        HTTPMANAGER.callGetApi(strUrl:WEB_SERVICE_URL + CASE_HOME_GIGS, sucessBlock: {response in
           
            HELPER.hideLoadingAnimation(viewController: self)
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                print(response)
                
                self.myAryInfo = []
                
                self.myDictInfo = response["primary"] as! [String : Any]
                
                self.myStrImageBaseUrl = self.myDictInfo["base_url"] as! String
                
                SESSION.setBaseImageUrl(aStrImageUrl: self.myStrImageBaseUrl)
                
                //Add banner
                
                var aAryBannerInfo = [[String:String]]()
                var aDictBannerInfo = [String:Any]()
                
                aAryBannerInfo = self.myDictInfo["popular_gigs_image"] as! [[String:String]]
                
                aDictBannerInfo[self.K_TITLE] = self.K_TITLE_BANNER
                aDictBannerInfo[self.K_ARRAYINFO] = aAryBannerInfo
                
                self.myAryInfo.append(aDictBannerInfo)
                
                //Add Category
                
                var aAryCategoryInfo = [[String:Any]]()
                var aDictCategoryInfo = [String:Any]()
                
                aAryCategoryInfo = self.myDictInfo["categories"] as! [[String : Any]]
                
                aDictCategoryInfo[self.K_TITLE] = self.K_TITLE_CATEGORY
                aDictCategoryInfo[self.K_ARRAYINFO] = aAryCategoryInfo
                
                self.myAryInfo.append(aDictCategoryInfo)
                
                //Add Popular Gigs
                
                var aAryPopularGigsInfo = [[String:String]]()
                var aDictPopularInfo = [String:Any]()
                
                aAryPopularGigsInfo = self.myDictInfo["popular_gigs_list"] as! [[String:String]]
                
                aDictPopularInfo[self.K_TITLE] = self.K_TITLE_POPULAR_GIGS
                aDictPopularInfo[self.K_ARRAYINFO] = aAryPopularGigsInfo
                
                self.myAryInfo.append(aDictPopularInfo)
                
                //Add Recent Gigs
                
                var aAryRecentGigsInfo = [[String:Any]]()
                var aDictRecentInfo = [String:Any]()
                
                aAryRecentGigsInfo = self.myDictInfo["recent_gigs_list"] as! [[String : Any]]
                
                aDictRecentInfo[self.K_TITLE] = self.K_TITLE_RECENT_GIGS
                aDictRecentInfo[self.K_ARRAYINFO] = aAryRecentGigsInfo
                
                self.myAryInfo.append(aDictRecentInfo)
                
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


    func handleErrorMessageAndLoading()  {
        
        
    }
    
    // MARK: - Button Action
    
    @objc func FavouriteBtnTapped(sender : UIButton) {
        
        let button:MyFavButton = sender as! MyFavButton
        if myAryInfo[button.section!][K_TITLE] as? String != K_TITLE_BANNER {
            
            var aAryInfo = self.myAryInfo[button.section!][self.K_ARRAYINFO] as! [[String:String]]
            self.gStrGigIdHome = aAryInfo[button.row!]["id"]!
            
            var dict = aAryInfo[button.row!]
            let btn = sender

            if dict["favourite"] == "0" {
                
                HELPER.addFavourites(from: self, gigid: self.gStrGigIdHome)
                //var dict = aAryInfo[button.row!]
                
                //dict["favourite"] = "1"
                aAryInfo[button.row!]["favourite"] = "1"
                btn.isSelected = true
                
                self.myAryInfo[button.section!][self.K_ARRAYINFO]  = aAryInfo
            }
            else {
                
                HELPER.removeFavourites(from: self, gigid: self.gStrGigIdHome)
                
                //var dict = aAryInfo[button.row!]
                //dict["favourite"] = "0"
                aAryInfo[button.row!]["favourite"] = "0"
                btn.isSelected = false
                
                self.myAryInfo[button.section!][self.K_ARRAYINFO]  = aAryInfo
            }
        }
    }
    
    @objc func viewAllBtnTapped(sender: UIButton) {
        
        if myAryInfo[sender.tag][K_TITLE] as? String == K_TITLE_CATEGORY {
            
            let aViewcontroller = GSCategoryViewController()
            self.navigationController?.pushViewController(aViewcontroller, animated: true)
        }
        else {
            
            let aViewcontroller = GSViewAllGigsViewController()
            aViewcontroller.gIsViewAll = true
            self.navigationController?.pushViewController(aViewcontroller, animated: true)
        }
    }
    
//    func setUpRightBarEditButton() {
//
//        var editimage = UIImage(named: "menu_icon_tick")
//        editimage = editimage?.withRenderingMode(.alwaysOriginal)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: editimage, style:.plain, target: self, action: #selector(editBarBtnTapped))
//    }
    
    
    
//    @objc func editBarBtnTapped() {
//
//        let aViewController = GSDetailViewController()
//
//        let aNavi = UINavigationController(rootViewController: aViewController)
//        self.present(aNavi, animated: true, completion: nil)
//    }
    func imageByScalingProportionally(sourceImage:UIImage, targetSize: CGSize , ogImageView:UIImageView) {
        
        var newImage: UIImage? = nil
        let imageSize: CGSize? = sourceImage.size
        let width: CGFloat? = imageSize?.width
        let height: CGFloat? = imageSize?.height
        let targetWidth: CGFloat = targetSize.width
        let targetHeight: CGFloat = targetSize.height
        var scaleFactor: CGFloat = 0.0
        var scaledWidth: CGFloat = targetWidth
        var scaledHeight: CGFloat = targetHeight
        var thumbnailPoint = CGPoint(x: 0.0, y: 0.0)
        if imageSize?.equalTo(targetSize) == false {
            let widthFactor: CGFloat = targetWidth / (width ?? 0.0)
            let heightFactor: CGFloat = targetHeight / (height ?? 0.0)
            if widthFactor < heightFactor {
                scaleFactor = widthFactor
            } else {
                scaleFactor = heightFactor
            }
            scaledWidth = (width ?? 0.0) * scaleFactor
            scaledHeight = (height ?? 0.0) * scaleFactor
            if widthFactor < heightFactor {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
            } else if widthFactor > heightFactor {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
            }
        }
        UIGraphicsBeginImageContext(targetSize)
        var thumbnailRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaledWidth
        thumbnailRect.size.height = scaledHeight
        sourceImage.draw(in: thumbnailRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if newImage == nil {
            print("could not scale image")
        }
        
        ogImageView.image = newImage
        //return newImage
    }
}


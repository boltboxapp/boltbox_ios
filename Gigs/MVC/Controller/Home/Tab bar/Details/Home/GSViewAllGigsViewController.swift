//
//  GSViewAllGigsViewController.swift
//  Gigs
//
//  Created by dreams on 11/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSViewAllGigsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var myContainerView: UIView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    let cellPopularCollectionIdentifier = "GSPopularGigsCollectionViewCell"
    
    var myAryInfo = [[String:Any?]]()
    
    var gStrCategoryId = String()
    var gStrCategoryName = String()
    var gStrGigIdViewAllGigs = String()
    var myStrCurrencySign = String()

    var gIsViewAll:Bool!
    var gIsCategoryAll:Bool!
    var gIsFavourites:Bool!
    var gIsLastVisited:Bool!
    var gIsMyGigs:Bool!
    var gIsSearchGigs:Bool!
    var gIsSimilarGigs:Bool!

    var isLazyLoading:Bool!
    var isLoadMoreStart:Bool!
    
    var myIntTotalPage = Int()
    var myStrPagewNumber = "1"
    var myIntPagewNumber:Int = 1

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
        
        if gIsCategoryAll == true {
            
            callCategoryAllApi()
        }
        else if gIsViewAll == true {
            
            callViewAllApi()
        }
        else if gIsFavourites == true {
            
            NAVIGAION.setNavigationTitle(aStrTitle: "Favourties", aViewController: self)
            callFavouritesApi()
            setUpLeftBarButton()
        }
        else if gIsLastVisited == true {
            
            NAVIGAION.setNavigationTitle(aStrTitle: "Last Visited Gigs", aViewController: self)
            callLastVisitedGigsApi()
            setUpLeftBarButton()
        }
        else if gIsMyGigs == true {
            
            NAVIGAION.setNavigationTitle(aStrTitle: "My Gigs", aViewController: self)
            callMyGigsApi()
            setUpLeftBarButton()
        }
        else if gIsSearchGigs == true {
            NAVIGAION.setNavigationTitle(aStrTitle: "Search Gigs", aViewController: self)
            setUpLeftBarButton()
        }
        else if gIsSimilarGigs == true {
            
            NAVIGAION.setNavigationTitle(aStrTitle: "Similar Gigs", aViewController: self)
            callSimilarGigs()
            setUpLeftBarBackButton()
        }
    }
    
    func setUpUI() {
        
        if gIsCategoryAll == true {
            
            NAVIGAION.setNavigationTitle(aStrTitle: gStrCategoryName, aViewController: self)
        }
        else {
            
            NAVIGAION.setNavigationTitle(aStrTitle: "Gigs", aViewController: self)
        }
        
        setUpLeftBarBackButton()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        myCollectionView.register(UINib(nibName: cellPopularCollectionIdentifier, bundle: nil), forCellWithReuseIdentifier: cellPopularCollectionIdentifier)
    }
    
    func setUpModel() {
        
        isLazyLoading = true
    }
    
    func loadModel() {
        
        if gIsCategoryAll == true {
            
            callCategoryAllApi()
        }
        else if gIsViewAll == true {
            
            callViewAllApi()
        }
        else if gIsFavourites == true {
            
            NAVIGAION.setNavigationTitle(aStrTitle: "Favourties", aViewController: self)
            callFavouritesApi()
            setUpLeftBarButton()
        }
        else if gIsLastVisited == true {
            
            NAVIGAION.setNavigationTitle(aStrTitle: "Last Visited Gigs", aViewController: self)
            callLastVisitedGigsApi()
            setUpLeftBarButton()
        }
        else if gIsMyGigs == true {
            
            NAVIGAION.setNavigationTitle(aStrTitle: "My Gigs", aViewController: self)
            callMyGigsApi()
            setUpLeftBarButton()
        }
        else if gIsSearchGigs == true {
            NAVIGAION.setNavigationTitle(aStrTitle: "Search Gigs", aViewController: self)
            setUpLeftBarButton()
        }
        else if gIsSimilarGigs == true {
            
            NAVIGAION.setNavigationTitle(aStrTitle: "Similar Gigs", aViewController: self)
            callSimilarGigs()
            setUpLeftBarBackButton()
        }
    }
    
    // MARK: - Collection view delegate and datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        return myAryInfo.count + (isLazyLoading ? 1 : 0)
        
        return myAryInfo.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellPopularCollectionIdentifier, for: indexPath) as! GSPopularGigsCollectionViewCell
        
        HELPER.setCardView(cardView: aCell.gView)
        
        aCell.gLblPrice.textColor = HELPER.hexStringToUIColor(hex: APP_COLOR)
        aCell.gImgView.setShowActivityIndicator(true)
        aCell.gImgView.setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
        
        if let value = myAryInfo[indexPath.row]["image"] as? String {
            
            let imageStr:String = value
            aCell.gImgView.sd_setImage(with: URL(string: SESSION.getBaseImageUrl() + imageStr), placeholderImage: nil)
        }
        
        aCell.gLblTitle.text = myAryInfo[indexPath.row]["title"] as? String
        
        let yourAttributes = [NSAttributedStringKey.foregroundColor: HELPER.hexStringToUIColor(hex: "EFCE49"), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)]
        let yourOtherAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)]
        
        let partOne = NSMutableAttributedString(string: myAryInfo[indexPath.row]["gig_rating"]! as! String , attributes: yourAttributes)
        
        let usercountStr:String = myAryInfo[indexPath.row]["gig_usercount"]! as! String

        let partTwo = NSMutableAttributedString(string: " (" + usercountStr + ")", attributes: yourOtherAttributes)
        
        let combination = NSMutableAttributedString()
        
        combination.append(partOne)
        combination.append(partTwo)
        
        aCell.gBtnFavourites.isSelected = false
        
        let favouriteStr:String = myAryInfo[indexPath.row]["favourite"] as! String
        
        if favouriteStr == "1" {
            
            aCell.gBtnFavourites.isSelected = true
        }
        if SESSION.isUserLogIn() {
            aCell.gBtnFavourites.addTarget(self, action: #selector(FavouriteBtnTapped), for: .touchUpInside)
            aCell.gBtnFavourites.row = indexPath.row
            aCell.gBtnFavourites.section = 2
            aCell.gBtnFavourites.isHidden = false
            
            let strUserId:String = myAryInfo[indexPath.row]["user_id"] as! String
            
            if strUserId == SESSION.getUserId() {
                aCell.gBtnFavourites.isHidden = true
            }
        }
        else {
            aCell.gBtnFavourites.isHidden = true
        }
        
        aCell.gBtnFavourites.addTarget(self, action: #selector(FavouriteBtnTapped), for: .touchUpInside)
        aCell.gBtnFavourites.row = indexPath.row
        
        aCell.gLblReview.attributedText = combination
        
        myStrCurrencySign = myAryInfo[indexPath.row]["currency_sign"]! as! String
        
        let gigPriceStr:String = myAryInfo[indexPath.row]["gig_price"]! as! String
        
        aCell.gLblPrice.text = myStrCurrencySign + gigPriceStr
        
        return aCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width / 2, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let aCell = collectionView.cellForItem(at: indexPath) as? GSPopularGigsCollectionViewCell

        HELPER.tapAnimationFor(aView: (aCell?.gView)!, duration: 0.5) {
            
            let aViewController = GSDetailViewController()
            aViewController.gAryHomeInfo = self.myAryInfo
            aViewController.gStrGigId = self.myAryInfo[indexPath.row]["id"]! as! String
            aViewController.gStrGigName = (self.myAryInfo[indexPath.row]["title"])! as! String
            aViewController.gStrGigPrice = Float(self.myAryInfo[indexPath.row]["gig_price"]! as! String)!
            aViewController.gStrCurrencySign = self.myAryInfo[indexPath.row]["currency_sign"]! as! String
            self.navigationController?.pushViewController(aViewController, animated: true)
        }
    }
    
    // MARK: - Scroll view delegate and data source

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let contentOffsetMaxY: Float = Float(scrollView.contentOffset.y + scrollView.bounds.size.height)
        let contentHeight: Float = Float(scrollView.contentSize.height)

        let ret = contentOffsetMaxY > contentHeight
        if ret {
            print("testButton is show");

            if isLazyLoading {
                isLazyLoading = false
                loadMore()
            }

        }else{
            print("testButton is hidden");
        }
    }

    func loadMore() {
        
//        callFavouritesApi()

//        if gIsCategoryAll == true {
//
//            callCategoryAllApi()
//        }
//        else if gIsViewAll == true {
//
//            callViewAllApi()
//        }
//        else if gIsFavourites == true {
//
//            callFavouritesApi()
//        }
//        else if gIsLastVisited == true {
//
//            callLastVisitedGigsApi()
//        }
//        else if gIsMyGigs == true {
//
//            callMyGigsApi()
//        }
//        else if gIsSimilarGigs == true {
        
//            callSimilarGigs()
//        }
    }
    
  // MARK: - Api Call
    func callViewAllApi() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingViewAnimation(viewController: self)
        
        var dictParameters = [String:String]()
        //dictParameters[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
        dictParameters[kDEVICE_VIEWALL] = kDEVICE_VIEWALL_SERVICES
        //dictParameters[K_USER_ID] = SESSION.getUserId()
        
//        HTTPMANAGER.getViewAllInfo(sucessblock: {response in
        
            HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_HOME_VIEWALL_GIGS, dictParameters: dictParameters, sucessBlock: { (response) in

            HELPER.hideLoadingAnimation(viewController: self)
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                self.myAryInfo = response["data"] as! [[String:Any]]
                
                self.myCollectionView.reloadData()
                
            }
            else {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation(viewController: self)
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    // View All Category Gigs
    func callCategoryAllApi() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingViewAnimation(viewController: self)
        
        var dictParameters = [String:String]()
        //dictParameters[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
        dictParameters[kDEVICE_VIEWALL] = kDEVICE_VIEWALL_SERVICES
        //dictParameters[K_USER_ID] = "1"
        dictParameters[kDEVICE_CATEGORY_iD] = gStrCategoryId
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_HOME_VIEWALL_GIGS, dictParameters: dictParameters, sucessBlock: { (response) in
        
//        HTTPMANAGER.getCategoryAllInfo(categoryId: gStrCategoryId, isFromBuy: false, sucessblock: {response in
        
            HELPER.hideLoadingAnimation(viewController: self)
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {

                self.myAryInfo = response["data"] as! [[String:Any]]

                self.myCollectionView.reloadData()

            }
            
//            if aIntResponseCode == RESPONSE_CODE_200 {
//
//                self.myIntTotalPage = response["total_pages"] as! Int
//
//                if self.myIntTotalPage == 0 {
//
//                    self.isLazyLoading = false
//                }
//
//                else {
//
//                    self.isLazyLoading = self.myIntTotalPage == self.myIntPagewNumber ? false : true
//
//                    self.myIntPagewNumber = self.myIntPagewNumber + 1
//                    self.myStrPagewNumber = String(describing: self.myIntPagewNumber)
//
//                    if self.myAryInfo.count == 0 {
//
//                        self.myAryInfo = response["data"] as! [[String : String]]
//                        self.myCollectionView.reloadData()
//                    }
//                    else {
//
//                        for dictInfo in response["data"] as! [[String : String]] {
//                            self.myAryInfo.append(dictInfo)
//                        }
//                    }
//                }
//            }
            else {
                
                if self.myAryInfo.count == 0 {
                    
                    HELPER.showNoDataWithRetryAlert(viewController: self, alertMessage: ALERT_NO_RECORDS_FOUND, retryBlock: {
                        
                        self.callCategoryAllApi()
                    })
                }
                    
                else {
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
                }
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation(viewController: self)
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
   
    //Favourites
    func callFavouritesApi() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingViewAnimation(viewController: self)
        
        var dictParameters = [String:String]()
        dictParameters[K_USER_ID] = SESSION.getUserId()
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_HOME_FAVOURTIES_GIGS, dictParameters: dictParameters, sucessBlock: { (response) in
            
            //        HTTPMANAGER.getFavouritesGigsInfo(sucessblock: {response in
            
            HELPER.hideLoadingAnimation(viewController: self)
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                self.myAryInfo = response["data"] as! [[String:Any]]
                self.myCollectionView.reloadData()
                
            }
                
                //            if aIntResponseCode == RESPONSE_CODE_200 {
                //
                //                self.myIntTotalPage = response["total_pages"] as! Int
                //
                //                if self.myIntTotalPage == 0 {
                //
                //                    self.isLazyLoading = false
                //                }
                //
                //                else {
                //
                //                    self.isLazyLoading = self.myIntTotalPage == self.myIntPagewNumber ? false : true
                //
                //                    self.myIntPagewNumber = self.myIntPagewNumber + 1
                //                    self.myStrPagewNumber = String(describing: self.myIntPagewNumber)
                //
                //                    if self.myAryInfo.count == 0 {
                //
                //                        self.myAryInfo = response["data"] as! [[String : String]]
                //                        self.myCollectionView.reloadData()
                //                    }
                //                    else {
                //
                //                        for dictInfo in response["data"] as! [[String : String]] {
                //                            self.myAryInfo.append(dictInfo)
                //                        }
                //                    }
                //                }
                //            }
                
            else {
                
                HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse, okActionBlock: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation(viewController: self)
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    //Last Visited Gigs
    func callLastVisitedGigsApi() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        var dictParameters = [String:String]()
        dictParameters[K_USER_ID] = SESSION.getUserId()
//        dictParameters[K_DEVICE_TYPE] = "iOS"
//        dictParameters["page"] = myStrPagewNumber

        HELPER.showLoadingViewAnimation(viewController: self)
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_HOME_LAST_VISITED_GIGS, dictParameters: dictParameters, sucessBlock: { (response) in
            
//        HTTPMANAGER.getLastVisitedGigsInfo(parameter: dictParameters,sucessblock: {response in
            
            HELPER.hideLoadingAnimation(viewController: self)
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {

                self.myAryInfo = response["data"] as! [[String:String]]
                self.myCollectionView.reloadData()

            }
            
//            if aIntResponseCode == RESPONSE_CODE_200 {
//
//                self.myIntTotalPage = response["total_pages"] as! Int
//
//                if self.myIntTotalPage == 0 {
//
//                    self.isLazyLoading = false
//                }
//
//                else {
//
//                    self.isLazyLoading = self.myIntTotalPage == self.myIntPagewNumber ? false : true
//
//                    self.myIntPagewNumber = self.myIntPagewNumber + 1
//                    self.myStrPagewNumber = String(describing: self.myIntPagewNumber)
//
//                    if self.myAryInfo.count == 0 {
//
//                        self.myAryInfo = response["data"] as! [[String : String]]
//                        self.myCollectionView.reloadData()
//                    }
//                    else {
//
//                        for dictInfo in response["data"] as! [[String : String]] {
//                            self.myAryInfo.append(dictInfo)
//                        }
//                    }
//                }
//            }
                
            else {
                
                HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse, okActionBlock: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation(viewController: self)
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    //My Gigs
    func callMyGigsApi() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingViewAnimation(viewController: self)
        
        HTTPMANAGER.callGetApi(strUrl:WEB_SERVICE_URL + CASE_HOME_MY_GIGS, sucessBlock: {response in

//        HTTPMANAGER.getMyGigsInfo(sucessblock: {response in
            
            HELPER.hideLoadingAnimation(viewController: self)
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {

                self.myAryInfo = response["data"] as! [[String:String]]
                self.myCollectionView.reloadData()

            }
//            if aIntResponseCode == RESPONSE_CODE_200 {
//
//                self.myIntTotalPage = response["total_pages"] as! Int
//
//                if self.myIntTotalPage == 0 {
//
//                    self.isLazyLoading = false
//                }
//
//                else {
//
//                    self.isLazyLoading = self.myIntTotalPage == self.myIntPagewNumber ? false : true
//
//                    self.myIntPagewNumber = self.myIntPagewNumber + 1
//                    self.myStrPagewNumber = String(describing: self.myIntPagewNumber)
//
//                    if self.myAryInfo.count == 0 {
//
//                        self.myAryInfo = response["data"] as! [[String : String]]
//                        self.myCollectionView.reloadData()
//                    }
//                    else {
//
//                        for dictInfo in response["data"] as! [[String : String]] {
//                            self.myAryInfo.append(dictInfo)
//                        }
//                    }
//                }
//            }
            else {
                
                HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse, okActionBlock: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
                
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation(viewController: self)
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    // All similar gigs
    func callSimilarGigs() {
        
        var dictParameters = [String:String]()
        //dictParameters[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
        dictParameters[kDEVICE_TITLE] = ""
        dictParameters[kDEVICE_STATE] = ""
        dictParameters[kDEVICE_COUNTRY] = ""
        dictParameters[kDEVICE_CATEGORY_iD] = gStrCategoryId
//        dictParameters["page"] = myStrPagewNumber

        print(dictParameters)
        
        HELPER.showLoadingViewAnimation(viewController: self)

        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_HOME_SEARCH, dictParameters: dictParameters, sucessBlock: { (response) in

//        HTTPMANAGER.getSearchInfo(parameter: dictParameters, sucessblock: {response in
        
            HELPER.hideLoadingAnimation(viewController: self)

            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {

                self.myAryInfo = response["data"] as! [[String:Any?]]
                self.myCollectionView.reloadData()
            }
//            if aIntResponseCode == RESPONSE_CODE_200 {
//
//                self.myIntTotalPage = response["total_pages"] as! Int
//
//                if self.myIntTotalPage == 0 {
//
//                    self.isLazyLoading = false
//                }
//
//                else {
//
//                    self.isLazyLoading = self.myIntTotalPage == self.myIntPagewNumber ? false : true
//
//                    self.myIntPagewNumber = self.myIntPagewNumber + 1
//                    self.myStrPagewNumber = String(describing: self.myIntPagewNumber)
//
//                    if self.myAryInfo.count == 0 {
//
//                        self.myAryInfo = response["data"] as! [[String : String]]
//                        self.myCollectionView.reloadData()
//                    }
//                    else {
//
//                        for dictInfo in response["data"] as! [[String : String]] {
//                            self.myAryInfo.append(dictInfo)
//                        }
//                    }
//                }
//            }
            else {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation(viewController: self)
            HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
     // MARK: - Button Action
    
    @objc func FavouriteBtnTapped(sender : UIButton) {
        
        let button:MyFavButton = sender as! MyFavButton
        
        self.gStrGigIdViewAllGigs = self.myAryInfo[button.row!]["id"]! as! String
            
            let btn = sender
            btn.isSelected = !btn.isSelected
            if btn.isSelected {
                HELPER.addFavourites(from: self, gigid: self.gStrGigIdViewAllGigs)
            }
            else {
                HELPER.removeFavourites(from: self, gigid: self.gStrGigIdViewAllGigs)
            }
    }
    
    
    // MARK: - Left Bar Button Methods
    
    func setUpLeftBarBackButton() {
        
        let leftBtn = UIButton(type: .custom)
        leftBtn.setImage(UIImage(named: ICON_BACK), for: .normal)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        leftBtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        
        let leftBarBtnItem = UIBarButtonItem(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftBarBtnItem
    }
    @objc func backBtnTapped() {
        
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
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

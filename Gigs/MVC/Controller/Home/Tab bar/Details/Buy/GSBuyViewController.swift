//
//  GSBuyViewController.swift
//  Gigs
//
//  Created by dreams on 08/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSBuyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    let cellPopularCollectionIdentifier = "GSPopularGigsCollectionViewCell"
    
    var myAryInfo = [[String:Any?]]()
    
    var aStrUserId = String()
    var myStrCurrencySign = String()
    var gStrGigIdViewAllGigs = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpUI()
        setUpModel()
        loadModel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.topItem?.title = SCREEN_TITLE_BUY
        callViewBuyApi()
    }
    
    //MARK: - View Initialize
    
    func setUpUI() {
        
        NAVIGAION.setNavigationTitle(aStrTitle: SCREEN_TITLE_BUY, aViewController: self)
//        self.navigationController?.navigationBar.topItem?.title = SCREEN_TITLE_BUY
        setUpLeftBarBackButton()
        myCollectionView.register(UINib(nibName: cellPopularCollectionIdentifier, bundle: nil), forCellWithReuseIdentifier: cellPopularCollectionIdentifier)
        aStrUserId = SESSION.getUserId()
        print(aStrUserId)
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
       // callViewBuyApi()
    }
    
    // MARK: - Collection view delegate and datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return myAryInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellPopularCollectionIdentifier, for: indexPath) as! GSPopularGigsCollectionViewCell
        
        HELPER.setCardView(cardView: aCell.gView)
        
        aCell.gLblPrice.textColor = HELPER.hexStringToUIColor(hex: APP_COLOR)
        aCell.gImgView.setShowActivityIndicator(true)
        aCell.gImgView.setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
        let img:String = myAryInfo[indexPath.row]["image"] as? String ?? ""
        aCell.gImgView.sd_setImage(with: URL(string: SESSION.getBaseImageUrl() + img), placeholderImage: nil)
        
        aCell.gLblTitle.text = myAryInfo[indexPath.row]["title"] as? String ?? ""
        
        let yourAttributes = [NSAttributedStringKey.foregroundColor: HELPER.hexStringToUIColor(hex: "EFCE49"), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)]
        let yourOtherAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)]
        
        let gigRating:String = myAryInfo[indexPath.row]["gig_rating"] as? String ?? ""
        let userCount:String = myAryInfo[indexPath.row]["gig_usercount"] as? String ?? ""
        let partOne = NSMutableAttributedString(string: gigRating , attributes: yourAttributes)
        let partTwo = NSMutableAttributedString(string: " (" + userCount + ")", attributes: yourOtherAttributes)
        
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
            aViewController.gStrGigId = self.myAryInfo[indexPath.row]["id"] as? String ?? ""
            aViewController.gStrGigName = (self.myAryInfo[indexPath.row]["title"]) as? String ?? ""
            aViewController.gStrGigPrice = Float(self.myAryInfo[indexPath.row]["gig_price"] as? String ?? "")!
            self.navigationController?.pushViewController(aViewController, animated: true)
        }
    }
    
    
    // MARK: - Api Call View All Request
    
    func callViewBuyApi() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingViewAnimation(viewController: self)
        
        var dictParameters = [String:String]()
        //dictParameters[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
        dictParameters[kDEVICE_VIEWALL] = kDEVICE_VIEWALL_SERVICES
        //dictParameters[K_USER_ID] = "1"
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_HOME_VIEWALL_GIGS, dictParameters: dictParameters, sucessBlock: { (response) in
        
//        HTTPMANAGER.getCategoryAllInfo(categoryId: aStrUserId, isFromBuy: true, sucessblock: {response in
            
            HELPER.hideLoadingAnimation(viewController: self)
            
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
//                print(response["data"] as! [[String:String]])
                self.myAryInfo = response["data"] as! [[String:Any?]]
                
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
    
    
    // MARK:- Left Bar Button Methods
    
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
    
    // MARK:- Button action
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

}

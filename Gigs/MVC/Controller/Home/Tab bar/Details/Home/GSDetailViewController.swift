//
//  GSDetailViewController.swift
//  Gigs
//
//  Created by chandru on 11/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit
import SDWebImage
import AARatingBar

class GSDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var myTbView: UITableView!
    @IBOutlet weak var myBtnOrder: UIButton!
    
    let cellBannerIdentifier = "GSTopBannerTableViewCell"
    let cellUserDetailsIdentifier = "GSUserDetailsTableViewCell"
    let cellUserDescriptionIdentifier = "GSUserDescriptionTableViewCell"
    let cellUserInfoIdentifier = "GSUserInfoTableViewCell"
    let cellUserReviewIdentifier = "GSUserReviewsTableViewCell"
    let cellExtrasIdentifier = "GSExtrasTableViewCell"
    let cellPopularIdentifier = "GSPopularTableViewCell"
    let cellHeaderIdentifier = "GSHomeHeaderTableViewCell"
    
    let cellTopBannerIdentifier = "GSTopBannerCollectionViewCell"
    let cellPopularCollectionIdentifier = "GSPopularGigsCollectionViewCell"

    let K_TITLE = "title"
    let K_TITLE_BANNER = "Banner"
    let K_TITLE_PROFILE = "Profile"
    let K_TITLE_DESCRIPTION = "Description"
    let K_TITLE_USER_INFO = "User Information"
    let K_TITLE_EXTRA_GIGS = "Extra Gigs"
    let K_TITLE_SIMILAR_GIGS = "Similar Gigs"
    let K_TITLE_REVIEWS = "Reviews"

    let K_TITLE_CATEGORY = "Top Category"
    let K_TITLE_POPULAR_GIGS = "Popular Gigs"
    let K_TITLE_RECENT_GIGS = "Recent Gigs"
    let K_ARRAYINFO = "aryinfo"
    
    var myAryInfo = [[String:Any]]()
    var gAryHomeInfo = [[String:Any]]()
    
    var gAryReviewInfo = [[String:Any]]()
    var myAryCartInfo = [[String:Any]]()
    
    var gStrUserId = String()
    var gStrGigId = String()
    var gStrGigName = String()
    var gStrGigPrice = Float()
    var gStrGigIdHome = String()
    var gStrCurrencySign = String()
    var gStrGigOriginalPrice = String()
    var useridFromList = String()
    var myStrCategoryId = String()

    var myStrCurrencySign = String()

    var myStrIsFavourite = String()
    var myIntIsFavourite = Int()

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
    
//        override func viewWillAppear(_ animated: Bool) {
//            super.viewWillAppear(animated)
//
//            if let navigationController = navigationController as? ScrollingNavigationController {
//                navigationController.followScrollView(myTbView, delay: 50.0)
//            }
//        }
//
//        override func viewDidDisappear(_ animated: Bool) {
//            super.viewDidDisappear(animated)
//
//            if let navigationController = navigationController as? ScrollingNavigationController {
//                navigationController.stopFollowingScrollView()
//            }
//        }
    

    func setUpUI() {
        
        setUpLeftBarBackButton()
        
        NAVIGAION.setNavigationTitle(aStrTitle: gStrGigName, aViewController: self)
        
        self.navigationController?.navigationBar.topItem?.title = "Gigs"
        
        myTbView.delegate = self
        myTbView.dataSource = self
        
        myTbView.register(UINib.init(nibName: cellBannerIdentifier, bundle: nil), forCellReuseIdentifier: cellBannerIdentifier)
        myTbView.register(UINib.init(nibName: cellUserDetailsIdentifier, bundle: nil), forCellReuseIdentifier: cellUserDetailsIdentifier)
        myTbView.register(UINib.init(nibName: cellUserDescriptionIdentifier, bundle: nil), forCellReuseIdentifier: cellUserDescriptionIdentifier)
        myTbView.register(UINib.init(nibName: cellUserInfoIdentifier, bundle: nil), forCellReuseIdentifier: cellUserInfoIdentifier)
        myTbView.register(UINib.init(nibName: cellUserReviewIdentifier, bundle: nil), forCellReuseIdentifier: cellUserReviewIdentifier)
        myTbView.register(UINib.init(nibName: cellExtrasIdentifier, bundle: nil), forCellReuseIdentifier: cellExtrasIdentifier)
        myTbView.register(UINib.init(nibName: cellPopularIdentifier, bundle: nil), forCellReuseIdentifier: cellPopularIdentifier)
        
//        myBtnOrder.addTarget(self, action: #selector(editBtnTapped), for: .touchUpInside)
        
        myTbView.estimatedRowHeight = UITableViewAutomaticDimension
        
        let dummyViewHeight = CGFloat(40)
        self.myTbView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.myTbView.bounds.size.width, height: dummyViewHeight))
        self.myTbView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0)
        
//        myBtnOrder.addTarget(self, action: #selector(self.orderBtnTapped(sender:)), for: .touchUpInside)
        
        gStrGigOriginalPrice = String(gStrGigPrice)
      
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
        callDetailApi()
        
    }

    
    // MARK: - Table view delegate and data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
    
        return myAryInfo.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if myAryInfo[section][K_TITLE] as? String == K_TITLE_BANNER || myAryInfo[section][K_TITLE] as? String == K_TITLE_DESCRIPTION || myAryInfo[section][K_TITLE] as? String == K_TITLE_SIMILAR_GIGS {
            
            return 1
        }
            
        else  {
            
            print(myAryInfo[section][K_ARRAYINFO] ?? "check")
            
            let aAryInfo = myAryInfo[section][K_ARRAYINFO] as! [[String:Any]]
            
            return aAryInfo.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if myAryInfo[section][K_TITLE] as? String == K_TITLE_REVIEWS {
            
            let aAryInfo = myAryInfo[section][K_ARRAYINFO] as! [[String:Any]]

            if aAryInfo.count == 0 {
                
                return 0
            }
        }
        else if myAryInfo[section][K_TITLE] as? String == K_TITLE_EXTRA_GIGS {
            
            let aAryInfo = myAryInfo[section][K_ARRAYINFO] as! [[String:Any]]
            
            if aAryInfo.count == 0 {
                
                return 0
            }
        }
        
        return myAryInfo[section][K_TITLE] as? String == K_TITLE_BANNER  || myAryInfo[section][K_TITLE] as? String == K_TITLE_PROFILE ? 0 : 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var aCell:GSHomeHeaderTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellHeaderIdentifier) as? GSHomeHeaderTableViewCell
        
        aCell?.gBtnViewAll.isEnabled = true
        aCell?.gBtnViewAll.tag = section
        aCell?.gBtnViewAll.addTarget(self, action: #selector(self.viewSimilarBtnTapped(sender:)), for: .touchUpInside)
        
        aCell?.backgroundColor = UIColor.clear
        
        if  (aCell == nil) {
            
            let nib:NSArray=Bundle.main.loadNibNamed(cellHeaderIdentifier, owner: self, options: nil)! as NSArray
            aCell = nib.object(at: 0) as? GSHomeHeaderTableViewCell
        }
        else {
            
            aCell?.gLblHeader.text = myAryInfo[section][K_TITLE] as? String
        }
        
        if myAryInfo[section][K_TITLE] as? String == K_TITLE_DESCRIPTION {
            
            aCell?.gBtnViewAll.isHidden = true
        }
        else if myAryInfo[section][K_TITLE] as? String == K_TITLE_USER_INFO {
            
            aCell?.gBtnViewAll.isHidden = true
        }
        else if myAryInfo[section][K_TITLE] as? String == K_TITLE_EXTRA_GIGS {

            aCell?.gBtnViewAll.isHidden = true
        }
        else if myAryInfo[section][K_TITLE] as? String == K_TITLE_REVIEWS {
            
            let aAryInfo = myAryInfo[section][K_ARRAYINFO] as! [[String:String]]

            if SESSION.isUserLogIn() {
                
                if aAryInfo.count > 0 {
                    
                    aCell?.gBtnViewAll.isHidden = false
                    aCell?.gBtnViewAll.addTarget(self, action: #selector(self.viewReviewBtnTapped(sender:)), for: .touchUpInside)
                }
                else{
                    
                    aCell?.gBtnViewAll.isHidden = true
                }
            }
            else {
                aCell?.gBtnViewAll.isHidden = true
            }
        }
        else if myAryInfo[section][K_TITLE] as? String == K_TITLE_SIMILAR_GIGS {
            
            let aAryInfo = myAryInfo[section][K_ARRAYINFO] as! [[String:String]]
            
            if SESSION.isUserLogIn() {
                
                if aAryInfo.count > 0 {
                    
                    aCell?.gBtnViewAll.isHidden = false
                    aCell?.gBtnViewAll.addTarget(self, action: #selector(self.viewSimilarBtnTapped(sender:)), for: .touchUpInside)
                }
                else{
                    
                    aCell?.gBtnViewAll.isHidden = true
                }
            }
            else {
                aCell?.gBtnViewAll.isHidden = true
            }
        }
        else {
            
            aCell?.gBtnViewAll.isHidden = false
        }
        
        aCell?.gLblHeader.text = myAryInfo[section][K_TITLE] as? String
        
        return aCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if myAryInfo[indexPath.section][K_TITLE] as? String == K_TITLE_BANNER {
            
            return 180
        }
        else if myAryInfo[indexPath.section][K_TITLE] as? String == K_TITLE_PROFILE {
            
            return 70
        }
        else if myAryInfo[indexPath.section][K_TITLE] as? String == K_TITLE_DESCRIPTION {
            
            return UITableViewAutomaticDimension
        }
        else if myAryInfo[indexPath.section][K_TITLE] as? String == K_TITLE_USER_INFO {
            
            return 160
        }
        else if myAryInfo[indexPath.section][K_TITLE] as? String == K_TITLE_EXTRA_GIGS {
            
            return 45
        }
        else if myAryInfo[indexPath.section][K_TITLE] as? String == K_TITLE_REVIEWS {
            
            return 70
        }
        else  {
            
            let aAryInfo = myAryInfo[indexPath.section][K_ARRAYINFO] as! [[String:String]]
            
            return aAryInfo.count > 0 ? 250 : 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if myAryInfo[indexPath.section][K_TITLE] as? String == K_TITLE_BANNER {
            
            let aAryInfo = myAryInfo[indexPath.section][K_ARRAYINFO] as! [String]
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellBannerIdentifier, for: indexPath) as! GSTopBannerTableViewCell
            
            HELPER.setCardView(cardView: aCell.gContainerView)
            
            aCell.gImgView.setShowActivityIndicator(true)
            aCell.gImgView.setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
            
            aCell.gBtnAddFavourites.isSelected = false
            
            if self.myIntIsFavourite == 1 {

                aCell.gBtnAddFavourites.isSelected = true
            }
            if SESSION.isUserLogIn() {
                aCell.gBtnAddFavourites.addTarget(self, action: #selector(FavouriteBtnTapped), for: .touchUpInside)
                aCell.gBtnAddFavourites.row = indexPath.row
                aCell.gBtnAddFavourites.section = indexPath.section
                aCell.gBtnAddFavourites.isHidden = false
                
                if gStrUserId == SESSION.getUserId() {
                    aCell.gBtnAddFavourites.isHidden = true
                }
            }
            else {
                aCell.gBtnAddFavourites.isHidden = true
            }
            
            
            aCell.gBtnAddFavourites.addTarget(self, action: #selector(FavouriteBtnTapped), for: .touchUpInside)

            aCell.gImgView.sd_setImage(with: URL(string:SESSION.getBaseImageUrl() + aAryInfo[indexPath.row]), placeholderImage: UIImage(named: ICON_PLACEHOLDER_IMAGE))
            aCell.selectionStyle = .none
            return aCell
        }
        
        else if myAryInfo[indexPath.section][K_TITLE] as? String == K_TITLE_PROFILE {
            
            let aAryInfo = myAryInfo[indexPath.section][K_ARRAYINFO] as! [[String:Any]]
            let aDictInfo = aAryInfo[indexPath.row]

            let aCell = tableView.dequeueReusableCell(withIdentifier: cellUserDetailsIdentifier, for: indexPath) as! GSUserDetailsTableViewCell
            
            aCell.gLblName.text = aDictInfo["fullname"] as? String
            aCell.gLblType.text = aDictInfo["profession_name"] as? String
            
            let aStrProfileImage = aDictInfo["user_profile_image"] as? String
            
            HELPER.setRoundCornerView(aView: aCell.gImgView)
            aCell.gImgView.sd_setImage(with: URL(string:SESSION.getBaseImageUrl() + aStrProfileImage!), placeholderImage: UIImage(named: IMG_PROFILE_PLACEHOLDER))
            
            let myFloat = (aDictInfo["gig_rating"]! as! NSString).floatValue

            aCell.gRatingView.isUserInteractionEnabled = false
            aCell.gRatingView.isAbsValue = false

            aCell.gRatingView.maxValue = 5
            aCell.gRatingView.value = CGFloat(myFloat)
            aCell.selectionStyle = .none
            
            return aCell
        }
        
        else if myAryInfo[indexPath.section][K_TITLE] as? String == K_TITLE_DESCRIPTION {
            
            let aAryInfo = myAryInfo[indexPath.section][K_ARRAYINFO] as! [String]
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellUserDescriptionIdentifier, for: indexPath) as! GSUserDescriptionTableViewCell
            
            aCell.gLblDesciption.text = aAryInfo[indexPath.row]
            aCell.selectionStyle = .none
            
            return aCell
        }
        else if myAryInfo[indexPath.section][K_TITLE] as? String == K_TITLE_USER_INFO {
            
            let aAryInfo = myAryInfo[indexPath.section][K_ARRAYINFO] as! [[String:String]]
            
            let aAryUsrinfo = ["Total Views","Country","User Count","Speaks"]
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellUserInfoIdentifier, for: indexPath) as! GSUserInfoTableViewCell
            
            aCell.gLblFirst.text = aAryUsrinfo[0]
            aCell.gLblSecond.text = aAryInfo[indexPath.row]["Views"]
            aCell.gLblThird.text = aAryUsrinfo[1]
            aCell.gLblFour.text = aAryInfo[indexPath.row]["Country"]
            aCell.gLblFive.text = aAryUsrinfo[2]
            aCell.gLblSix.text = aAryInfo[indexPath.row]["UserCount"]
            aCell.gLblSeven.text = aAryUsrinfo[3]
            aCell.gLblEight.text = aAryInfo[indexPath.row]["Speaks"]
            aCell.selectionStyle = .none
            return aCell
        }
            
        else if myAryInfo[indexPath.section][K_TITLE] as? String == K_TITLE_EXTRA_GIGS {
            
            let aAryInfo = myAryInfo[indexPath.section][K_ARRAYINFO] as! [[String:String]]
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellExtrasIdentifier, for: indexPath) as! GSExtrasTableViewCell
            
            if aAryInfo.count != 0 || aAryInfo[indexPath.row]["extra_gigs"] != "" {
                
                aCell.gViewContainer.isHidden = false
                aCell.gLblFirst.text = aAryInfo[indexPath.row]["extra_gigs"]
                if let value = aAryInfo[indexPath.row]["currency_sign"] {
                    
                    myStrCurrencySign = value
                }
                aCell.gLblLast.text = ("For " + myStrCurrencySign + aAryInfo[indexPath.row]["extra_gigs_amount"]! + " in " + aAryInfo[indexPath.row]["extra_gigs_delivery"]! + "day")

                aCell.gBtnCheckBox.tag = indexPath.row
                
                aCell.gBtnCheckBox.addTarget(self, action: #selector(radioBtnTapped(_:)), for: .touchUpInside)
                
                HELPER.setRoundCornerView(aView: aCell.gLblMiddle, borderRadius: 6)
                
                aCell.gLblMiddle.isHidden = aAryInfo[indexPath.row]["is_superfast"] == "1" ? false : true
                
                // aCell.gLblLast.isHidden = aAryInfo[indexPath.row]["is_superfast"] == "1" ? false : true
                
                if aAryInfo[indexPath.row]["is_selected"] == "0" {
                    
                    aCell.gBtnCheckBox.setImage(UIImage(named:ICON_UNCHECKED_BOX), for: .normal)
                }
                else {
                    
                    aCell.gBtnCheckBox.setImage(UIImage(named:ICON_CHECKED_BOX), for: .normal)
                    
                }
                aCell.gBtnCheckBox.isHidden = false
                aCell.gBtnCheckBoxWidth.constant = 15

                if gStrUserId == SESSION.getUserId() {
                    aCell.gBtnCheckBox.isHidden = true
                    aCell.gBtnCheckBoxWidth.constant = 0
                }
                else if SESSION.getUserId() == "" {
                    aCell.gBtnCheckBox.isHidden = true
                    aCell.gBtnCheckBoxWidth.constant = 0
                    
                }
            }
            
            else {
                aCell.gViewContainer.isHidden = true
            }
            aCell.selectionStyle = .none
            return aCell
        }
            
        else if myAryInfo[indexPath.section][K_TITLE] as? String == K_TITLE_REVIEWS {
            
            gAryReviewInfo = myAryInfo[indexPath.section][K_ARRAYINFO] as! [[String:String]]
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellUserReviewIdentifier, for: indexPath) as! GSUserReviewsTableViewCell
            
            let aStrProfileImage = gAryReviewInfo[indexPath.row]["profile_img"] as? String
            
            HELPER.setRoundCornerView(aView: aCell.gImgView)
            aCell.gImgView.sd_setImage(with: URL(string:SESSION.getBaseImageUrl() + aStrProfileImage!), placeholderImage: UIImage(named: IMG_PROFILE_PLACEHOLDER))
            
            aCell.gLblUserName.text = gAryReviewInfo[indexPath.row]["buyername"] as? String
            
            let result = (gAryReviewInfo[indexPath.row]["rating"] as! NSString).floatValue
            
            aCell.gViewRating.maxValue = 5
            aCell.gViewRating.value = CGFloat(result)
            aCell.gLblUserDetail.text = gAryReviewInfo[indexPath.row]["comment"] as? String
            aCell.selectionStyle = .none
            
            return aCell
        }
        
        else if myAryInfo[indexPath.section][K_TITLE] as? String == K_TITLE_SIMILAR_GIGS {
            
            let aAryInfo = myAryInfo[indexPath.section][K_ARRAYINFO] as! [[String:String]]
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellPopularIdentifier, for: indexPath) as! GSPopularTableViewCell
            
            if aAryInfo.count > 0 {
                
                aCell.gCollectionView.isHidden = false
                aCell.gCollectionView.delegate = self
                aCell.gCollectionView.dataSource = self
                aCell.gCollectionView.tag = indexPath.section
                
                aCell.gCollectionView.register(UINib(nibName: cellPopularCollectionIdentifier, bundle: nil), forCellWithReuseIdentifier: cellPopularCollectionIdentifier)
            }
            
            else {
                
                aCell.gCollectionView.isHidden = true
            }
            
            aCell.selectionStyle = .none
            
            return aCell
        }
        
        else {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellUserDescriptionIdentifier, for: indexPath) as! GSUserDescriptionTableViewCell
            aCell.selectionStyle = .none
            
            return aCell
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if myAryInfo[indexPath.section][K_TITLE] as? String == K_TITLE_PROFILE {
            
            if SESSION.isUserLogIn() {
                
                let aAryInfo = myAryInfo[indexPath.section][K_ARRAYINFO] as! [[String:Any]]
                let aDictInfo = aAryInfo[indexPath.row]
                
                print(aDictInfo)
                
                let aViewController = GSUserInfoViewController()
                aViewController.gStrTitle = (aDictInfo["fullname"] as? String)!
                aViewController.gAryInfo = myAryInfo
                aViewController.userInfo = myAryInfo[1][K_ARRAYINFO] as! [[String : Any]]
                aViewController.userProfileInfo = myAryInfo[3][K_ARRAYINFO] as! [[String:String]]
                
                self.navigationController?.pushViewController(aViewController, animated: true)
            }
            else {
                
                APPDELEGATE.loadLogInSceen()
            }
        }
    }
    
     // MARK: - Collection view delegate and data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let aAryInfo = myAryInfo[collectionView.tag][K_ARRAYINFO] as! [[String:String]]

        return aAryInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellPopularCollectionIdentifier, for: indexPath) as! GSPopularGigsCollectionViewCell
        
        if myAryInfo[collectionView.tag][K_TITLE] as? String == K_TITLE_SIMILAR_GIGS {
            
            let aAryInfo = myAryInfo[collectionView.tag][K_ARRAYINFO] as! [[String:String]]
            
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellPopularCollectionIdentifier, for: indexPath) as! GSPopularGigsCollectionViewCell
            
            //HELPER.setRoundCornerView(aView: aCell.gView, borderRadius: 5)
            
            HELPER.setCardView(cardView: aCell.gView)
            aCell.gLblPrice.textColor = HELPER.hexStringToUIColor(hex: APP_COLOR)
            aCell.gImgView.setShowActivityIndicator(true)
            aCell.gImgView.setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
            aCell.gImgView.sd_setImage(with: URL(string:SESSION.getBaseImageUrl() + aAryInfo[indexPath.row]["image"]!), placeholderImage: UIImage(named: ICON_PLACEHOLDER_IMAGE))
            
            aCell.gLblTitle.text = aAryInfo[indexPath.row]["title"]
            
            aCell.gBtnFavourites.isSelected = false
            
            if aAryInfo[indexPath.row]["favourite"] == "1" {
                
                aCell.gBtnFavourites.isSelected = true
            }
            
            if SESSION.isUserLogIn() {
                aCell.gBtnFavourites.addTarget(self, action: #selector(FavouriteBtnTapped), for: .touchUpInside)
                aCell.gBtnFavourites.row = indexPath.row
                aCell.gBtnFavourites.section = 6
                aCell.gBtnFavourites.isHidden = false
            }
            if gStrUserId == SESSION.getUserId() {
                aCell.gBtnFavourites.isHidden = true
            }
            else {
                aCell.gBtnFavourites.isHidden = false
            }
            
            let yourAttributes = [NSAttributedStringKey.foregroundColor: HELPER.hexStringToUIColor(hex: "EFCE49"), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)]
            let yourOtherAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)]
            
            let partOne = NSMutableAttributedString(string: aAryInfo[indexPath.row]["gig_rating"]!, attributes: yourAttributes)
            let partTwo = NSMutableAttributedString(string: " (" + aAryInfo[indexPath.row]["gig_usercount"]! + ")", attributes: yourOtherAttributes)
            
            let combination = NSMutableAttributedString()
            
            combination.append(partOne)
            combination.append(partTwo)
            
            aCell.gLblReview.attributedText = combination
            
            if let value = aAryInfo[(indexPath.row)]["currency_sign"] {
                
                myStrCurrencySign = value
            }
            
            aCell.gLblPrice.text = myStrCurrencySign + aAryInfo[indexPath.row]["gig_price"]!
            
            return aCell
        }
        return aCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        if myAryInfo[collectionView.tag][K_TITLE] as? String == K_TITLE_BANNER {
//            
//            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
//        }
        
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
    
    // MARK: - Api call
    
    func callDetailApi() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingViewAnimation(viewController: self)
        
        var dictParameters = [String:String]()
        dictParameters[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
        dictParameters[K_GIG_ID] = gStrGigId
        //dictParameters[K_USER_id] = SESSION.getUserId()
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_GIGS_DETAILS, dictParameters: dictParameters, sucessBlock: { (response) in

//        HTTPMANAGER.getDetailGigsInfo(gigId:gStrGigId, sucessblock: {response in
        
            HELPER.hideLoadingAnimation(viewController: self)
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                var aAryResponse = [[String:Any]]()
                
                aAryResponse = response["data"] as! [[String:Any]]
                
                var aDictReponse = aAryResponse[0]
                
                var aDictGisgsDetails = [String:Any]()

                // Add Banner
                var aDictBannerImage = [String:Any]()
                var aAryImage = [String]()

                aDictGisgsDetails = aDictReponse["gigs_details"] as! [String : Any]
                if let fav = aDictGisgsDetails["favourite"]  {
                    if fav is String {
                        self.myStrIsFavourite = (fav as? String)!
                    }
                    else {
                        self.myIntIsFavourite = fav as! Int
                    }
                }
                self.gStrGigId = aDictGisgsDetails["id"] as? String ?? ""
                self.gStrUserId = aDictGisgsDetails["unique_code"] as? String ?? ""
                self.myStrCategoryId = aDictGisgsDetails["category_id"] as? String ?? ""
                
//              aDictGisgsDetails = aDictReponse["user_profile_image"] as! [String : Any]
                aAryImage.append(aDictGisgsDetails["image"] as! String)

                aDictBannerImage[self.K_TITLE] = self.K_TITLE_BANNER
                aDictBannerImage[self.K_ARRAYINFO] = aAryImage
                self.myAryInfo.append(aDictBannerImage)
                
                // Add Profile
                //var aDictProfile = [String:Any]()
                var aDictProfileInfo = [String:Any]()
                var aAryProfile = [[String:Any]]()
                
//                aDictProfile["UserName"] = aDictGisgsDetails["username"]
//                aDictProfile["Type"] = aDictGisgsDetails["fullname"]
//                aDictProfile["Rating"] = aDictGisgsDetails["gig_rating"]
                
                aAryProfile.append(aDictGisgsDetails)
                
                aDictProfileInfo[self.K_TITLE] = self.K_TITLE_PROFILE
                aDictProfileInfo[self.K_ARRAYINFO] = aAryProfile
                self.myAryInfo.append(aDictProfileInfo)
                
                // Add Description
                var aDictDescriptionContent = [String:Any]()
                var aAryDescription = [String]()
                aAryDescription.append(aDictGisgsDetails["gig_details"] as! String)
                
                aDictDescriptionContent[self.K_TITLE] = self.K_TITLE_DESCRIPTION
                aDictDescriptionContent[self.K_ARRAYINFO] = aAryDescription
                self.myAryInfo.append(aDictDescriptionContent)

                //Add User Informations
                var aDictUser = [String:Any]()
                var aDictUserInfo = [String:Any]()
                var aAryUserInfo = [[String:String]]()
                
                aDictUser["Views"] = aDictGisgsDetails["total_views"]
                aDictUser["Country"] = aDictGisgsDetails["country"]
                aDictUser["UserCount"] = aDictGisgsDetails["gig_usercount"]
                aDictUser["Speaks"] = aDictGisgsDetails["lang_speaks"]
                aAryUserInfo.append(aDictUser as! [String : String])

                aDictUserInfo[self.K_TITLE] = self.K_TITLE_USER_INFO
                aDictUserInfo[self.K_ARRAYINFO] = aAryUserInfo
                
                self.myAryInfo.append(aDictUserInfo)
                
                //Add Extra Gigs
                var aAryExtraGigsInfo = [[String:Any]]()
                var aDictExtraGigs = [String:Any]()
                var aDictSuperFast = [String:Any]()
                
                aDictSuperFast["extra_gigs"] = aDictGisgsDetails["super_fast_delivery_desc"]
                aDictSuperFast["extra_gigs_amount"] = aDictGisgsDetails["super_fast_charges"]
                aDictSuperFast["extra_gigs_delivery"] = aDictGisgsDetails["super_fast_days"]
                aDictSuperFast["is_superfast"] = aDictGisgsDetails["is_superfast"]
                aDictSuperFast["is_selected"] = "0"

                aAryExtraGigsInfo = aDictGisgsDetails["extra_gigs"] as! [[String:String]]
                aAryExtraGigsInfo.append(aDictSuperFast)
                
                aDictExtraGigs[self.K_TITLE] = self.K_TITLE_EXTRA_GIGS
                aDictExtraGigs[self.K_ARRAYINFO] = aAryExtraGigsInfo
                
                print(aDictExtraGigs)
                
                self.myAryInfo.append(aDictExtraGigs)
                
                //Add Reviews Gigs
                var aAryReviewGigsInfo = [[String:Any]]()
                var aDictReviewInfo = [String:Any]()
                
                aAryReviewGigsInfo = aDictReponse["reviews"] as! [[String:String]]
                
                print(aAryReviewGigsInfo)
                
                aDictReviewInfo[self.K_TITLE] = self.K_TITLE_REVIEWS
                aDictReviewInfo[self.K_ARRAYINFO] = aAryReviewGigsInfo
                
                self.myAryInfo.append(aDictReviewInfo)
                
                //Add Similar Gigs
                var aArySimilarGigsInfo = [[String:Any]]()
                var aDictSimilarGigsInfo = [String:Any]()
                
                aArySimilarGigsInfo = aDictReponse["similar_gigs"] as! [[String:String]]
                
                aDictSimilarGigsInfo[self.K_TITLE] = self.K_TITLE_SIMILAR_GIGS
                aDictSimilarGigsInfo[self.K_ARRAYINFO] = aArySimilarGigsInfo
                
                self.myAryInfo.append(aDictSimilarGigsInfo)
                
                let aAryInfo = self.myAryInfo[1][self.K_ARRAYINFO] as! [[String:Any]]
                let aDictInfo = aAryInfo[0]
                self.useridFromList = (aDictInfo["unique_code"] as? String)!
//                self.myBtnOrder.setTitle("Order for \(self.gStrCurrencySign)" + self.gStrGigPrice,for: .normal)
//                if SESSION.getUserId() == self.useridFromList {
//                    self.myBtnOrder.setTitle("Edit Gigs",for: .normal)
//
//                }
                
                if SESSION.getUserId() == self.useridFromList {
                    self.myBtnOrder.setTitle("Edit Gigs",for: .normal)
                    self.myBtnOrder.removeTarget(self, action: nil, for: .touchUpInside)
                    self.myBtnOrder.addTarget(self, action: #selector(self.editBtnTapped), for: .touchUpInside)
                }
                else {
                    self.myBtnOrder.removeTarget(self, action: nil, for: .touchUpInside)
                    
                    self.myBtnOrder.setTitle("Order for \(self.gStrCurrencySign)" + String(self.gStrGigPrice),for: .normal)
                    self.myBtnOrder.addTarget(self, action: #selector(self.orderBtnTapped(sender:)), for: .touchUpInside)
                }
                
                self.myTbView.reloadData()
                
                
                if SESSION.getUserId() != ""{
                     self.httpRequestForLastVisitedGigs()
                }
            }
            else {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation(viewController: self)
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    //Last visited gigs
    func httpRequestForLastVisitedGigs() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        var dictLoginCrediental = [String:String]()
        //dictLoginCrediental[K_USER_ID] = SESSION.getUserId()
        dictLoginCrediental["gig_id"] = gStrGigId
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_LAST_VISITED_GIGS, dictParameters: dictLoginCrediental, sucessBlock: { (response) in

//        HTTPMANAGER.sendLastVisitedGigs(parameter: dictLoginCrediental, sucessblock: {response in
            
            let aIntResponseCode = response["code"] as! Int
            //let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
//                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
//                self.view.endEditing(true)
            }
            else {
                
//                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
        }, failureBlock: { error in
            
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    // MARK: - Button Action
    
    @objc func FavouriteBtnTapped(sender : UIButton) {
        
        let button:MyFavButton = sender as! MyFavButton
        if myAryInfo[button.section!][K_TITLE] as? String == K_TITLE_BANNER {
            
            var aAryInfo = self.myAryInfo[1][K_ARRAYINFO] as! [[String:Any]]
            self.gStrGigIdHome = aAryInfo[button.row!]["id"]! as! String
//
//            var dict = aAryInfo[button.row!]
            let btn = sender
//            let fav:String = dict["favourite"] as! String
            if myIntIsFavourite == 0 {
                
                HELPER.addFavourites(from: self, gigid: self.gStrGigIdHome)
            
                aAryInfo[button.row!]["favourite"] = 1
                btn.isSelected = true
                self.myIntIsFavourite = 1
                self.myAryInfo[1][self.K_ARRAYINFO]  = aAryInfo
            }
            else {
                
                HELPER.removeFavourites(from: self, gigid: self.gStrGigIdHome)
                
                //var dict = aAryInfo[button.row!]
                //dict["favourite"] = "0"
                aAryInfo[button.row!]["favourite"] = 0
                self.myIntIsFavourite  = 0
                btn.isSelected = false
                
                self.myAryInfo[button.section!][self.K_ARRAYINFO]  = aAryInfo
            }
        } else  if myAryInfo[button.section!][K_TITLE] as? String == K_TITLE_SIMILAR_GIGS {
            
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
    
    @objc func viewSimilarBtnTapped(sender: UIButton) {
        
        let aViewcontroller = GSViewAllGigsViewController()
        aViewcontroller.gIsSimilarGigs = true
        aViewcontroller.gStrCategoryId = myStrCategoryId
        self.navigationController?.pushViewController(aViewcontroller, animated: true)
    }
    
    @objc func viewReviewBtnTapped(sender: UIButton) {
        
        let aViewcontroller = GSViewAllReviewsViewController()
        aViewcontroller.gAryInfo = gAryReviewInfo as! [[String : String]]
        aViewcontroller.gStrGigId = gStrGigId
        self.navigationController?.pushViewController(aViewcontroller, animated: true)
    }
    
    @objc func editBtnTapped(sender: UIButton) {
        
        if SESSION.isUserLogIn() {
            
            guard myBtnOrder.titleLabel?.text == "Edit Gigs" else {
                return
            }
            
            let aViewController = GSSellViewController()
            let aAryInfo = self.myAryInfo[1][self.K_ARRAYINFO] as! [[String:Any]]
            let aDictInfo = aAryInfo[0]
            let gigidFromList = aDictInfo["id"] as? String
            aViewController.gStrGigId = gigidFromList ?? ""
            aViewController.isFromEditGigs = true
            Updatedimage = nil
            isSellTabSelected = true
            self.navigationController?.pushViewController(aViewController, animated: true)
        }
        else {
            HELPER.pushToLogInScreen(isFrom: self)
        }
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
    
    @objc func backBtnTapped() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func radioBtnTapped (_ sender : UIButton) {
        
        var aIntUpdateAmount = Float ()
        var aIntTotalAmount = Float()
        
        print(gStrGigPrice)

        aIntTotalAmount = Float(gStrGigPrice)
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.myTbView)
        let indexPath = self.myTbView.indexPathForRow(at: buttonPosition)
        
        var aAryInfo = myAryInfo[(indexPath?.section)!][K_ARRAYINFO] as! [[String:String]]

        aAryInfo[(indexPath?.row)!]["is_selected"] = aAryInfo[(indexPath?.row)!]["is_selected"]! == "0" ? "1" : "0"
        
        sender.setImage(UIImage(named:aAryInfo[(indexPath?.row)!]["is_selected"]! == "0" ? ICON_UNCHECKED_BOX : ICON_CHECKED_BOX), for: .normal)

        if aAryInfo[(indexPath?.row)!]["is_selected"]! == "0" {
            
            var aIntMinus = Float()
            aIntMinus = Float(aAryInfo[(indexPath?.row)!]["extra_gigs_amount"]!)!
            aIntUpdateAmount = aIntTotalAmount - aIntMinus
        }
    
        else {
            
            var aIntPlus = Float()
            aIntPlus = Float(aAryInfo[(indexPath?.row)!]["extra_gigs_amount"]!)!
            aIntUpdateAmount = aIntTotalAmount + aIntPlus
        }
        
        gStrGigPrice = Float(aIntUpdateAmount)
        
        if let value = aAryInfo[(indexPath?.row)!]["currency_sign"] {
            
            myStrCurrencySign = value
        }
        myBtnOrder.setTitle("Order for \(myStrCurrencySign)" + String(gStrGigPrice),for: .normal)

        myAryInfo[(indexPath?.section)!][K_ARRAYINFO] = aAryInfo

    }
    
    @objc func orderBtnTapped(sender: UIButton) {
        
        if (!SESSION.isUserLogIn()) {
            
            HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: APP_ALERT_TITLE_MUST_LOGIN, okActionBlock: { (okAction) in
                
                APPDELEGATE.loadLogInSceen()
            })
        }
            
        else {
            
            let aAryInfo = myAryInfo[4][K_ARRAYINFO] as! [[String:String]]
            
            let aAryUserInfo = myAryInfo[1][K_ARRAYINFO] as! [[String:Any]]
            
            var aBoolSuperFast = Bool()
            
            var aIntDeliveryDay = 0
            
            var aAryExtraGigInfo = [[String:Any]]()
            
            if aAryInfo.count != 0 {
                
                for aDictInfo in aAryInfo {
                    
                    let aStrIsSelected = aDictInfo["is_selected"]
                    
                    if aStrIsSelected != "0" {
                        
                        aBoolSuperFast = aDictInfo["is_superfast"] != nil
                        let aStrGigDeliveryDay = aDictInfo["extra_gigs_delivery"]
                        //                        if aStrGigDeliveryDay?.count == 0 {
                        //                            aStrGigDeliveryDay = "0"
                        //                        }
                        aIntDeliveryDay = aIntDeliveryDay + Int(aStrGigDeliveryDay!)!
                        var aDictGig = [String:Any]()
                        aDictGig[self.K_TITLE] = "extra_gig_info"
                        aDictGig[self.K_ARRAYINFO] = aDictInfo
                        myAryCartInfo.append(aDictGig)
                        if !aBoolSuperFast {
                            aAryExtraGigInfo.append(aDictInfo)
                        }
                    }
                }
            }
            
            var aDictGigInfo = [String:Any]()
            
            if aAryUserInfo.count != 0 {
                
                for aDictInfo in aAryUserInfo {
                    
                    aDictGigInfo["seller_id"] = aDictInfo["user_id"]
                    
                }
            }
            
            aDictGigInfo["gig_name"] = gStrGigName
            aDictGigInfo["gig_price"] = gStrGigOriginalPrice
            aDictGigInfo["item_no"] = "1"
            aDictGigInfo["total_gig_price"] = gStrGigPrice
            aDictGigInfo["gig_id"] = gStrGigId
            aDictGigInfo["is_super_fast"] = aBoolSuperFast ? "1" :"0"
            aDictGigInfo["total_delivery_days"] = String(aIntDeliveryDay)
            
            var aDictGig = [String:Any]()
            aDictGig[self.K_TITLE] = "gig_info"
            aDictGig[self.K_ARRAYINFO] = aDictGigInfo
            myAryCartInfo.append(aDictGig)
            
            
            let aViewcontroller = GSCartViewController()
            aViewcontroller.gAryInfo = myAryCartInfo
            aViewcontroller.gAryExtraGigInfo = aAryExtraGigInfo
            myAryCartInfo.removeAll()
            aAryExtraGigInfo.removeAll()
            self.navigationController?.pushViewController(aViewcontroller, animated: true)
        }
    }
}

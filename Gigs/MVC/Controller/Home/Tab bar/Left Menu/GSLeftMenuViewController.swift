//
//  GSLeftMenuViewController.swift
//  Gigs
//
//  Created by dreams on 24/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit
import SDWebImage

class GSLeftMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var myTblView: UITableView!
    @IBOutlet var myContainerHeaderView: UIView!
    @IBOutlet var myViewHeader: UIView!
    @IBOutlet var myImgViewHeader: UIImageView!
    @IBOutlet var myLblUserName: UILabel!
    
    let KMENUTITLE: String = "title"
    let KMENUIMAGENAME: String = "image_name"
    
    var myAryRowInfo = [[String : String]] ()
    
    var myAryInfo = [[String:String]]()
    
    let cellIdentifier: String = "GSLeftMenuTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpModel()
        loadModel()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        setUpUI()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI() {
        
        self.myContainerHeaderView.backgroundColor = HELPER.hexStringToUIColor(hex: APP_COLOR)
        self.myViewHeader.backgroundColor = HELPER.hexStringToUIColor(hex: APP_COLOR)
        
        HELPER.setRoundCornerView(aView: myImgViewHeader)
        
//        HELPER.setRoundCornerView(aView: myViewHeader, borderRadius: 50)
        
        navigationController?.isNavigationBarHidden = true
        
        myTblView.delegate = self
        myTblView.dataSource = self
        
        myTblView.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        myImgViewHeader.setShowActivityIndicator(true)
        myImgViewHeader.setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
        myImgViewHeader.sd_setImage(with: URL(string:"http://dreamguys.co.in/thegigs/" + SESSION.getUserImage()), placeholderImage: UIImage(named: "icon_profile_placeholder"))
        
        myLblUserName.text = SESSION.isUserLogIn() ? "Hello \(SESSION.getUserName())!" : " Hello Guest!"
        
        myAryRowInfo = [[KMENUIMAGENAME: "icon_favourite_heart_left", KMENUTITLE : SCREEN_TITLE_FAVORUTIES], [KMENUIMAGENAME: "icon_last_visited", KMENUTITLE : SCREEN_TITLE_LAST_VISITED_GIGS], [KMENUIMAGENAME: "icon_search", KMENUTITLE : SCREEN_TITLE_SEARCH_GIGS], [KMENUIMAGENAME: "icon_my_activity", KMENUTITLE : SCREEN_TITLE_MY_ACTIVITY], [KMENUIMAGENAME: "icon_my_gigs", KMENUTITLE : SCREEN_TITLE_MY_GIGS]]

    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
    }

    // MARK: - Table View Delegate and Datasource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myAryRowInfo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! GSLeftMenuTableViewCell
        aCell.gLblTitle.text = myAryRowInfo[indexPath.row][KMENUTITLE]
        aCell.gImgView.image = UIImage(named: myAryRowInfo[indexPath.row][KMENUIMAGENAME]!)
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.myTblView.deselectRow(at: indexPath, animated: true)
        
        let strTitle = myAryRowInfo[indexPath.row][KMENUTITLE]
        
        if strTitle == SCREEN_TITLE_FAVORUTIES  && SESSION.isUserLogIn() {
            
            let aViewController = GSViewAllGigsViewController()
            aViewController.gIsFavourites = true
            let aNavi = UINavigationController(rootViewController: aViewController)
            self.present(aNavi, animated: true, completion: nil)
            
//            self.navigationController?.pushViewController(aViewController, animated: true)
//            let naviController = UINavigationController(rootViewController: aViewController)
//            self.evo_drawerController?.setCenter(naviController, withCloseAnimation: true, completion: nil)
        }
        else if strTitle == SCREEN_TITLE_LAST_VISITED_GIGS  && SESSION.isUserLogIn() {
            
            let aViewController = GSViewAllGigsViewController()
            aViewController.gIsLastVisited = true 
            let aNavi = UINavigationController(rootViewController: aViewController)
            self.present(aNavi, animated: true, completion: nil)

        }
        else if strTitle == SCREEN_TITLE_MY_GIGS  && SESSION.isUserLogIn() {
            
            let aViewController = GSViewAllGigsViewController()
            aViewController.gIsMyGigs = true
            let aNavi = UINavigationController(rootViewController: aViewController)
            self.present(aNavi, animated: true, completion: nil)

        }
        else if strTitle == SCREEN_TITLE_SEARCH_GIGS {
            
            self.evo_drawerController?.toggleDrawerSide(.left, animated: true, completion: nil)
            let aViewController = GSSearchViewController()
            let aNavi = UINavigationController(rootViewController: aViewController)
            self.present(aNavi, animated: true, completion: nil)

        }
        else if strTitle == SCREEN_TITLE_MY_ACTIVITY && SESSION.isUserLogIn() {
            
            let aViewController = GSActivityViewController()
            let aNavi = UINavigationController(rootViewController: aViewController)
            self.present(aNavi, animated: true, completion: nil)
        }
        else if SESSION.isUserLogIn() == false {
         
            
            let aViewController = GSLoginViewController()
            if strTitle == SCREEN_TITLE_LAST_VISITED_GIGS {
                aViewController.gIsLastVisited = true
            }
            else if strTitle == SCREEN_TITLE_MY_GIGS {
                aViewController.gIsMyGigs = true
            }
            else if strTitle == SCREEN_TITLE_FAVORUTIES {
                aViewController.gIsFavourites = true
            }
            self.evo_drawerController?.toggleDrawerSide(.left, animated: true, completion: nil)
            
            let aNavi = UINavigationController(rootViewController: aViewController)
            self.present(aNavi, animated: true, completion: nil)
            //            HELPER.pushToLogInScreen(isFrom: aViewController)
            
            
        }
    }
}

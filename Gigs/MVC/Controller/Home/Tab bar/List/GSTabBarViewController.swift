//
//  GSTabBarViewController.swift
//  Gigs
//
//  Created by dreams on 08/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit
import AMScrollingNavbar

var isSellTabSelected = false
class GSTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        setUpLeftBarBackButton()
        
        self.tabBar.backgroundColor = UIColor.white
        
        // Create Tab one
        let tabOne = GSHomeViewController()
        let tabOneBarItem = UITabBarItem(title: "Home", image: UIImage(named: "icon_home"), selectedImage: UIImage(named: "icon_home"))
        tabOne.tabBarItem = tabOneBarItem
        // let navigationController = ScrollingNavigationController(rootViewController: tabOne)
        
        // let tabOneBarItem:UITabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "icon_star")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "icon_star"))
        //        tabOne.tabBarItem = tabOneBarItem
        
        self.tabBar.tintColor = HELPER.hexStringToUIColor(hex: APP_COLOR)
        
        // UITabBar.appearance().selectedImageTintColor = HELPER.hexStringToUIColor(hex: APP_COLOR) //UIColor.white
        
        // Create Tab two
        let tabTwo = GSSellViewController()
        let tabTwoBarItem2 = UITabBarItem(title: "Sell", image: UIImage(named: "icon_sell"), selectedImage: UIImage(named: "icon_sell"))
        tabTwo.tabBarItem = tabTwoBarItem2
        
        
        // Create Tab three
        let tabThree = GSBuyViewController()
        let tabThreeBarItem3 = UITabBarItem(title: "Buy", image: UIImage(named: "icon_buy"), selectedImage: UIImage(named: "icon_buy"))
        tabThree.tabBarItem = tabThreeBarItem3
        
        // Create Tab four
        let tabFour = GSChatListViewController()
        let tabFourBarItem4 = UITabBarItem(title: "Chat", image: UIImage(named: "icon_chat"), selectedImage: UIImage(named: "icon_chat"))
        tabFour.tabBarItem = tabFourBarItem4
        
        // Create Tab five
        let tabFive = GSSettingsViewController()
        let tabFiveBarItem5 = UITabBarItem(title: "Settings", image: UIImage(named: "icon_settings"), selectedImage: UIImage(named: "icon_settings"))
        
        tabFive.tabBarItem = tabFiveBarItem5
        
        self.viewControllers = [tabOne, tabTwo, tabThree, tabFour, tabFive]
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black], for:.normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: HELPER.hexStringToUIColor(hex: APP_COLOR)], for:.selected)
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
  
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
//        if(tabBarController.selectedIndex == 2){
//
//            let aBuyViewController = GSBuyViewController()
//            self.navigationController?.pushViewController(aBuyViewController, animated: true)
//        }
//
//        else {
//            self.tabBarController?.selectedIndex = 0
//        }
//        self.tabBarController?.selectedIndex = 0
//        if  (tabBarController.selectedIndex == 0)  && SESSION.isUserLogIn() == false {
//            if let vc = tabBarController.viewControllers?.first {
//                HELPER.pushToLogInScreen(isFrom: vc)
//            }
//        }
//        else if(tabBarController.selectedIndex == 1){
//            isSellTabSelected = true
//        }
        
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
//        let navVcs = viewController as! UINavigationController
//        let topVc:UIViewController = navVcs.topViewController!
        isSellTabSelected = false
        let status = viewController.isKind(of: GSHomeViewController.self)
        if status == false  && SESSION.isUserLogIn() == false {
            if let vc = tabBarController.viewControllers?.first {
            HELPER.pushToLogInScreen(isFrom: vc)
            }
            return false
        }
        else if (viewController.isKind(of: GSSellViewController.self)) {

            isSellTabSelected = true

             myStrCategoryNameForSell = String()
             myStrGigDeliveryDay = String()
             myStrGigPrice = String()
             myStrGigDescription = String()
             myStrGigTitle = String()
             myAryExtrasInfo = [[String:Any]]()
             myDictExtrasInfo = [String:Any]()
             myStrWorkOption = String()
             myStrGigDescriptionSuperFast = String()
             myStrGigTitleSuperFast = String()
             myStrGigDeliveryDaySuperFast = String()
             myStrGigPriceSuperFast = String()
             myStrGigImage = String()
             myStrTermsAndConditionCheck = "0"
            Updatedimage = nil
        }
        
        return true
    }
    // MARK : - Left Bar Button Methods
    
    func setUpLeftBarBackButton() {
        
        let leftBtn = UIButton(type: .custom)
        leftBtn.setImage(UIImage(named: ICON_MENU), for: .normal)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        leftBtn.addTarget(self, action: #selector(leftListBtnTapped), for: .touchUpInside)
        
        let leftBarBtnItem = UIBarButtonItem(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftBarBtnItem
    }
    
    @objc func leftListBtnTapped() {
        
        self.evo_drawerController?.toggleDrawerSide(.left, animated: true, completion: nil)
    }
}

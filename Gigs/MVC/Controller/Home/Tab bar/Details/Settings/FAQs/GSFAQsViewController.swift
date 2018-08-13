//
//  GSFAQsViewController.swift
//  Gigs
//
//  Created by Dreamguys on 13/03/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSFAQsViewController: UIViewController,UIWebViewDelegate {
    
    @IBOutlet var myWebView: UIWebView!
    
    var gStrTitle = String()
    var gStrContent = String()

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
        
        NAVIGAION.setNavigationTitle(aStrTitle: gStrTitle, aViewController: self)
        setUpLeftBarBackButton()
        myWebView.delegate = self
        myWebView.loadHTMLString(gStrContent, baseURL: nil)
        
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
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

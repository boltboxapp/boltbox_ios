//
//  GSIntroScreenViewController.swift
//  Gigs
//
//  Created by Dreamguys on 30/04/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSIntroScreenViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    @IBOutlet var myCollectionView: UICollectionView!
    @IBOutlet var mySkipBtn: UIButton!
    @IBOutlet var myPreviousBtn: UIButton!
    
    let cellFirstCollectionView = "GSIntroScreenCollectionViewCell"
    
    var isShowSkipBtn: Bool!
    
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
        
        NAVIGAION.hideNavigationBar(aViewController: self)
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        myCollectionView.register(UINib(nibName: cellFirstCollectionView, bundle: nil), forCellWithReuseIdentifier: cellFirstCollectionView)
    }

    func setUpModel() {
        
        myPreviousBtn.isHidden = true
        myPreviousBtn.setTitle("Previous", for: .normal)
        mySkipBtn.setTitle("Next", for: .normal)

        myPreviousBtn.addTarget(self, action: #selector(previosBtnTapped), for: .touchUpInside)
        mySkipBtn.addTarget(self, action: #selector(skipBtnTapped), for: .touchUpInside)
    }
    
    func loadModel() {
     
        isShowSkipBtn = false
    }
    
    // MARK: - Collecion View delegate and datasource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.view.frame.size.width, height: 350)
    }
    
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(indexPath.row == 0) {
            
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellFirstCollectionView, for: indexPath) as! GSIntroScreenCollectionViewCell

            aCell.gImgView.image = UIImage(named: "img_intro1")
            aCell.gLblFirst.text = "SHOW CASE YOUR WORKS"
            aCell.gLblSecond.text = "It's our destination and find out more opportunities for your job"
           
            return aCell
            
        }
        else {
            
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellFirstCollectionView, for: indexPath) as! GSIntroScreenCollectionViewCell
            
            aCell.gImgView.image = UIImage(named: "img_intro2")
            
            aCell.gLblFirst.text = "GET REWARDED"
            aCell.gLblSecond.text = "Earn cash for your work and improve your busniess"
           
            return aCell
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        var visibleRect = CGRect()
        
        visibleRect.origin = myCollectionView.contentOffset
        visibleRect.size = myCollectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = myCollectionView.indexPathForItem(at: visiblePoint) else { return }
        
        if indexPath.row == 0 {
            
            isShowSkipBtn = false
            mySkipBtn.setTitle("Next", for: .normal)
            myPreviousBtn.isHidden = true
        }
        
        else {
            
            isShowSkipBtn = true
            myPreviousBtn.isHidden = false
            mySkipBtn.setTitle("Skip", for: .normal)
        }
        
        print(indexPath)
    }
    
    
    @objc func previosBtnTapped(sender: UIButton) {
        
        isShowSkipBtn = false
        mySkipBtn.setTitle("Next", for: .normal)
        myPreviousBtn.isHidden = true
        
        let indexPath = IndexPath(row: 0, section: 0)
        myCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc func skipBtnTapped(sender: UIButton) {
        
        if (isShowSkipBtn) {
            
            SESSION.setIsAppLaunchFirstTime(isLogin: true)
            APPDELEGATE.loadHomeViewController()
        }
            
        else {
            
            isShowSkipBtn = true
            myPreviousBtn.isHidden = false
            mySkipBtn.setTitle("Skip", for: .normal)
            
            let indexPath = IndexPath(row: 1, section: 0)
            myCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

//
//  HomeController.swift
//  YZCLive
//
//  Created by 叶志成 on 2017/10/11.
//  Copyright © 2017年 叶志成. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class HomeController: UIViewController,UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}

extension HomeController {
    fileprivate func setUpUI() {
        addTapGestureForFLEX()
        navigationItem.leftBarButtonItem = UIBarButtonItem.itemWithTarget(target: self, action: #selector(searchAction), imageString: "search_head", highImageString: "search_head")
        navigationItem.rightBarButtonItem = UIBarButtonItem.itemWithTarget(target: self, action: #selector(crowAction), imageString: "head_crown", highImageString: "head_crown")
        view.backgroundColor = .white
        setupContentView()
    }
    
    fileprivate func setupContentView() {
        let homeTypes = loadTypesData()
        
        let style = YZCTitleStyle()
        style.isScrollEnable = true
        let pageFrame = CGRect(x: 0, y: kNavigationBarH , width: kScreenW, height: kScreenH - kNavigationBarH - kStatusBarH - 44)
       
        let titles = homeTypes.map({ $0.title })
        var childVcs = [AnchorViewController]()
        for type in homeTypes {
            let anchorVc = AnchorViewController()
            anchorVc.homeType = type
            childVcs.append(anchorVc)
        }
        let pageView = YZCPageView(frame: pageFrame, titles: titles, style: style, childVcs: childVcs, parentVc: self)
        view.addSubview(pageView)
    }
    
    fileprivate func loadTypesData() -> [HomeType] {
        let path = Bundle.main.path(forResource: "types.plist", ofType: nil)!
        let dataArray = NSArray(contentsOfFile: path) as! [[String : Any]]
        var tempArray = [HomeType]()
        for dict in dataArray {
            tempArray.append(HomeType(dict: dict))
        }
        return tempArray
    }
}

//MARK:- Action
extension HomeController {
    @objc private func searchAction() {
        
    }
    
    @objc private func crowAction() {
        
    }
}


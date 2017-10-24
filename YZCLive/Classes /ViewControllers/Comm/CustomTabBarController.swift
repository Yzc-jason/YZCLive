//
//  CustomTabBarController.swift
//  YZCLive
//
//  Created by 叶志成 on 2017/10/17.
//  Copyright © 2017年 叶志成. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupController()
        
    }
    
    private func setupController() {
        let homeVC = HomeController()
        self.addChildVC(childVc: homeVC, title: "广场", image: "toolbar_home", selectImage: "toolbar_home_sel")
    }
    
    private func addChildVC(childVc: UIViewController, title: String, image: String, selectImage: String) {
        childVc.title = title
        childVc.tabBarItem = UITabBarItem(title: "", image: UIImage(named: image), selectedImage: UIImage(named: selectImage))
        let nav = NavigationController(rootViewController: childVc)
        nav.isNavigationBarHidden = false
        self.addChildViewController(nav)
        
        let offset:CGFloat = 5
        childVc.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
        
    }

}

//
//  CustomTabBarController.swift
//  YZCLive
//
//  Created by 叶志成 on 2017/10/17.
//  Copyright © 2017年 叶志成. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController,YZCTabbarDelegate {
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupController()
        let tabbar = YZCTabbar()
        tabbar.tabBardelegate = self
        self.setValue(tabbar, forKey: "tabBar")
        
    }
    
    private func setupController() {
        let homeVC = HomeController()
        self.addChildVC(childVc: homeVC, title: "广场", image: "toolbar_home", selectImage: "toolbar_home_sel")
        let videoVC = ShortViewController()
        self.addChildVC(childVc: videoVC, title: "短视频", image: "toolbar_video", selectImage: "toolbar_video_sel")
        let gameVC = GameController()
        self.addChildVC(childVc: gameVC, title: "游戏中心", image: "toolbar_game", selectImage: "toolbar_game_sel")
        let profileVC = ProfileController()
        self.addChildVC(childVc: profileVC, title: "我的", image: "toolbar_me", selectImage: "toolbar_me_sel")
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
    
    
    // MARK: - YZCTabbarDelegate
    func tabBarCenterButtonAction(tabbar: YZCTabbar) {
        log.debug("点击了中间按钮")
        let liveVC = LiveController()
        liveVC.title = "录制"
        self.present(liveVC, animated: true, completion: nil)
    }

}

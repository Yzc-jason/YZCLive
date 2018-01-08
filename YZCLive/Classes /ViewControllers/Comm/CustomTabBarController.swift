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
        if UIDevice.current.isX() {
            self.tabBar.yzc_height = self.tabBar.yzc_height + 34
        }
    }

    
    private func setupController() {
        let homeVC = HomeController()
        self.addChildVC(childVc: homeVC, title: "广场", image: "MJ_toolbar_home_1_44x44_", selectImage: "MJ_toolbar_home_sel_1_44x44_")
        let videoVC = ShortViewController()
        self.addChildVC(childVc: videoVC, title: "短视频", image: "MJ_toolbar_video_1_44x44_", selectImage: "MJ_toolbar_video_sel_1_44x44_")
        let gameVC = GameController()
        self.addChildVC(childVc: gameVC, title: "游戏中心", image: "MJ_toolbar_game_1_44x44_", selectImage: "MJ_toolbar_game_sel_1_44x44_")
        let profileVC = ProfileController()
        self.addChildVC(childVc: profileVC, title: "我的", image: "MJ_toolbar_me_1_44x44_", selectImage: "MJ_toolbar_me_sel_1_44x44_")
    }
    
    private func addChildVC(childVc: UIViewController, title: String, image: String, selectImage: String) {
        childVc.title = title
        childVc.tabBarItem = UITabBarItem(title: "", image: UIImage(named: image), selectedImage: UIImage(named: selectImage))
        let nav = NavigationController(rootViewController: childVc)
        nav.isNavigationBarHidden = false
        self.addChildViewController(nav)
        if #available(iOS 11.0, *) {
             nav.navigationBar.yzc_top = childVc.view.safeAreaLayoutGuide.layoutFrame.maxY
        }
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

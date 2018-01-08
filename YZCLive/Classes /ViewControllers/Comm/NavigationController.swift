//
//  NavigationController.swift
//  YZCLive
//
//  Created by 叶志成 on 2017/10/14.
//  Copyright © 2017年 叶志成. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController,UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self
        self.setNavTheme()
    }
    
    private func setNavTheme() {
        let navBar = UINavigationBar.appearance()
        navBar.tintColor = UIColor.black
        navBar.barTintColor =  UIColor.black
        navBar.backgroundColor = UIColor.black
        if UIDevice.current.isX() {
            navBar.yzc_height =  navBar.yzc_height + 22;
        }
        
        //设置导航栏字体
        var attr: [NSAttributedStringKey: AnyObject] = [NSAttributedStringKey: AnyObject]()
        attr[.font] = UIFont.systemFont(ofSize: 18)
        attr[.foregroundColor] = UIColor.white
        navBar.titleTextAttributes = attr
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        if #available(iOS 11.0, *) {
            self.navigationBar.prefersLargeTitles = false
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.isNavigationBarHidden = true
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            let backButton = UIBarButtonItem.itemWithTarget(target: self,
                                                            action: #selector(back),
                                                            imageString: "",
                                                            highImageString: "")

            let navigateSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace,
                                                target: nil,
                                                action: nil)
            navigateSpace.width = -10
            viewController.navigationItem.leftBarButtonItems =  [navigateSpace, backButton]
        }
        super.pushViewController(viewController, animated: true)
    }
    
    @objc private func back() {
        self.popViewController(animated: true)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.viewControllers.count <= 1 { return false }
        return true
    }
}

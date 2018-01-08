//
//  YZCTabbar.swift
//  YZCLive
//
//  Created by 叶志成 on 2017/10/24.
//  Copyright © 2017年 叶志成. All rights reserved.
//

import UIKit

protocol YZCTabbarDelegate: class {
     func tabBarCenterButtonAction(tabbar:YZCTabbar)
}

class YZCTabbar: UITabBar {

    weak var tabBardelegate: YZCTabbarDelegate!
    
    lazy private var centerButton: UIButton = {
        let centerButton = UIButton.init()
        centerButton.yzc_width  = 42
        centerButton.yzc_height = centerButton.yzc_width
        centerButton.setBackgroundImage(UIImage(named: "MJ_toolbar_live_1_56x56_"), for: .normal)
        centerButton.setBackgroundImage(UIImage(named: "MJ_toolbar_live_sel_1_56x56_"), for: .highlighted)
        centerButton.addTarget(self, action:#selector(centerButtonAction) , for: .touchUpInside)
        return centerButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(self.centerButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.centerButton.yzc_centerX = self.yzc_centerX
        self.centerButton.yzc_centerY = self.yzc_height * 0.5 - 3
        if UIDevice.current.isX() {
             self.centerButton.yzc_centerY =  self.centerButton.yzc_centerY - 34 * 0.5
        }
        self.centerButton.yzc_size    = CGSize(width: (self.centerButton.currentBackgroundImage?.size.width)!, height: (self.centerButton.currentBackgroundImage?.size.height)!)
        
        var buttonIndex = 0
        for view in self.subviews {
            if view.isKind(of: NSClassFromString("UITabBarButton")!) {
                view.yzc_width = self.yzc_width / 5
                view.yzc_left  = view.yzc_width * CGFloat(buttonIndex)
                
                buttonIndex += 1
                if buttonIndex == 2 {
                    buttonIndex += 1
                }
            }
        }
        self.bringSubview(toFront: self.centerButton)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.isHidden == false {
            let newPoint = self.convert(point, to: self.centerButton)
            if self.centerButton.point(inside: newPoint, with: event) {
                return self.centerButton
            } else {
                return super.hitTest(point, with: event)
            }
        } else {
            return super.hitTest(point, with: event)
        }
    }
    
    //MARK : - Action
    @objc fileprivate func centerButtonAction() {
        self.tabBardelegate.tabBarCenterButtonAction(tabbar: self)
    }
}

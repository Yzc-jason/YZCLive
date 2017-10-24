//
//  UIBarButtonItem+Extension.swift
//  YZCLive
//
//  Created by 叶志成 on 2017/10/15.
//  Copyright © 2017年 叶志成. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    class func itemWithTarget(target: AnyObject, action: Selector, imageString: String, highImageString: String) -> UIBarButtonItem {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: imageString), for: .normal)
        btn.setBackgroundImage(UIImage(named:highImageString), for: .highlighted)
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.yzc_size = (btn.currentBackgroundImage?.size)!
        return UIBarButtonItem(customView: btn)
    }
}

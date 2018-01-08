//
//  UIDevice+Extension.swift
//  YZCLive
//
//  Created by 叶志成 on 2017/11/12.
//  Copyright © 2017年 叶志成. All rights reserved.
//

import UIKit

extension UIDevice {
    public func isX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        return false
    }
}

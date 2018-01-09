//
//  NibLoadable.swift
//  YZCLive
//
//  Created by Jason on 2018/1/9.
//  Copyright © 2018年 叶志成. All rights reserved.
//

import UIKit

protocol NibLoadable {
}

extension NibLoadable where Self : UIView {
    static func loadFromNib(_ nibname : String? = nil) -> Self {
        let loadName = nibname == nil ? "\(self)" : nibname!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
//        return Bundle.init(for: Self.self).loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}


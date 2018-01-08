
//
//  BaseModel.swift
//  YZCLive
//
//  Created by Jason on 2018/1/8.
//  Copyright © 2018年 叶志成. All rights reserved.
//

import Foundation

class BaseModel: NSObject {
    override init() {
        
    }
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}

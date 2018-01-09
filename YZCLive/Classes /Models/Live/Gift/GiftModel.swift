//
//  GiftModel.swift
//  YZCLive
//
//  Created by Jason on 2018/1/9.
//  Copyright © 2018年 叶志成. All rights reserved.
//

import Foundation

class GiftModel: BaseModel {
    @objc var img2 : String = "" // 图片
    @objc var coin : Int = 0 // 价格
    @objc var subject : String = "" { // 标题
        didSet {
            if subject.contains("(有声)") {
                subject = subject.replacingOccurrences(of: "(有声)", with: "")
            }
        }
    }
}

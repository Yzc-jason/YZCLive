//
//  AchorlModel.swift
//  YZCLive
//
//  Created by 叶志成 on 2017/10/30.
//  Copyright © 2017年 叶志成. All rights reserved.
//

import UIKit
import ObjectMapper

class AchorlModel: Mappable {
    var useridx: Int?
    var userId: String?
    var nickname: String?
    var photo: String?
    var bigpic: String?
    var allnum: Int?
    var roomid: Int?
    var serverid: Int?
    var flv: String?
    var anchorlevel: Int?
    var starlevel: Int?
    var familyName: String?
    var isSign: Bool?
    var isOnline: String?
    var nationFlag: Bool?
    var sex: Bool?
    var distance: CGFloat?
    var position: String?
    
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        useridx <- map["useridx"]
        nickname <- map["nickname"]
        photo <- map["photo"]
        allnum <- map["allnum"]
        anchorlevel <- map["anchorLevel"]
        familyName <- map["familyName"]
        isOnline <- map["isOnline"]
        position <- map["position"]
        roomid <- map["roomid"]
        serverid <- map["serverid"]
        sex <- map["sex"]
        flv <- map["flv"]
    }
}

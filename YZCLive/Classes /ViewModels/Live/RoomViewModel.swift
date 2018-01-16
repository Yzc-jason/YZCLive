//
//  RoomViewModel.swift
//  YZCLive
//
//  Created by Jason on 2018/1/16.
//  Copyright © 2018年 叶志成. All rights reserved.
//

import UIKit

class RoomViewModel: NSObject {
    lazy var liveURL : String = ""
}

extension RoomViewModel {
    func loadLiveURL(_ roomid : Int, _ userId : String, _ completion : @escaping () -> ()) {
        let URLString = "http://qf.56.com/play/v2/preLoading.ios"
        let parameters : [String : Any] = ["imei" : "36301BB0-8BBA-48B0-91F5-33F1517FA056",
                                           "roomId" : roomid,
                                           "signature" : "f69f4d7d2feb3840f9294179cbcb913f",
                                           "userId" : userId]
        NetworkTools.requestData(.get, URLString: URLString, parameters: parameters, finishedCallback: {
            result in
            guard let resultDict = result as? [String : Any] else { return }
            guard let msgDict = resultDict["message"] as? [String : Any] else { return }
            guard let requestURL = msgDict["rUrl"] as? String else { return }
            self.loadOnliveURL(requestURL, completion)
        })
    }
    
    fileprivate func loadOnliveURL(_ URLString : String, _ complection : @escaping () -> ()) {
        NetworkTools.requestData(.get, URLString: URLString, finishedCallback: { result in
            guard let resultDict = result as? [String : Any] else { return }
            guard let liveURL = resultDict["url"] as? String else { return }
            self.liveURL = liveURL
            complection()
        })
    }
}

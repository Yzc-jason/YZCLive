//
//  LiveController.swift
//  YZCLive
//
//  Created by 叶志成 on 2017/10/24.
//  Copyright © 2017年 叶志成. All rights reserved.
//

import UIKit
import LFLiveKit

class LiveController: UIViewController {

    fileprivate lazy var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.default()
        let videoConfiguartion = LFLiveVideoConfiguration.defaultConfiguration(for: .low2, outputImageOrientation: .portrait)
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguartion)
        session?.preView = self.view
        return session!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        let cancel = UIButton(frame: CGRect(x: 15, y: 50, width: 150, height: 30))
        cancel.setTitle("取消", for: .normal)
        cancel.setTitleColor(UIColor.blue, for: .normal)
        cancel.addTarget(self, action:#selector(cancelClick) , for: .touchUpInside)
        self.view.addSubview(cancel)
        
        let button = UIButton(frame: CGRect(x: 50, y: 100, width: 150, height: 30))
        button.setTitle("开始推流", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action:#selector(startClick) , for: .touchUpInside)
        self.view.addSubview(button)
    }
}

extension LiveController {
    @objc fileprivate func cancelClick(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func startClick(){
        let stream = LFLiveStreamInfo()
        stream.url = "rtmp://192.168.0.114/rtmplive/demo";
        self.session.startLive(stream)
        session.running = true
    }
}

//
//  EmoticonPackage.swift
//  YZCLive
//
//  Created by Jason on 2018/1/9.
//  Copyright © 2018年 叶志成. All rights reserved.
//

import Foundation

class EmoticonPackage {
    
    lazy var emoticons : [Emoticon] = [Emoticon]()
    
    init(plistName : String) {
        guard let path = Bundle.main.path(forResource: plistName, ofType: nil) else {
            return
        }
        
        guard let emotionArray = NSArray(contentsOfFile: path) as? [String] else {
            return
        }
        
        for str in emotionArray {
            emoticons.append(Emoticon(emoticonName: str))
        }
    }
}

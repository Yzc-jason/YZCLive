//
//  EmoticonViewModel.swift
//  YZCLive
//
//  Created by Jason on 2018/1/9.
//  Copyright © 2018年 叶志成. All rights reserved.
//

import UIKit

class EmoticonViewModel {
    static let shareInstance : EmoticonViewModel = EmoticonViewModel()
    lazy var packages : [EmoticonPackage] = [EmoticonPackage]()
    
    init() {
        packages.append(EmoticonPackage(plistName: "QHNormalEmotionSort.plist"))
        packages.append(EmoticonPackage(plistName: "QHSohuGifSort.plist"))
    }
}

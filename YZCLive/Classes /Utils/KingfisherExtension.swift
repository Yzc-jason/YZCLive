//
//  KingfisherExtension.swift
//  YZCLive
//
//  Created by Jason on 2018/1/8.
//  Copyright © 2018年 叶志成. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(_ URLString : String?, _ placeHolderName : String? = nil) {
        guard let URLString = URLString else {
            return
        }
        
        guard let url = URL(string: URLString) else {
            return
        }
        
        guard let placeHolderName = placeHolderName else {
            kf.setImage(with: url)
            return
        }
        
        kf.setImage(with: url, placeholder : UIImage(named: placeHolderName))
    }
}


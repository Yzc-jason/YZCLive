//
//  Uivew+Extension.swift
//  YZCLive
//
//  Created by 叶志成 on 2017/10/15.
//  Copyright © 2017年 叶志成. All rights reserved.
//

import UIKit

extension UIView {
    var yzc_ScreenViewX: CGFloat {
        get { return frame.origin.x }
        set(newVal) {
            var tmpFrame: CGRect = frame
            tmpFrame.origin.x = newVal
            frame = tmpFrame
        }
    }
    
    var yzc_ScreenViewY: CGFloat {
        get { return frame.origin.y }
        set(newVal) {
            var tmpFrame: CGRect = frame
            tmpFrame.origin.y = newVal
            frame = tmpFrame
        }
    }
    
    var yzc_size: CGSize {
        get { return frame.size }
        set {
            var newFrame = frame
            newFrame.size = yzc_size
            frame = newFrame
        }
    }
    
    var yzc_height: CGFloat {
        get { return frame.size.height }
        set(newVal) {
            var tmpFrame: CGRect = frame
            tmpFrame.size.height = newVal
            frame = tmpFrame
        }
    }
    
    var yzc_width: CGFloat {
        get { return frame.size.width }
        set(newVal) {
            var tmpFrame: CGRect = frame
            tmpFrame.size.width = newVal
            frame = tmpFrame
        }
    }
    
    var yzc_left: CGFloat {
        
        get { return yzc_ScreenViewX }
        set(newVal) { yzc_ScreenViewX = newVal }
    }
    
    var yzc_right: CGFloat {
        
        get { return yzc_ScreenViewX + yzc_width }
        set(newVal) { yzc_ScreenViewX = newVal - yzc_width }
    }
    
    var yzc_top: CGFloat {
        get { return yzc_ScreenViewY }
        set(newVal) { yzc_ScreenViewY = newVal }
    }
    
    var yzc_bottom: CGFloat {
        get { return yzc_ScreenViewY + yzc_height }
        set(newVal) { yzc_ScreenViewY = newVal - yzc_height }
    }
    
    var yzc_centerX: CGFloat {
        get { return center.x }
        set(newVal) {
            center = CGPoint(x: newVal, y: center.y)
        }
    }
    
    var yzc_centerY: CGFloat {
        get { return center.y }
        set(newVal) {
            center = CGPoint(x: center.x, y: newVal)
        }
    }
    
    var yzc_middleX: CGFloat {
        return yzc_width / 2
    }
    
    var yzc_middleY: CGFloat {
        return yzc_height / 2
    }
    
    var yzc_middlePoint: CGPoint {
        return CGPoint(x: yzc_middleX, y: yzc_middleY)
    }
}

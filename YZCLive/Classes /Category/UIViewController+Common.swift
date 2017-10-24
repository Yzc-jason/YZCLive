//
//  UIViewController+Common.swift
//  YZCLive
//
//  Created by 叶志成 on 2017/10/11.
//  Copyright © 2017年 叶志成. All rights reserved.
//

import UIKit
import FLEX

extension UIViewController {
 
  //MARK: - FLEX
  public func addTapGestureForFLEX() {
    #if DEBUG
      let tap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapped(sender:)))
      tap.numberOfTapsRequired = 2
      tap.numberOfTouchesRequired = 1
      self.view.addGestureRecognizer(tap)
     #endif
  }
    
    @objc private func doubleTapped(sender:Any) {
      if FLEXManager.shared().isHidden {
         FLEXManager.shared().showExplorer()
      } else {
        FLEXManager.shared().hideExplorer()
      }
    }
}

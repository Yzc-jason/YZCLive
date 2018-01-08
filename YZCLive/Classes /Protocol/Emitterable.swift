//
//  Emitterable.swift
//  YZCLive
//
//  Created by 叶志成 on 2018/1/8.
//  Copyright © 2018年 叶志成. All rights reserved.
//

import UIKit

protocol Emitterable {
    
}

extension Emitterable where Self : UIViewController {
    func startEmittering(_ point: CGPoint) {
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = point
        emitter.preservesDepth = true
        
        var cells = [CAEmitterCell]()
        for i in 0..<10 {
            let cell = CAEmitterCell()
            
            //粒子速度
            cell.velocity = 100
            cell.velocityRange = 50
            
            //粒子大小
            cell.scale = 0.7
            cell.scaleRange = 0.3
            
            //粒子方向
            cell.emissionLongitude = CGFloat(-Double.pi / 2)
            cell.emissionRange = CGFloat(Double.pi / 2 / 6)
            
            //粒子存活时间
            cell.lifetime = 3
            cell.lifetimeRange = 0.5
            
            //粒子每秒发出个数
            cell.birthRate = 1
            
            cell.contents = UIImage(named: "good\(i)_30x30")?.cgImage
            
            cells.append(cell)
        }
        emitter.emitterCells = cells
        view.layer.addSublayer(emitter)
    }
    
    func stopEmittering() {
        view.layer.sublayers?.filter({$0.isKind(of: CAEmitterLayer.self)}).first?.removeFromSuperlayer()
    }
}

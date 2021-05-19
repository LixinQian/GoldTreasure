//
//  Extension+Int.swift
//  GoldTreasure
//
//  Created by ZZN on 2017/6/28.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

extension Int32 {
    
    // 32 -> 64
    func toInt() -> Int {
        return Int(self)
    }
}
extension Int {
    func toString() -> String {
        
        return String.init(format: "%d", self)
    }
}

extension Float {
    
    //
    func toString() -> String {
        
        let str = String.init(format: "%.2f", self)
        return str
    }
}

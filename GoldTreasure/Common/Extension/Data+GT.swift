//
//  Data+GT.swift
//  GoldTreasure
//
//  Created by ZZN on 2017/6/30.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

import UIKit

extension Data {
    
    // dict -> data
    static func get(dic:NSDictionary) -> Data {
        
        let data = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWith: data)
        archiver.encode(dic)
        archiver.finishEncoding()
        return data as Data
    }
    //
//    func toDictionary() {
//        
//        
//        let unarchiver = NSKeyedUnarchiver.init(forReadingWith: self)
////       unarchiver.
////        let data = NSMutableData.init()
////        let archiver = NSKeyedArchiver.init(forWritingWith: data)
////        archiver.encode(dic)
////        archiver.finishEncoding()
////        return data as Data
//    }
}

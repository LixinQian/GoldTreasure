//
//  UILable+GT.swift
//  GoldTreasure
//
//  Created by ZZN on 2017/8/22.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//
import UIKit
extension UILabel {
    
    // 初始化按钮
    class func intiWith(title:String? = nil,titleFont:UIFont? = nil,titleColor:UIColor? = nil,bgColor:UIColor? = nil) ->UILabel {
        
        let lab = UILabel()
        lab.text = title
        lab.font = titleFont
        lab.textColor = titleColor
        lab.backgroundColor = bgColor
        return lab
    }
}

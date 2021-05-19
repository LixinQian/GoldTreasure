//
//  UIColor+QM.swift
//  QianmiQB
//
//  Created by lemac on 2017/3/14.
//  Copyright © 2017年 Qianmi Network. All rights reserved.
//

import UIKit

extension UIColor {

    //获取16进制颜色
    class func colorWithHexString (hexColor:String,alapha:CGFloat?) -> UIColor {
        
        
        var cString:String = hexColor.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            
            let index = cString.index(cString.startIndex, offsetBy: 1)
            cString = cString.substring(from: index)
            
        } else if cString.hasPrefix("0X") {
            
            let index = cString.index(cString.startIndex, offsetBy: 1)
            cString = cString.substring(from: index)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.white
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
//         debugPrint("r,g,b",r,g,b)
        
        if alapha == nil {
            
            return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1)
        } else {
            return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alapha!)
        }
    }
    func makeColorLight(color:UIColor) ->UIColor {
        
        //获得RGB值描述
        let RGBValue = String.init(format: "%@", color)
        //将RGB值描述分隔成字符串
        let RGBArr =  RGBValue.components(separatedBy: " ")
        //获取红色值
        let r = Int(RGBArr[1])! * 255
        //获取绿色值
        let g = Int(RGBArr[2])! * 255 //[[RGBArr objectAtIndex:2] intValue] * 255
        //获取蓝色值
        let b = Int(RGBArr[3])! * 255//[[RGBArr objectAtIndex:3] intValue] * 255
        return UIColor.init(red: CGFloat(r)*0.9, green: CGFloat(g)*0.9, blue: CGFloat(b)*0.9, alpha: 1)
    }
}

//
//  UIImage+GT.swift
//  GoldTreasure
//
//  Created by ZZN on 2017/7/5.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

import Foundation
extension UIImage {
    
    /** 通过颜色生成图片 */
    class func initWith(color:UIColor) -> UIImage {
        
        let rect = CGRect(x:0, y:0, width:100, height:100)
        UIGraphicsBeginImageContext(rect.size)
        //获取上下文
        let context = UIGraphicsGetCurrentContext()
        //填充颜色
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    //
//    func blur(closure:@escaping (_ image:UIImage)->()) {
//        
//        
//        DispatchQueue.global().async {
//            
//            let ciImage = CIImage.init(image: self)
//            
//            let filter = CIFilter.init(name: "CIGaussianBlur")!
//            filter.setValue(ciImage, forKey: kCIInputImageKey)
//            filter.setValue("8", forKey: "inputRadius")
//            
//            
//            let context = CIContext.init(options: nil)
//            let res = filter.value(forKey: kCIOutputImageKey) as!CIImage
//            let out = context.createCGImage(res, from: res.extent)
//            
//            let image = UIImage.init(cgImage: out!)
//            
//            closure(image)
//            
//        }
//}
}

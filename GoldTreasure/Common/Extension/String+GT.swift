//
//  String+QM.swift
//  QianmiQB
//
//  Created by zzn on 2017/3/30.
//  Copyright © 2017年 Qianmi Network. All rights reserved.
//

import UIKit

extension String {
    
    
    //获得行间距富文本
    func getAttrFormString(lineH:CGFloat,font:UIFont) ->NSMutableAttributedString {
        
        let paragrapStyle = NSMutableParagraphStyle()
        paragrapStyle.lineSpacing = lineH
        paragrapStyle.alignment = NSTextAlignment.left
        //        paragrapStyle.lineSpacing =
        paragrapStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        let attr = NSMutableAttributedString.init(string: self)
        attr.addAttributes([NSParagraphStyleAttributeName:paragrapStyle,NSFontAttributeName:font,NSForegroundColorAttributeName:UIColor.red], range: NSMakeRange(0, attr.length))
        return attr
    }
    //截取字符 To
    func subToOffset(right:Int) ->String {
        
        if self.characters.count < right {
            
            return self
        }
        let index = self.index(self.startIndex, offsetBy: right)
        return self.substring(to: index)
    }
    //截取字符 From
    func subFromOffset(left:Int) ->String {
        
        if self.characters.count < left {
            
            return ""
        }
        let index = self.index(self.startIndex, offsetBy: left)
        return self.substring(from: index)
    }
    
    //md5 
    func md5() -> String {
        
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)

        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize()
        return hash.lowercased //String(format: hash as String)
    }
}
//
extension NSString {
    
    //md5
    func md5() -> String {
        
        let str = self.cString(using: String.Encoding.utf8.rawValue)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8.rawValue))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize()
        return hash.lowercased //String(format: hash as String)
    }
    //获得行间距富文本
    func getAttrFormString(lineH:CGFloat,font:UIFont) ->NSMutableAttributedString {
        
        let paragrapStyle = NSMutableParagraphStyle()
        paragrapStyle.lineSpacing = lineH
        paragrapStyle.alignment = NSTextAlignment.left
        //        paragrapStyle.lineSpacing =
        paragrapStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        let attr = NSMutableAttributedString.init(string: self as String)
        attr.addAttributes([NSParagraphStyleAttributeName:paragrapStyle,NSFontAttributeName:font,NSForegroundColorAttributeName:UIColor.red], range: NSMakeRange(0, attr.length))
        return attr
    }
}

extension String {
    
    //得到字符串
    static func getFrom(dict:Dictionary<String,AnyObject>) ->String? {
       
        let data = try? JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0)) 
        
        let jsonStr = String.init(data: data ?? Data(), encoding: String.Encoding.utf8)
        return jsonStr
        
    }
}

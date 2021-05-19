//
//  GTSecUtils.swift
//  GoldTreasure
//
//  Created by ZZN on 2017/6/29.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

import UIKit
//import MJExtension
import SwiftyJSON
import CryptoSwift

class GTSecUtils: NSObject {
    
    // 密码加盐
    class func pwdAddSalt(phone:String,pwd:String) -> String {
        
        let saltStr = phone.subToOffset(right: 6)
        let newPwd = saltStr + pwd
        return newPwd.md5()
    }
    
    // params -> str 加签
    class func paramsMd5(dict:NSDictionary?) -> (md5:String,time:String) {
        
        let times = Date.init()
        
        let timeInterval = times.timeIntervalSince1970
        let timeSec = Int(timeInterval).toString()
    
        // 根据规则 拼接 先trim 后
        let enstr =  NSString(format: "time%@token%@%@%@",timeSec,getToken(),dict?.jsonString() ?? "",getSecKey())
            .trimmingCharacters(in: CharacterSet.whitespaces) as NSString

        //url encode
        let urlEncodeStr = enstr.urlEvalutionEncoding() as NSString
        let md5Str = urlEncodeStr.md5()
        return (md5Str,timeSec)
    }
    
    // 获取默认token
    class func getToken() -> String {
        
        return GTUser.getToken()
    }
    
    // 获取加密key
    class func getSecKey() -> String {
        
        return GTUser.getKey()
    }
    
    // 获取获取URl拼接地址 params
    class func appendHeaderUrlParams(token:String,time:String,sign:String) ->[String:String] {
        
        
        var headerParams = Dictionary<String,String>()
        headerParams["token"] = token
        headerParams["time"] = time
        headerParams["sign"] = sign
        
        return headerParams
    }
    // 获取获取URl拼接地址 字符串
    class func appendUrlParamsString(token:String,time:String,sign:String) -> String {
        
        let str = String.init(format: "token=%@&time=%@&sign=%@", token,time,sign)
//        debugPrint("url--->\n",str)
        return str
    }
    
    // 加密AES 加密
    class func encodeAlipayPasswordByAES128(strToEncode:String) -> String {

        
        // 要加密串
        let ps = strToEncode.data(using: String.Encoding.utf8)

        // 加密 KEY
        let key: Array<UInt8> =  (GTALIAES128KEY.data(using: String.Encoding.utf8)?.bytes)!
        let iv: Array<UInt8> = [UInt8]()

        let aes = try! AES(key: key, iv: iv, blockMode: .ECB, padding: PKCS7.init())
        // aes 二进制
        let dd = try! aes.encrypt(ps!.bytes)

        let encoded = Data.init(bytes: dd)

        debugPrint("AES 加密串:\(encoded.toHexString())")
        //加密结果要hex转码
        return  encoded.toHexString().uppercased()
    }
}

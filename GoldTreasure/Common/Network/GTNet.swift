//
//  GTNet.swift
//  GoldTreasure
//
//  Created by ZZN on 2017/6/27.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

import UIKit
import Alamofire
//import RxSwift
//import RxCocoa
import SwiftyJSON

/// 网络 地址配置
///
/// - dev: 开发者
/// - foraml: 正式
/// - test: 测试
//public enum GTApiUrl:String {
//    
//    case dev
//    case foraml
//    case test

//    // 获取URL
//    func url() -> String {
//        switch self {
//            // 开发者
//        case .dev:
//            return api.dev.ali
//            // 正式
//        case .foraml:
//            return api.formal.ali
//            // 测试
//        case .test:
//            return api.test.ali
//        }
//    }
//    
//    // API 地址 列表
//    private struct api {
//        
//        struct dev {
//            
//            static let local1 = "http://192.168.1.157:8080/huajinbao/appservice"
//            static let local2 = "http://192.168.2.99:8080/huajinbao/appservice"
//
//            static let ali =  GTNet.getNetDomain() + "/huajinbao/appservice"
//        }
//        struct formal {
//            static let ali = GTNet.getNetDomain()  + "/huajinbao/appservice"
//        }
//        
//        struct test {
//            static let local1 = "http://192.168.1.157:8080/huajinbao/appservice"
//            static let ali = "http://101.37.163.179:8082/huajinbao/appservice"
//        }
//    }
//}

class GTNet: NSObject {
    
    // app 连接地址
    var appUrlCompentStr = "huajinbao/appservice"
    
    // block 回调
    typealias successClosure = (_ value:AnyObject) -> Void
    typealias failureClosure = (_ error:GTNetError) -> Void
    typealias successFileClosure = (_ value:Data?) -> Void
    typealias completedClosure = (_ value:Data?) -> Void

    // 网络配置
    static let netType = GTNetType.dev
    // 监听网络连接
    var netReachability = NetworkReachabilityManager.init(host: "www.baidu.com")
    //获取网络状态
    class func isAccNet() -> Bool {
        
        return GTNet.manger.netReachability?.isReachable ?? false
    }
    
    // 获取 服务连接 URL
    class func getAppServiceUrl() -> String {
        
        return GTNet.getNetDomain() + "/" + APPAPICOMPENTSTR
    }
    
    // 获取网络 站点 兼容OC
    class func getNetDomain() -> String {
        
        // 读取归档
        let code = UserDefaults.standard.object(forKey: APPNETTYPEKEY) as? Int ?? 0;
        switch code {
            
            case GTNetType.dev.rawValue:
                return APIURLDEV
            case GTNetType.formal.rawValue:
                return APIURLFormal
            default:
                return ""
        }
    }
    
    // 获取连接网络的 类型 测试 开发 正式 兼容OC
    class func getNetType() -> GTNetType{
    
        // 读取归档
        let code = UserDefaults.standard.object(forKey: APPNETTYPEKEY) as? Int ?? 0;
        switch code {
        case GTNetType.dev.rawValue:
            return GTNetType.dev
        case GTNetType.formal.rawValue:
            return GTNetType.formal
        default:
            return GTNetType.test
        }
    }
    // 设置 连接网络的 类型 兼容OC
    class func setNetType(type:GTNetType) {
        
        // 写入归档
        func saveTo(code:Int) {
            UserDefaults.standard.set(code, forKey: APPNETTYPEKEY)
        }
        
        switch (type) {
            
        case GTNetType.formal:
            saveTo(code: GTNetType.formal.rawValue)
        case GTNetType.dev:
            saveTo(code: GTNetType.dev.rawValue)
        default:
            saveTo(code: GTNetType.test.rawValue)
            break
        }
    }
    
    // 设置 默认类型 类型 兼容OC
    class func setNetTypeDefault() {
        
        if __DEV.toInt() == true.hashValue {
            
            GTNet.setNetType(type: GTNetType.dev)
        } else {
            
            GTNet.setNetType(type: GTNetType.formal)
        }
    }
    
    //入口
    static let manger:GTNet = {
        
        let instance = GTNet()
//        instance.initNet()
        return instance
    }()
    
    //私有化实例
    private override init() {
        super.init()
    }
}

//
extension GTNet {
    
    /// 文件 断点续传 upanyun
    ///
    /// - Parameters:
    ///   - filaData: 文件二进制文件
    ///   - fileName: 文件名 当做key值，含目录 /xx/xx.mov
    ///   - progress: 上传过程
    ///   - succ: 成功 回调url
    ///   - fail: 失败 回调gtneterror
    
    static func upLoad(filaData:Data,fileName:String,progress: ((Float)->Void)?,succ: ((_ fileUrl:String)->Void)?,fail: ((_ err:GTNetError)->Void)?) {
        
        // 判断网络状态
        if GTNet.isAccNet() == false {
            
            let error = GTNetError.init(errCode: 1005, msg: "未连接网络")
            if fail != nil {
                fail!(error)
            }
            return
        }
        
        let manger = UpYunFormUploader()
        manger.upload(withBucketName: UPYUNBUCKETNAME, operator: UPYUNOPERATOR, password: UPYUNPASSWORD, fileData: filaData, fileName: nil, saveKey: fileName, otherParameters: nil, success: { (res, params) in
           

            let fileUrl = String.init(format: "http://%@.b0.upaiyun.com/%@",UPYUNBUCKETNAME, fileName)
            if succ == nil { return }
            succ!(fileUrl)
            
        }, failure: { (error, res, params) in
            
            let nsErr =  error! as NSError
            let err = GTNetError.init(errCode: nsErr.code, msg: params?["message"] as? String ?? error!.localizedDescription)
            if fail == nil { return }
            fail!(err)
            
        }) { (completed, total) in
            
            let pro:Float = Float(completed) / Float(total)
            if progress == nil { return }
            progress!(pro)
        }
    }
    
    //post请求
    static func post(url:String,params:NSDictionary, success:@escaping successClosure, failure:@escaping failureClosure) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // 判断网络状态
        if GTNet.isAccNet() == false {
            
            let error = GTNetError.init(errCode: 1005, msg: "未连接网络")
            failure(error)
            return
        }

        // request 请求
        var urlReq = try? URLRequest.init(url: url, method: HTTPMethod.post)
        
        // params md5
        let md5Str = GTSecUtils.paramsMd5(dict: params)
        let signBodyStr = GTSecUtils.appendUrlParamsString(token: GTSecUtils.getToken(), time: md5Str.time, sign: md5Str.md5)
        
        // 拼接URL 参数
        let paramsUrl = url.appendingFormat("?%@", signBodyStr)
        debugPrint("请求的url 地址信息-->\n",paramsUrl)
        urlReq?.url = URL(string: paramsUrl)
        
        
        // inputstream 加入 参数
        let dataStr = params.yy_modelToJSONString()
        let data = dataStr?.data(using: String.Encoding.utf8) ?? Data()
        urlReq?.httpBodyStream =  InputStream.init(data: data)
        urlReq?.cachePolicy = URLRequest.CachePolicy.useProtocolCachePolicy
        urlReq?.timeoutInterval = 30

        request(urlReq!)
            .validate(contentType:  ["application/x-www-form-urlencoded","text/html","application/json"])
            .responseJSON(completionHandler: { (res) in
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if res.result.isSuccess {
                    
                    // json data
                    guard let jsonData = res.data else {
                        success(NSDictionary())
                        return
                    }
                    // 解析json -> dict
                    guard let dict = JSON.init(data: jsonData).dictionaryObject else {
                        
                        success(NSDictionary())
                        return
                    }
                    
                    // 根据状态码 判断
                    let model = GTResModelCommon.yy_model(with: dict)
                    debugPrint(dict.debugDescription)
                    if model?.status == 0 {
                        
                        // 判断 body 类型
                        if let bodyParams = model?.body as? NSDictionary {
                            
                            let copyParams = NSMutableDictionary(dictionary: bodyParams)
                            copyParams["message"] = model?.message ?? ""
                            success(bodyParams)
                        } else if let arrList = model?.body as? NSArray {
                            
                            success(arrList)
                        } else if let jsonStr = model?.body as? NSString  {
                            
                            success(jsonStr)
                        } else {
                            
                            let dict = NSMutableDictionary()
                            dict["message"] = model?.message ?? ""
                            success(dict)
                        }
                        
                    } else {
                        
                        let code = model?.status ?? 500
                        let error = GTNetError.init(errCode: Int(code), msg: model?.message ?? "未知错误")
                        failure(error)
                    }
                }
                
                if res.result.isFailure || res.error != nil {
                    
                    
                    let code = res.response?.statusCode ?? 500
                    let error = GTNetError.init(errCode: code, msg: "服务连接失败")
                    failure(error)
                    debugPrint(res.debugDescription)
                }
                
            })
    }
}

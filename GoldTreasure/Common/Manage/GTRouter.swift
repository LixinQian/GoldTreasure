//
//  GTRouter.swift
//  GoldTreasure
//
//  Created by ZZN on 2017/7/11.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

import UIKit

enum GTRouterUrl:String {
    
    static let rootDoc = "/"
    static let currentDoc = "./"
    
    // 跳转验证
    case auth = "huajinbao://auth.list"
    // 跳转返款
    case repay = "huajinbao://repay.list"
    // 跳转到订单
    case order = "huajinbao://repay.order"
    // 跳转主页
    case mainPage = "huajinbao://go.index"
    
    func router()->String {
        
        return GTRouterUrl.aliasRouter(url: self.rawValue)
    }
    
    func mClass()->String {
        
        switch self {
        case .auth:
            return "GTAuthCenterViewController"
        case .repay:
            return "PaybackViewController"
        case .order:
            return "PaybackViewController"
        case .mainPage:
            return "GTHomePageController"
        }
    }
    
    // 指定router 为 ./xx 格式
    static func aliasRouter(url:String) -> String {
        
        if url == GTRouterUrl.mainPage.rawValue {
            
            return  GTRouterUrl.rootDoc + GTRouterUrl.mainPage.rawValue
        }
        return GTRouterUrl.currentDoc + url
    }
    //    struct Map {
    //
    //        struct Auth {
    //            static let mRouter = GTRouterUrl.auth.url()
    //            static let mClass = GTRouterUrl.auth.controller()
    //        }
    //
    //        struct Reapy {
    //
    //            static let mRouter = GTRouterUrl.repay.url()
    //            static let mClass = GTRouterUrl.repay.controller()
    //        }
    //
    //        struct order {
    //
    //            static let mRouter = GTRouterUrl.order.url()
    //            static let mClass = GTRouterUrl.order.controller()
    //        }
    //
    //        struct mainPage {
    //
    //            static let mRouter = GTRouterUrl.mainPage.url()
    //            static let mClass = GTRouterUrl.mainPage.controller()
    //        }
    //    }
}

enum GTRouterNavController {
    
    case current    // 当前目录跳转
    case root       // 根目录跳转
    case up         // 上级目录跳转
    case popCurrent // pop当前控制器，不做跳转
    
    // 获取控制器
    func getController() -> UINavigationController {
        switch self {
        case .up:
            return GTHUD.upCurrentNav()
        case .root:
            return GTHUD.rootNav()
        case .popCurrent:
            return GTHUD.currentNav()
        default:
            return GTHUD.currentNav()
        }
    }
}


class GTRouter: NSObject {
    
    // 请求 别名
    class func routerWithUrl(str:String) {
        // 过滤
        let url = GTRouterUrl.aliasRouter(url: str)
        open(url: url)
    }
    // 打开URL
    class func open(url:String) {
        
        GTRouterMapping.manger.open(url: url, params: nil)
    }
    // 打开URL
    class func open(url:String,navController:UIViewController,userInfo:Dictionary<String,AnyObject>) {
        
    }
}

// 路由
class GTRouterMapping:NSObject {
    
    
    private var mappingList = [Dictionary<String,AnyObject>]()
    
    private override init() {
        super.init()
    }
    static let manger:GTRouterMapping = {
        
        let instance = GTRouterMapping()
        return instance
    }()
    
    // 通过 URL 跳转
    public func open(url:String,params:(Dictionary<String,Any>)? ) {
        
        var isJump = true
        if (url == GTRouterUrl.mainPage.router()) {
            isJump = false
        }
        
        open(url: url, params: params, isJump: isJump)
    }
    
    
    // 通过 URL 是否 跳转
    public func open(url:String,params:(Dictionary<String,Any>)?, isJump:Bool) {
        
        let apis = GTRouterApi.manger
        let mMirror = Mirror.init(reflecting: apis)
        
        var dict = [String:AnyObject]()
        for item in mMirror.children {
            
            guard let mValue = item.value as? GTRouterApi.Router else { return }
            
            // 查找 router
            if url == mValue.mRouter {
                
                dict["mClass"] = mValue.mClass as AnyObject
                dict["mDict"] = params == nil ? params as AnyObject : NSDictionary()
                
            }
        }
        // 没有查找到 router
        if dict["mClass"] == nil {
             dict["mClass"]  = "GTDefaultController" as AnyObject
        }

        // 目前URL 未统一 先指定别名 跳转
        let viewController = parseNavController(url: url)
        
        if isJump == true {
            
            GTAdapt.push(dict, andNavController: viewController)
        }
    }
    
    
    
    // 通过 Router 跳转
    public func open(router:GTRouterApi.Router,params:(Dictionary<String,Any>)?) {
        
        let apis = GTRouterApi.manger
        let mMirror = Mirror.init(reflecting: apis)
        
        for item in mMirror.children {
            
            guard let mValue = item.value as? GTRouterApi.Router else { return }
            
            if router == mValue {
                
                open(url: mValue.mRouter, params: params)
            }
        }
    }
    
    // 判断 Router 目录 / ./ ../
    private func parseNavController(url:String) -> UINavigationController {
        
        let pattern = "^\\.*";
        let range = GTVerification.parseRouterPattern(pattern, with: url)
        
        switch range.length {
            
        case 0:
            
            return GTHUD.rootNav()
        case 1:
            
            return GTHUD.currentNav()
        case 2:
            
            return GTHUD.upCurrentNav()
        default:
            
            return GTHUD.currentNav()
        }
    }
    
    public func mirrorTest() {
        
        
        let apis = GTRouterApi()
        let mValue = Mirror.init(reflecting: apis)
        
        for item in mValue.children {
            let api = item.value as? GTRouterApi.Router
            debugPrint(api ?? "")
        }
    }
}


class GTRouterApi:NSObject {
    
    let auth = GTRouterApi.Router(mClass: GTRouterUrl.auth.mClass(), mRouter: GTRouterUrl.auth.router())
    let mainPage = GTRouterApi.Router(mClass: GTRouterUrl.mainPage.mClass(), mRouter: GTRouterUrl.mainPage.router())
    let order = GTRouterApi.Router(mClass: GTRouterUrl.order.mClass(), mRouter: GTRouterUrl.order.router())
    let repay = GTRouterApi.Router(mClass: GTRouterUrl.repay.mClass(), mRouter: GTRouterUrl.repay.router())
    
    static let manger:GTRouterApi = {
        
        let instance = GTRouterApi()
        return instance
    }()
    
    // todo: load from xml
    func loadConfigXml() {
        
    }
    
    struct Router:Equatable {
        var mClass:String
        var mRouter:String
        
        public static func == (lhs: Router, rhs: Router) -> Bool {
            
            if lhs.mClass == rhs.mClass && lhs.mRouter == rhs.mRouter {
                
                return true
            } else {
                
                return false
            }
        }
    }
}













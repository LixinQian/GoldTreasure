//
//  GTClient.swift
//  GoldTreasure
//
//  Created by ZZN on 2017/6/28.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

import UIKit
import UserNotifications
import SwiftyJSON
import IQKeyboardManager
import YYModel
import AudioToolbox
import Alamofire


class GTClient: NSObject {
    
    // 默认配置
    func config() {
        
        initAPP()
        initSDK()
    }
    
    // app 初始化配置
    func initAPP() {
        
        // 启动设置
        configureStartApp()
        // 配置realm
        GTRealmService.configureRealm()
        //配置客户端 连接网络类型
        //         GTNet.setNetType(type: GTNetType.formal)
        GTNet.setNetTypeDefault();
        // 更新app 和 验证信息
        GTCheck.checkUpdateVerAndProfile()
        // 样式设置
        setupUI()
    }
    
    // 设置UI
    func setupUI() {
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    // 启动 设置
    func configureStartApp() {
        
        // 初始化root控制器
        if GTClient.isShowGuider()  {
            
            // 引导页
            let vc = GTGuiderImgVC()
            vc.guidePicArr = ["00_主页","01_引导页","02_引导页","03_引导页"]
            
            vc.tapEndBlock = { Void in
                
                UIApplication.shared.keyWindow?.rootViewController  = GTRootTabbarVC.shareInstance;
            }
            UIApplication.shared.keyWindow?.rootViewController = vc
        } else {
            UIApplication.shared.keyWindow?.rootViewController  = GTRootTabbarVC.shareInstance;
        }
        // 清空角标
        UIApplication.shared.applicationIconBadgeNumber = 0
        GeTuiSdk.resetBadge()
    }
    
    // initSdk
    func initSDK() {
        
        // 个推送
        GeTuiSdk.start(withAppId: GETUIAPPID, appKey: GETUIAPPKEY, appSecret: GETUIAPPSECRET, delegate: self)
        registerRemoteNotification()
        
        // 初始化网易im
        GTQiYuCustomerService.initializeQIYUConfiguration()
        
        // 设置IQKeyBoard
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        IQKeyboardManager.shared().shouldShowTextFieldPlaceholder = false
        IQKeyboardManager.shared().keyboardDistanceFromTextField = 150
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        // 屏蔽不兼容类
        let disableClass = [QYSessionViewController.classForCoder()]
        IQKeyboardManager.shared().disabledDistanceHandlingClasses.addObjects(from: disableClass)
    }
    
    /** 注册用户通知(推送) */
    func registerRemoteNotification() {
        
        let systemVer = (UIDevice.current.systemVersion as NSString).floatValue;
        if systemVer >= 10.0 {
            
            if #available(iOS 10.0, *) {
                
                let center:UNUserNotificationCenter = UNUserNotificationCenter.current()
                center.delegate = self;
                center.requestAuthorization(options: [.alert,.badge,.sound], completionHandler: { (granted:Bool, error:Error?) -> Void in
                    
                })
                
                UIApplication.shared.registerForRemoteNotifications()
            }
            
        } else {
            
            if #available(iOS 8.0, *) {
                let userSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(userSettings)
                
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    //管理实例
    static let manger:GTClient = {
        
        let instance = GTClient()
        instance.config()
        return instance
    }()
    
    private override init() {
        super.init()
    }
}
/** 客服端-管理类-实例方法 */
extension GTClient {
    
    //是否第一次启动
    class func isFrinstLaunch() ->Bool {
        
        if !UserDefaults.standard.bool(forKey: APPFRISTLAUNCHKEY) {
            
            UserDefaults.standard.set(true, forKey: APPFRISTLAUNCHKEY)
            UserDefaults.standard.set(true, forKey: APPISSHOWGUIDEPIC)
            return true
        }
        return false
    }
    //是否显示 引导图
    class func isShowGuider() -> Bool {
        
        if GTUser.getAppVer() != GTClient.clientVersion() {
            let ver = GTClient.clientVersion()
            GTUser.setAppVer(ver: ver)
            GTUser.setIsShowGuider(isOk: true)
        }
        
        return GTUser.getIsShowGuider()//UserDefaults.standard.bool(forKey: APPISSHOWGUIDEPIC)
    }
    
    //客服端 版本号
    class func clientVersion() -> String {
        
        guard let appV:String = getAppInfoDict()["CFBundleShortVersionString"] as? String else { return "0"}
        return appV
    }
    
    //appinfo 集合
    class func getAppInfoDict() -> [String:Any]{
        
        guard let infoDict = Bundle.main.infoDictionary else { return ["":""]}
        return infoDict
    }
    
}

/** SDK收到透传消息回调 */
extension GTClient:GeTuiSdkDelegate {
    
    // MARK: - 用户通知(推送) _自定义方法
    // 个推注册成功
    func geTuiSdkDidRegisterClient(_ clientId: String!) {
        
        // 设置个推 Client ID
        GTUser.setGeTuiClentID(client: clientId)
        debugPrint("client id",clientId)
    }
    /** SDK收到透传消息回调 */
    func geTuiSdkDidReceivePayloadData(_ payloadData: Data!, andTaskId taskId: String!, andMsgId msgId: String!, andOffLine offLine: Bool, fromGtAppId appId: String!) {
        
        // 暂时只显示 有无新通知
        GTUser.setAppHasNoReadNoti(isFrist: true);
        if payloadData == nil { return }
        guard let info = String(data: payloadData, encoding: String.Encoding.utf8) else { return }
        guard let dict = JSON.init(parseJSON: info).dictionaryObject else { return }
        guard let payload = dict["payload"] as? Dictionary<String,String> else { return };
        let model = GTNotificationModel.yy_model(withJSON: payload)
        
        // 加入通知 缓存
        GTNoti.manger.saveNotiToDB(playDict: model?.yy_modelToJSONObject() as? Dictionary<String, AnyObject>)
        // 刷新个人信息
        GTUser.manger.reloadUserInfo(succ: nil, fail: nil)
        // 收到 通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIGETUINEWNOTIKEY), object: nil, userInfo: nil)
        // 加入震动提示
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        
    }
}


/** iOS 10中收到推送消息 */
extension GTClient:UNUserNotificationCenterDelegate {
    
    //  iOS 10: App在前台获取到通知
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        debugPrint("willPresentNotification: %@",notification.request.content.userInfo);
        completionHandler([.badge,.sound,.alert]);
    }
    //  iOS 10: 点击通知进入App时触发
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        debugPrint("didReceiveNotificationResponse: %@",response.notification.request.content.userInfo);
        // [ GTSdk ]：将收到的APNs信息传给个推统计
        GeTuiSdk.handleRemoteNotification(response.notification.request.content.userInfo);
        completionHandler();
        
        let vc = GTNotificationController()
        vc.hidesBottomBarWhenPushed = true
        GTHUD.currentNav().pushViewController(vc, animated: true)
    }
}

//
//  GTUser.swift
//  GoldTreasure
//
//  Created by ZZN on 2017/6/28.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa


fileprivate let USERMODELCHANGENOTI = "USERMODELCHANGENOTI"

class GTUser: NSObject {
    
    // 监听网络连接
    //    fileprivate var netReachability = NetworkReachabilityManager.init(host: "www.baidu.com")
    private var changedInfoBlock:((_ model:GTResModelUserInfo)->Void)?
    
    
    let dispostBag = DisposeBag()
    
    //登录成功后
    var userInfoModel:GTResModelUserInfo? {
        didSet{
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: USERMODELCHANGENOTI), object: nil)
            
            //            if changedInfoBlock != nil && userInfoModel != nil {
            //                changedInfoBlock!(userInfoModel!)
            //            }
        }
    }
    
    // 监听个人信息 修改
    func listenUserInfoChanged(changed:@escaping (_ model:GTResModelUserInfo)->Void) {
        
        NotificationCenter.default.rx.notification(Notification.Name(rawValue: USERMODELCHANGENOTI), object: nil).subscribe(onNext: {
            [weak self] (noti) in
            
            changed(self?.userInfoModel ?? GTResModelUserInfo())
        }).addDisposableTo(dispostBag)
        
        //        changed!(userInfoModel!)
        //        changedInfoBlock = changed
    }
    
    //监听登录失败
    func listnLoginSucc() {
        
    }
    
    // 刷新个人信息
    func reloadUserInfo(succ:((_ model:GTResModelUserInfo)->())?,fail:((_ error:GTNetError?)->())?) {
        
        GTLoginService.sharedInstance().refresh({ (res) in
            
            guard let model = res else { return }
            // 更新个人信息model
            GTUser.manger.userInfoModel = model;
            
            if succ != nil { succ!(model) }
            
        }) { (error) in
            
            if fail != nil { fail!(error) }
        }
    }
    // 显示登录页面操作
    func loginIn(succ:((_ model:GTResModelUserInfo)->Void)? = nil,fail:((_ err:GTNetError)->Void)? = nil) {
        
        let vc = GTLoginRoot()
        guard let loginVC = vc.viewControllers.first as? GTLoginController else { return }
        
        loginVC.loginUser({ (model) in
            
            let resModel = model as?GTResModelUserInfo ?? GTResModelUserInfo()
            if succ != nil { succ!(resModel) }
            
        }) { (err) in
            
            if fail != nil { fail!(err!) }
        }
        
        GTHUD.currentNav().present(vc, animated: true, completion: nil)
    }
    // 退出登录
    func logoutWith(title:String?,proTitle:String?, succ:((Void)->Void)?,fail:((Void)->Void)?) {
        
        GTUser.manger.userInfoModel = GTResModelUserInfo()
        // 重置 token
        GTUser.setLogin(islogin: false)
        GTHUD.showStatus(title: proTitle ?? "")
        
        let time: TimeInterval = 1.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            
            //code
            GTHUD.showSuccess(title: title ?? "退出成功")
            if succ != nil { succ!() }
        }
    }
    
    
    // 监听个人信息
    func initNoti() {
        
        // 登录成功通知
        NotificationCenter.default.rac_addObserver(forName: NOTIUSERLOGINSUCC, object: nil).subscribeNext { [weak self] (noti) in
            self?.reloadUserInfo(succ: nil, fail: nil)
        }
        // 监听网络连接
        GTNet.manger.netReachability?.listener = { status in
            
            switch status {
            case .notReachable:
                GTHUD.showToast(info: "网络断开连接")
            default:
                break
            }
        }
        GTNet.manger.netReachability?.startListening()
    }
    // 销毁
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //管理实例
    static let manger:GTUser = {
        
        let instance = GTUser()
        instance.initNoti()
        return instance
    }()
    
    private override init() {
        super.init()
    }
}

// 类方法
extension GTUser {
    //是否登陆
    class func isLogin() -> Bool {
        let bools = UserDefaults.standard.bool(forKey: USERISLOGIN)
        debugPrint(bools)
        return bools
    }
    
    //设置登陆状态
    class func setLogin(islogin:Bool) {
        
        if islogin == false {
            
            GTUser.clearCurrentUserID()
            GTUser.resetToken()
            
        } else {
            
        }
        UserDefaults.standard.set(islogin, forKey: USERISLOGIN)
        let bools = islogin
        debugPrint(bools)
    }
    //登录客服端
    class func saveLoginUser(phone:String, cusId:NSNumber, token:String) {
        
        setUserPhoneNo(phone: phone)
        setCurrentUserID(cusID: cusId)
        setToken(token:token)
        setLogin(islogin: true)
    }
    //设置当前用户手机号
    class func setUserPhoneNo(phone:String) {
        UserDefaults.standard.set(phone, forKey: APPCURRENTPHONENO)
    }
    //设置手机号
    class func getUserPhoneNo() -> String? {
        return UserDefaults.standard.object(forKey: APPCURRENTPHONENO) as? String ?? nil
    }
    
    //设置当前用户ID
    class func setCurrentUserID(cusID:NSNumber) {
        
        UserDefaults.standard.set(cusID, forKey: APPCURRENTUSERID)
    }
    //清除设置当前用户ID
    class func clearCurrentUserID() {
        
        UserDefaults.standard.removeObject(forKey: APPCURRENTUSERID)//set(cusID, forKey: APPCURRENTUSERID)
    }
    //得到当前用户的ID
    class func getCurrentUserID() -> NSNumber? {
        
        return UserDefaults.standard.object(forKey: APPCURRENTUSERID) as? NSNumber ?? nil
    }
    
    // 获取 clientid 个推
    class func getGeTuiClentID() -> String {
        
        return UserDefaults.standard.object(forKey: APPCLIENTID) as? String ?? ""
    }
    // 设置 clientid 个推
    class func setGeTuiClentID(client:String) {
        
        UserDefaults.standard.set(client, forKey: APPCLIENTID)
    }
    
    //    //设置当前用户
    //    class func setCurrentUserPwd(pwd:String) {
    //
    //        UserDefaults.standard.set(pwd, forKey: APPCURRENTUSERPWD)
    //    }
    //    //得到当前用户的pwd
    //    class func getCurrentUserPwd() -> String? {
    //
    //        return UserDefaults.standard.object(forKey: APPCURRENTUSERPWD) as? String ?? nil
    //    }
    
    //查询保存的用户id
    class func getAllUserId() -> [String] {
        
        let arr = UserDefaults.standard.array(forKey: APPALLUSERID) as? [String] ?? [String]()
        return arr
    }
    //增加用户ID
    class func addUserId(cusID:String) {
        
        var arr = getAllUserId()
        arr.append(cusID)
        UserDefaults.standard.set(arr, forKey: APPALLUSERID)
    }
    // 设置当前用户token
    class func getToken() ->String {
        
        var token = UserDefaults.standard.object(forKey: APPDEFAULTUSERTOKEN) as? String
        if token?.isEmpty == true || token == nil {
            // 读取默认token
            token = APPDEFAULTUSERTOKEN
        }
        return token!
    }
    // 读取当前token
    class func setToken(token:String) {
        
        UserDefaults.standard.set(token, forKey: APPDEFAULTUSERTOKEN)
    }
    // 登录时初始化token
    class func resetToken() {
        UserDefaults.standard.set(APPDEFAULTUSERTOKEN, forKey: APPDEFAULTUSERTOKEN)
    }
    // 读取当前约定 key
    class func getKey() -> String {
        
        return APPCURRENTUSERKEY
    }
    
    // 设置appVer
    class func setAppVer(ver:String) {
        UserDefaults.standard.set(ver, forKey: "APPNOWVERSION")
    }
    // 读取appVer
    class func getAppVer() ->String {
        return UserDefaults.standard.object(forKey: "APPNOWVERSION") as? String ?? ""
    }
    
    // 设置是否有未读通知
    class func setAppHasNoReadNoti(isFrist:Bool) {
        
        debugPrint("设置通知->",isFrist)
        UserDefaults.standard.set(isFrist, forKey: "SETEACHAPPSTARTFRISTNOTI")
        UserDefaults.standard.synchronize()
    }
    // 获取未读通知
    class func getAppHasNoReadNoti() ->Bool {
        
        let isRead = UserDefaults.standard.object(forKey: "SETEACHAPPSTARTFRISTNOTI") as? Bool ?? false
        debugPrint("读取通知->",isRead)
        return isRead
    }
    
    // token 是否过期
    class func isDefaultTokenKey() ->Bool {
        
        let isEqual =  getToken() == APPCURRENTUSERKEY
        return isEqual
    }
    
    // 设置引导图状态
    class func setIsShowGuider(isOk:Bool) {
        UserDefaults.standard.set(isOk, forKey: APPISSHOWGUIDEPIC)
    }
    // 获取引导图状态
    class func getIsShowGuider() -> Bool {
        return UserDefaults.standard.bool(forKey: APPISSHOWGUIDEPIC)
    }
}

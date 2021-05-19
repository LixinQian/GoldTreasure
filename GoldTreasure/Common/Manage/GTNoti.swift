//
//  GTNoti.swift
//  GoldTreasure
//
//  Created by ZZN on 2017/7/7.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

import UIKit


/// 获取新通知代理
@objc protocol GTNotiDelegate:NSObjectProtocol {
    
//  @objc optional func refresh();
    @objc func getNoti(modelList:Array<GTNotificationModel>);
    
}


class GTNoti: NSObject {

    weak var delegate:GTNotiDelegate?
    private var notiBlock:(()->Void)?
    
    var notiList:Array<GTNotificationModel>?
    
    static let  manger:GTNoti = {
        
        let instance = GTNoti()
        return instance
    }()
//    // 初始化
//    func initConfig() {
//        
//        // 监听消息
//        NotificationCenter.default.rac_addObserver(forName: NOTIGETUINEWNOTIKEY, object: nil).subscribeNext { [weak self] (noti) in
//            if self?.notiBlock != nil {
//                self?.notiBlock!()
//            }
//        }
//    }

    // 删除通知
    func deleteNoti(rlm:RLMObject,succ:@escaping (()->Void)) {
        
        
        GTDB.exec(action: { (realm) in
            // 删除数据
            realm.delete(rlm)
        }, succ: {
            succ()
        })
        //
//        var resArr = Array<RLMObject>()
//
//        var predicate:NSPredicate?
//        // 筛选
//        if GTUser.isLogin() == true {
//            
//            predicate = NSPredicate(format: "custId=%d", GTUser.getCurrentUserID() ?? 0 )
//        } else {
//            
//            predicate = NSPredicate(format: "type=%@", "1")
//        }
//        
//        // 遍历RLM
//        let object = GTNotificationModel.objects(with: predicate)
//
//        
//        for i in 0..<object.count {
//            resArr.append(object[i])
//        }
//        // rever arr
//        resArr.reverse()
//        if row>=0 && row <= Int(object.count)  {
//            
//            GTDB.exec(action: { (realm) in
//                // 删除数据
//                realm.delete(resArr[row])
//            }, succ: {
//                succ()
//            })
//        }
    }
    
    // 删除通知
    func deleteNoti(row:Int,succ:@escaping (()->Void)) {
        
        //
        var resArr = Array<RLMObject>()
        
        var predicate:NSPredicate?
        // 筛选
        if GTUser.isLogin() == true {
            
            predicate = NSPredicate(format: "custId=%d", GTUser.getCurrentUserID() ?? 0 )
        } else {
            
            predicate = NSPredicate(format: "type=%@", "1")
        }
        
        // 遍历RLM
        let object = GTNotificationModel.objects(with: predicate)
        
        
        for i in 0..<object.count {
            resArr.append(object[i])
        }
        // rever arr
        resArr.reverse()
        if row>=0 && row <= Int(object.count)  {
            
            GTDB.exec(action: { (realm) in
                // 删除数据
                realm.delete(resArr[row])
            }, succ: { 
                succ()
            })
        }
    }
    
    // 储存通知
    func saveNotiToDB(playDict:Dictionary<String,AnyObject>?) {

        
        // 暂时只显示 有无新通知
        GTUser.setAppHasNoReadNoti(isFrist: true);

        
        guard let dict = playDict else { return }
        guard let model = GTNotificationModel.yy_model(with: dict) else { return }
        
        // 加入 推送 类型 判断
        let type = model.type ?? ""
        
        // type == 1 公共通知
        if type != GTNotiType.all.rawValue.toString() && GTUser.isLogin() == true  {
            
            model.custId = GTUser.getCurrentUserID()?.stringValue
        }
        
        // save to db
        GTDB.exec(action: { (realm) in
             realm.add(model)
        }, succ: nil)
    }
    
    // 获取通知数据
    func getNotiFronDB(resultBlock:@escaping (Array<GTNotificationModel>)->Void) {
        
        
        // 清空角标
        UIApplication.shared.applicationIconBadgeNumber = 0
        GeTuiSdk.resetBadge()
//        // 暂时只显示 有无新通知
//        GTUser.setAppHasNoReadNoti(isFrist: false);
        
        var notiArr = [GTNotificationModel]()
        var predicate:NSPredicate?
        
        // 筛选
        if GTUser.isLogin() == true {
            
            predicate = NSPredicate(format: "custId=%@", GTUser.getCurrentUserID()?.stringValue ?? "0")
        } else {
            
            predicate = NSPredicate(format: "type=%@", "1")
        }
        
        GTRealmService.execResult(GTNotificationModel(), andPredicate: predicate) { (res) in
            
            for i in 0..<res.count {
                
                guard let model = res.object(at: i) as? GTNotificationModel else { return }
                notiArr.append(model)
            }
            notiArr.reverse()
            resultBlock(notiArr)
        }
    }
    
    // init
    private override init() {
        super.init()
    }
    
}


extension GTNoti {
    
    // 监听 通知改变
    class func listenNotiChange(block:@escaping ()->Void) {
        
        // 监听消息
        NotificationCenter.default.rac_addObserver(forName: NOTIGETUINEWNOTIKEY, object: nil).subscribeNext { (noti) in
            block()
        }
    }
}


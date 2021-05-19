//
//  GTDB.swift
//  GoldTreasure
//
//  Created by ZZN on 2017/7/7.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

import UIKit
import Realm

class GTDB: NSObject {
    
    static let  manger:GTDB = {
        
        let instance = GTDB()
        return instance
    }()
    // init
    private override init() {
        super.init()
    }
    
    // 执行事务操作
    class func exec(action:@escaping (_ realm:RLMRealm)->Void,succ:(()->Void)?) {
        
        // 执行 读写操作        
        GTRealmService.execRealm({ (realm) in
            action(realm)
        }) {
            // success
            if succ != nil {
                succ!()
            }
        }
    }
    
    // 根据 NSPredicate 查询
    //    class func exec(model:RLMObject,predicate:NSPredicate,result:(_ res:RLMResults<RLMObject>)->Void) {
    //
    //    }
    // 根据ID key 查询 个人信息 操作
    class func exec(cusId:String,resultBlock: @escaping (_ result:RLMResults<RLMObject>?)->Void) {
        
        //  查询
        
        let pre = NSPredicate.init(format: "custId = %@", cusId)
        GTRealmService.execResult(GTDBUserModel(), andPredicate: pre) { (result) in
            
            
            resultBlock(result)
            //            resultBlock(result)
        }
        
    }
    // 根据 NSPredicate 查询
    class func exec<T:RLMObject>(model:T,predicate:NSPredicate,result:@escaping (_ result:RLMResults<RLMObject>)->Void) {
        
        // 执行 读写操作
        GTRealmService.execRealm { (realm) in
            
            let obj = GTNotificationModel.objects(in: realm, with: predicate)
            
            result(obj)
        }
    }
    
    
    // initConfigure
    //    func initConfig() {
    //
    //        // 配置
    //        let config = RLMRealmConfiguration.default()
    //        config.fileURL =  URL(fileURLWithPath: GTCommonDefine.dbfilepath())
    //        config.schemaVersion = UInt64(1.0)
    //        config.migrationBlock = { (rlm, schme) in
    //
    //            debugPrint(schme)
    //        };
    //        // 初始化
    //        RLMRealmConfiguration.setDefault(config)
    //    }
    
    //    // 清理数据
    //    class func clearRealmData() {
    //
    //        let realm = RLMRealm.default()
    //        realm.beginWriteTransaction()
    //        realm.deleteAllObjects()
    //        realm.commitWriteTransaction()
    ////        realm.o
    ////        let realm = try?
    ////        realm?.beginWrite()
    ////        realm?.deleteAll()
    ////        try? realm?.commitWrite()
    //    }
    //
    //    //
    //    func initHandle() {
    //        // 合并操作
    //        migrationAction { (rlm, schme) in
    //            
    //        }
    //    }
    //    
    //    //
    //    func migrationAction(block:@escaping RLMMigrationBlock) {
    //        migrationBlock = block;
    //    }
    
}

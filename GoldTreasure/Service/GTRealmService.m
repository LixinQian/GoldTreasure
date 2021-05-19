//
//  GTRealmService.m
//  GoldTreasure
//
//  Created by ZZN on 2017/7/7.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTRealmService.h"

@implementation GTRealmService

// 默认配置
+ (void)configureRealm {
    
    // 创建数据库
    [GTRealmService creatDataBaseWithName];
}
// 返回realm 实例
+ (RLMRealm *)GTRealm {
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    return realm;
}

+ (void) execRealm:(void (^)(RLMRealm *realm)) block {
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    block(realm);
    [realm commitWriteTransaction];
}

+ (void) execRealm:(void (^_Nonnull)(RLMRealm * _Nonnull realm)) block andSucc:(void(^_Nullable)()) succ {
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    block(realm);
    [realm commitWriteTransaction];
    succ();
}

+ (void)creatDataBaseWithName {
    
    
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.fileURL = [NSURL URLWithString:[GTCommonDefine DBFILEPATH]];
    config.readOnly = NO;
    int currentVersion = 2.0;
    config.schemaVersion = currentVersion;
    
    // 数据迁移合并
    config.migrationBlock = ^(RLMMigration *migration , uint64_t oldSchemaVersion) {
        
        // 数据迁移
        if (oldSchemaVersion < currentVersion) {
            //
        }
    };
    
    [RLMRealmConfiguration setDefaultConfiguration:config];
}

+(void)execResult:(id)model andPredicate:(NSPredicate *)predicate andWithResult:(void (^)(RLMResults * _Nonnull result))block {
    
    if (!model) { return; }
    
    Class dbModel = [model class];
    RLMObject *obj = [[dbModel alloc] init];
    if (!predicate) {
        
        RLMResults *res = [[obj class] allObjects];
        block(res);
        
    } else {
        RLMResults *res = [[obj class] objectsWithPredicate:predicate];
        block(res);
    }
}

@end

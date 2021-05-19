//
//  GTRealmService.h
//  GoldTreasure
//
//  Created by ZZN on 2017/7/7.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RLMRealm;
@class RLMResults;
@class RLMObject;

@interface GTRealmService <T:RLMObject *>: NSObject

/**
 默认配置
 */
+ (void)configureRealm;
/**
 执行事务操作

 @param block realm 实例
 */
+ (void) execRealm:(void (^_Nonnull)(RLMRealm * _Nonnull realm)) block;

+ (void) execRealm:(void (^_Nonnull)(RLMRealm * _Nonnull realm)) block andSucc:(void(^_Nullable)()) succ;

/**
 查询操作

 @param model （model）表名
 @param predicate 查询规则
 @param block 查询实例
 */
+ (void) execResult:(T _Nullable )model andPredicate: (NSPredicate *_Nullable)predicate andWithResult:(void (^_Nonnull)(RLMResults * _Nonnull result)) block;
@end

//
//  GTCommonService.h
//  GoldTreasure
//
//  Created by ZZN on 2017/7/11.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OrderModel;

@interface GTCommonService : NSObject

// manger
+ (GTCommonService *_Nonnull)manger;


/**
  请求 banner 图

 @param succ model 数组
 */
- (void)requestBannerImgList:(void(^_Nonnull)(NSArray<GTDBCommonModel *> * _Nonnull listModel))succ;


/**
 检测版本更新
 */
-(void)checkUpdataVersion:(void(^_Nullable)())finishedBlock;

/**
 请求 ratehuilv
 
 @param succ model 数组
 */
- (void)requestRate:(void(^_Nonnull)(OrderModel * _Nonnull listModel))succ;

@end

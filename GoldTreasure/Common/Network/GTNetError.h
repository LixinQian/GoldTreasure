//
//  GTNetError.h
//  GoldTreasure
//
//  Created by ZZN on 2017/6/27.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTNetError : NSError

//@property (nonatomic,strong) NSString *errCode;
@property (nonatomic,strong) NSString * _Nullable msg;


/**
 初始化错误类型

 @param code 错误号
 @param msg 错误提示
 @return instance
 */
- (instancetype _Nonnull)initErrCode:(NSInteger)code msg:(NSString *_Nullable)msg;
- (NSDictionary *_Nonnull) toDictionary;
@end

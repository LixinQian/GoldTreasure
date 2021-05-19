//
//  NSString+TelNumber.h
//  GoldTreasure
//
//  Created by 王超 on 2017/6/23.
//  Copyright © 2017年 王超. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^NNBlock)(void);
/**
 *  电话号判断
 */
@interface NSString (TelNumber)

/**
 *  判断是否为电话号码
 *
 *  @param mobileNum 电话号码字符串
 *  @param error     错误回调
 *
 *  @return 是否为电话号码的bool回调
 */
- (BOOL)isMobileNumber:(NSString *)mobileNum
                 Error:(NNBlock)error;

@end

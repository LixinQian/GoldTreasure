//
//  GTFont.h
//  GoldTreasure
//
//  Created by wangyaxu on 27/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTFont : NSObject


/**
 18px
 少数重要标题、主要按钮文字
 如导航标题、登录注册按钮、提示标题等
 */
+ (UIFont *)gtFontF1;

+ (UIFont *)gtFontF1Medium;

/**
 16px
 重要文字、正文文字
 如输入框文字等
 */
+ (UIFont *)gtFontF2;

+ (UIFont *)gtFontF2Medium;

/**
 14px
 辅助文字、提示文字、次要按钮文字
 如还款、逾期按钮、更换按钮等
 */
+ (UIFont *)gtFontF3;

/**
 12px
 辅助文字
 如备注信息
 */
+ (UIFont *)gtFontF4;

/**
 36px
 信用额度
 */
+ (UIFont *)gtFontF5;

/**
 20px
 未登录
 */
+ (UIFont *)gtFontF6;

+ (UIFont *)gtFontF6Medium;

/**
 24px
 还款金额数值
 */
+ (UIFont *)gtFontF7;

+ (UIFont *)gtFontF7Medium;

/**
 32px
 认证中心
 */
+ (UIFont *)gtFontF8;

/**
 48px
 还款到期天数
 */
+ (UIFont *)gtFontF48;

/**
 64px
 借款合同签名
 */
+ (UIFont *)gtFontF64;

@end

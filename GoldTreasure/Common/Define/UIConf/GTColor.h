//
//  GTColor.h
//  GoldTreasure
//
//  Created by wangyaxu on 27/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTColor : NSObject

#pragma mark    - 重要 -

/**
 ＃FED953/FC3159
 主色调，用于按钮、icon、背景等
 */
+ (UIColor *)gtColorC1;

/**
 ＃FEFEFE
 顶部导航栏背景色
 */
+ (UIColor *)gtColorC2;

/**
 ＃F2F2F2
 内容区域底色
 */
+ (UIColor *)gtColorC3;

#pragma mark    - 一般 -

/**
 ＃333333
 重要文字信息、标题等
 */
+ (UIColor *)gtColorC4;

/**
 ＃666666
 普通文字信息
 */
+ (UIColor *)gtColorC5;

/**
 ＃999999
 辅助文字、提示文字、次要按钮及其描边等
 */
+ (UIColor *)gtColorC6;

/**
 ＃CCCCCC
 输入框提示文字
 */
+ (UIColor *)gtColorC7;

/**
 ＃D8D8D8
 分割线(一般为1px）、表格描边等
 */
+ (UIColor *)gtColorC8;

/**
 ＃FAC53D
 个别标题文字、按钮按下色值
 */
+ (UIColor *)gtColorC9;

#pragma mark    - 较弱 -

/**
 ＃FFF6D6
 icon辅助色、还款按钮
 */
+ (UIColor *)gtColorC10;

/**
 ＃FC8524
 icon辅助色
 */
+ (UIColor *)gtColorC11;

/**
 ＃4C9EFF
 审核中色值
 */
+ (UIColor *)gtColorC12;

/**
 ＃19AD69
 正确色值、确定按钮
 */
+ (UIColor *)gtColorC13;

/**
 ＃E7372D
 错误色值、逾期按钮
 */
+ (UIColor *)gtColorC14;

/**
 ＃EEEEEE
 页面浅分割线颜色
 */
+ (UIColor *)gtColorC15;

/**
 ＃DDDDDD
 导航栏阴影分割线
 */
+ (UIColor *)gtColorC16;

/**
 #4FA0FF
 文本超链接蓝色
 */
+ (UIColor *)gtColorC17;

/**
 ＃979797
 还款的竖条
 */
+ (UIColor *)gtColorC97;

/**
 ＃fff9e5
 还款的按钮
 */
+ (UIColor *)gtColorC9E5;

/**
 ＃E7372D
 续借的按钮
 */
+ (UIColor *)gtColorC72D;

/**
 ＃fed953
 还款的按钮border色
 */
+ (UIColor *)gtColorC953;

/**
 ＃19ad69
 放款成功的绿色
 */
+ (UIColor *)gtColorCD69;

/**
 ＃f65950
 还款逾期状态字和滞纳金金额红色
 */
+ (UIColor *)gtColorC950;

/**
 ＃2da4df
 通知按钮蓝色
 */
+ (UIColor *)gtColorBlue;

/**
 卡尺背景色
 */
+ (UIColor *)gtColorRulerBG;

/**
 申请中蓝色
 */
+ (UIColor *)gtColorApplicateBlue;

/**
 注册协议蓝色
 */
+ (UIColor *)gtColorUserAgreementBlue;

+ (UIColor *)gtBtnColorC;
/**
 登录按钮页面的颜色
 */
+ (UIColor *)gtBtnBackColorC;

@end

//
//  GTUIDefine.h
//  GoldTreasure
//
//  Created by ZZN on 2017/6/27.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#ifndef GTUIDefine_h
#define GTUIDefine_h


// Include any system framework and library headers here that should be included in all compilation units.
// You will also need to set the Prefix Header build setting of one or more of your targets to reference this file.

//全屏宽高
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define NavBarH 64
#define TabbarH 44

//头像大小
#define AvatarDimension 480.0

/////// ******** 用作适配屏幕以及字体大小 ******* ///////
#import "AppDelegate.h"

#define autoScaleW(w) [GTSize getScaleW:w]  //[(AppDelegate *)[UIApplication sharedApplication].delegate autoScaleW:width]
#define autoScaleH(h) [GTSize getScaleH:h] //[(AppDelegate *)[UIApplication sharedApplication].delegate autoScaleH:height]
//#define xx(h) [GTSize getScaleH:h]

#endif /* GTUIDefine_h */

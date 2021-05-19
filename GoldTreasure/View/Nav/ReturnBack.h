//
//  ReturnBack.h
//  RenRenTranveling
//
//  Created by 王超 on 16/5/3.
//  Copyright © 2016年 Coder_fanyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ReturnBackStyle) {
    ReturnBackStyleWhite, // 白色X图标
    ReturnBackStyleBlack, // 黑色后退尖头图标
    ReturnBackStyleArrowWhite, // 百色后退尖头图标

};

@interface ReturnBack : UIButton

//** 返回按钮 */
+ (id)buttonWithType:(UIButtonType)buttonType
     ReturnBackStyle:(ReturnBackStyle)style
              Target:(id)target
              Action:(SEL)action;

@end

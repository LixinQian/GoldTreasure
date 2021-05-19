//
//  RightButton.h
//  RenRenTranveling
//
//  Created by 王超 on 16/5/3.
//  Copyright © 2016年 Coder_fanyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RightButtonStyleTitle,
    RightButtonStyleImage
} RightButtonStyle;

@interface RightButton : UIButton

//** 导航栏右边按钮 */
+ (id)buttonWithStyle:(RightButtonStyle)buttonStyle
                buttonWithType:(UIButtonType)buttonType
                buttonTitle:(NSString *)title
                buttonImage:(UIImage *)image
                Target:(id)target
                Action:(SEL)action;


@end

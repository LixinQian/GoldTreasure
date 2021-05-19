//
//  RightButton.m
//  RenRenTranveling
//
//  Created by 王超 on 16/5/3.
//  Copyright © 2016年 Coder_fanyang. All rights reserved.
//

#import "RightButton.h"

@implementation RightButton

+(id)buttonWithStyle:(RightButtonStyle)buttonStyle buttonWithType:(UIButtonType)buttonType buttonTitle:(NSString *)title buttonImage:(UIImage *)image Target:(id)target Action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.backgroundColor = [UIColor redColor];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    switch (buttonStyle) {
        case RightButtonStyleTitle:
            button.frame = CGRectMake(0, 20, 40, 30);
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
            [button setTitle:title forState:UIControlStateNormal];
//            [button setTitleColor:ThemeColor forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            break;
         case RightButtonStyleImage:
            button.frame = CGRectMake(0, 32, 22, 20);
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
            
            [button setImage:image forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    return button;
    
}


@end

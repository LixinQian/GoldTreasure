//
//  ReturnBack.m
//  RenRenTranveling
//
//  Created by 王超 on 16/5/3.
//  Copyright © 2016年 Coder_fanyang. All rights reserved.
//

#import "ReturnBack.h"

@implementation ReturnBack

+(id)buttonWithType:(UIButtonType)buttonType ReturnBackStyle:(ReturnBackStyle)style Target:(id)target Action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 25, 25);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    switch (style) {
        case ReturnBackStyleBlack:
            [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
            break;
        case ReturnBackStyleWhite:
            [button setImage:[UIImage imageNamed:@"close_white"] forState:UIControlStateNormal];
            break;
        case ReturnBackStyleArrowWhite:
            [button setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
        default:
            break;
    }
    
    return button;
}

@end

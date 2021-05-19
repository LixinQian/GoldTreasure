//
//  GTForgetPasswordCell.h
//  GoldTreasure
//
//  Created by 王超 on 2017/6/29.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,CellStyle)
{
    CellStyleNormal,
    CellStyleCode
};

typedef void(^passWordBlock)(UIButton *btn);

@interface GTForgetPasswordCell : UITableViewCell

- (void)setCellWithStyle:(CellStyle)style;
- (void)setValueWithIndex:(NSInteger)index Flag:(NSInteger)flag;

- (NSString *)getText;

@property (nonatomic, copy) passWordBlock myBolck;
@property (nonatomic, strong) UITextField *subTitleTF;

@end

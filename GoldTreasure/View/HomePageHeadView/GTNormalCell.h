//
//  GTNormalCell.h
//  GoldTreasure
//
//  Created by 王超 on 2017/6/27.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTNormalCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *details;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UIImageView *icon1;
@property (nonatomic, strong) UILabel *title1;
@property (nonatomic, strong) UILabel *details1;

@property (nonatomic,strong) UIView *bgView;

@end

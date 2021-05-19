//
//  GTNormalCell.m
//  GoldTreasure
//
//  Created by 王超 on 2017/6/27.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTNormalCell.h"
#import <Masonry/Masonry.h>

@implementation GTNormalCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [GTColor gtColorC3];
        [self crecteView];
    }
    return self;
}
-(void)crecteView
{
    self.bgView = [UIView new];
    [self.contentView addSubview:self.bgView];
    self.bgView .backgroundColor = [GTColor gtColorC2];
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;
//    self.bgView.layer.shadowOffset =CGSizeMake(0, 1);
//    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.bgView.layer.shadowRadius = 1;
//    self.bgView.layer.shadowOpacity = .5f;
//    
//    
//    CGRect shadowFrame = self.bgView.layer.bounds;
//    CGPathRef shadowPath = [UIBezierPath bezierPathWithRect:shadowFrame].CGPath;
//    self.bgView.layer.shadowPath = shadowPath;
    
    
    self.icon = [UIImageView new];
    [self.bgView addSubview:self.icon];
    self.icon.contentMode = UIViewContentModeScaleAspectFit;
    
    self.title = [UILabel new];
    [self.bgView addSubview:self.title];
    self.title.font = [GTFont gtFontF2];
    self.title.textColor = [GTColor gtColorC4];
    self.title.textAlignment = NSTextAlignmentCenter;
    
    self.details = [UILabel new];
    [self.bgView addSubview:self.details];
    self.details.font = [GTFont gtFontF3];
    self.details.textColor = [GTColor gtColorC6];
    self.details.textAlignment = NSTextAlignmentCenter;
    
    self.line = [[UIView alloc] init];
    [self.bgView addSubview:self.line];
    self.line.alpha = 0.5;
    self.line.backgroundColor = [GTColor gtColorC6];
    
    self.icon1 = [UIImageView new];
    [self.bgView addSubview:self.icon1];
    self.icon1.contentMode = UIViewContentModeScaleAspectFit;
    
    self.title1 = [UILabel new];
    [self.bgView addSubview:self.title1];
    self.title1.font = [GTFont gtFontF2];
    self.title1.textColor = [GTColor gtColorC4];
    self.title1.textAlignment = NSTextAlignmentCenter;
    
    self.details1 = [UILabel new];
    [self.bgView addSubview:self.details1];
    self.details1.font = [GTFont gtFontF3];
    self.details1.textColor = [GTColor gtColorC6];
    self.details1.textAlignment = NSTextAlignmentCenter;
    
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self).offset(-10);
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView).offset(12);
        make.centerX.mas_equalTo(self.bgView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.icon.mas_bottom).offset(12);
        make.width.mas_equalTo(self.bgView);
        make.height.mas_equalTo(18);
    }];
    [self.details mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.title.mas_bottom).offset(12);
        make.left.equalTo(self.title);
        make.width.mas_equalTo(self.bgView);
        make.height.mas_equalTo(16);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.details.mas_bottom).offset(12.5);
        make.left.mas_equalTo(self.bgView).offset(20);
        make.right.mas_equalTo(self.bgView).offset(-20);
        make.height.mas_equalTo(1);
    }];
    
    [self.icon1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line).offset(12);
        make.centerX.mas_equalTo(self.line.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    [self.title1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.icon1.mas_bottom).offset(12);
        make.width.mas_equalTo(self.bgView);
        make.height.mas_equalTo(18);
    }];
    [self.details1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.title1.mas_bottom).offset(12);
        make.left.equalTo(self.title1);
        make.width.mas_equalTo(self.bgView);
        make.height.mas_equalTo(16);
    }];
}

-(void)setParams:(NSDictionary *)params {
    _params = params;
    self.title.text = params[@"mTitle"];
    self.details.text = params[@"desc"];
    self.icon.image = [UIImage imageNamed:params[@"img"]];
    self.title1.text = params[@"mTitle1"];
    self.details1.text = params[@"desc1"];
    self.icon1.image = [UIImage imageNamed:params[@"img1"]];

}

@end

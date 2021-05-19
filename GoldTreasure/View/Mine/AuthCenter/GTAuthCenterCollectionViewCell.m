//
//  GTAuthCenterCollectionViewCell.m
//  GoldTreasure
//
//  Created by wangyaxu on 28/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTAuthCenterCollectionViewCell.h"

#import <Masonry/Masonry.h>

@interface GTAuthCenterCollectionViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *cornerImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy) NSString *iconName;

@end

@implementation GTAuthCenterCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _iconImageView = [UIImageView new];
        _cornerImageView = [UIImageView new];
        _titleLabel = [UILabel new];
        _titleLabel.font = [GTFont gtFontF2];
        
        [self.contentView addSubview:_iconImageView];
        [_iconImageView addSubview:_cornerImageView];
        [self.contentView addSubview:_titleLabel];
        
        {
            [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(60, 60));
                make.top.equalTo(self.contentView.mas_top);
                make.centerX.equalTo(self.contentView.mas_centerX);
            }];
            
            [self.cornerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(20, 20));
                make.top.equalTo(self.iconImageView.mas_top).with.offset(4);
                make.right.equalTo(self.iconImageView.mas_right);
            }];
            
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.iconImageView.mas_bottom).with.offset(10);
                make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-40);
                make.centerX.equalTo(self.contentView.mas_centerX);
            }];
        }
    }
    return self;
}

- (void)setAuthState:(GTAuthStatus)state
{
    switch (state) {
        case GTAuthStatusLack:
        case GTAuthStatusUnkown:
            self.iconImageView.image = [UIImage imageNamed:[self.iconName stringByAppendingString:@"-1"]];
            self.titleLabel.textColor = [GTColor gtColorC6];
            self.cornerImageView.image = nil;

            break;
        case GTAuthStatusReview:
            self.iconImageView.image = [UIImage imageNamed:[self.iconName stringByAppendingString:@"-4"]];
            self.titleLabel.textColor = [GTColor gtColorC4];
            self.cornerImageView.image = nil/*[UIImage imageNamed:@"auditing"]*/;
            break;
        case GTAuthStatusSucceed:
            self.iconImageView.image = [UIImage imageNamed:[self.iconName stringByAppendingString:@"-2"]];
            self.titleLabel.textColor = [GTColor gtColorC4];
            self.cornerImageView.image = nil/*[UIImage imageNamed:@"success"]*/;
            break;
        case GTAuthStatusFailed:
        case GTAuthStatusAbsolutelyFailed:
            self.iconImageView.image = [UIImage imageNamed:[self.iconName stringByAppendingString:@"-3"]];
            self.titleLabel.textColor = [GTColor gtColorC4];
            self.cornerImageView.image = nil/*[UIImage imageNamed:@"fail"]*/;
            break;
            
        default:
            break;
    }
}

- (void)setIconWithImageName:(NSString *)name
{
    self.iconName = name;
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

@end

//
//  GTAuthCenterHeaderView.m
//  GoldTreasure
//
//  Created by wangyaxu on 28/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTAuthCenterHeaderView.h"

#import <Masonry/Masonry.h>

@interface GTAuthCenterHeaderView ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIView *tipView;

@end

@implementation GTAuthCenterHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _bgImageView = [UIImageView new];
        _bgImageView.image = [UIImage imageNamed:@"bg-borrow"];
        
        //光圈view
//        UIColor *orangeColor = [GTColor gtColorC11];
//        UIView *countBgBottomView = [self bgViewWithColor:[orangeColor colorWithAlphaComponent:.1f] radius:29];
//        UIView *countBgTopView = [self bgViewWithColor:[orangeColor colorWithAlphaComponent:.3f] radius:24];
        
        _countLabel = [UILabel labelWithFont:[GTFont gtFontF7] textColor:[UIColor whiteColor]];
//        _countLabel.backgroundColor = orangeColor;
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.layer.cornerRadius = 20;
        _countLabel.clipsToBounds = YES;
        
        _leftLabel = [UILabel labelWithFont:[GTFont gtFontF1] textColor:[UIColor whiteColor]];
        _leftLabel.text = @"已完成";
        _rightLabel = [UILabel labelWithFont:[GTFont gtFontF1] textColor:[UIColor whiteColor]];
        _rightLabel.text = @"项认证";
        
        [self addSubview:_bgImageView];
        [self addSubview:_leftLabel];
//        [self addSubview:countBgBottomView];
//        [countBgBottomView addSubview:countBgTopView];
        [self addSubview:self.countLabel];
        [self addSubview:_countLabel];
        [self addSubview:_rightLabel];

        {
            [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            
//            [countBgBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(CGSizeMake(58, 58));
//                make.centerX.equalTo(self.mas_centerX);
//                make.bottom.equalTo(self.mas_bottom).with.offset(-45);
//            }];
//            
//            [countBgTopView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(CGSizeMake(48, 48));
//                make.center.equalTo(countBgBottomView);
//            }];
            
            [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(40, 40));
                make.centerX.equalTo(self.mas_centerX);
                make.bottom.equalTo(self.mas_bottom).with.offset(-45);
            }];
            
            [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.countLabel.mas_centerY);
                make.right.equalTo(self.countLabel.mas_left).with.offset(-5);
            }];
            
            [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.countLabel.mas_centerY);
                make.left.equalTo(self.countLabel.mas_right).with.offset(7);
            }];
        }

    }
    return self;
}

- (void)setAuthedCount:(NSInteger )count
{
    self.countLabel.text = [NSString stringWithFormat:@"%ld", count];
    if (count == 0) {
        //未完成实名认证，显示 tipLabel
        UILabel *tipLabel = [UILabel labelWithFont:[GTFont gtFontF3] textColor:[UIColor whiteColor]];
        tipLabel.text = @"实名认证通过后才能继续其他认证。";
        
        [self addSubview:self.tipView];
        [self.tipView addSubview:tipLabel];
        
        [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@30);
        }];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(30);
            make.centerY.equalTo(self.tipView.mas_centerY);
        }];
    } else {
        [self.tipView removeFromSuperview];
        self.tipView = nil;
    }
}

- (UIView *)tipView
{
    if (!_tipView) {
        _tipView = [UIView new];
        _tipView.backgroundColor = [UIColor colorWithWhite:1.f alpha:.35f];
    }
    return _tipView;
}

- (UIView *)bgViewWithColor:(UIColor *)bgColor radius:(CGFloat )radius
{
    UIView *bgView = [UIView new];
    bgView.backgroundColor = bgColor;
    bgView.layer.cornerRadius = radius;
    return bgView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

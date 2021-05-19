//
//  GTMineHeaderView.m
//  GoldTreasure
//
//  Created by wangyaxu on 27/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTMineHeaderView.h"
#import "GTLoginController.h"

#import <Masonry/Masonry.h>

@interface GTMineHeaderView ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIView *avatarBgTopView;
@property (nonatomic, strong) UIView *avatarBgBottomView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIButton *notLoginBtn;

@end

@implementation GTMineHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _bgImageView = [UIImageView new];
        _bgImageView.image = [UIImage imageNamed:@"bj_my"];
        
        //光圈view
        UIColor *bgColor = [UIColor colorWithWhite:1.f alpha:0.35];
        _avatarBgBottomView = [self bgViewWithColor:bgColor radius:40];
        _avatarBgTopView = [self bgViewWithColor:bgColor radius:35];

        _avatarImageView = [UIImageView new];
        _avatarImageView.image = [UIImage imageNamed:@"default_avatar"];
        _avatarImageView.layer.cornerRadius = 30;
        _avatarImageView.clipsToBounds = YES;
        
        _nameLabel = [UILabel labelWithFont:[GTFont gtFontF1Medium] textColor:[GTColor gtColorC2]];
        _phoneLabel = [UILabel labelWithFont:[GTFont gtFontF2Medium] textColor:[GTColor gtColorC2]];
        _notLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _notLoginBtn.titleLabel.font = [GTFont gtFontF6Medium];
        [_notLoginBtn setTitleColor:[GTColor gtColorC2] forState:UIControlStateNormal];
        [_notLoginBtn setTitle:@"未登录" forState:UIControlStateNormal];
        [_notLoginBtn addTarget:self action:@selector(gotoLogin) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [avatarBtn addTarget:self action:@selector(changeAvatarAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_bgImageView];
        [self addSubview:_nameLabel];
        [self addSubview:_phoneLabel];
        [self addSubview:_notLoginBtn];
        [self addSubview:_avatarBgBottomView];
        [_avatarBgBottomView addSubview:_avatarBgTopView];
        [_avatarBgTopView addSubview:_avatarImageView];
        [_avatarBgBottomView addSubview:avatarBtn];
        {
            [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            
            [self.avatarBgBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(80, 80));
                make.left.equalTo(self.mas_left).with.offset(10);
                make.bottom.equalTo(self.mas_bottom).with.offset(-30);
            }];
            
            [self.avatarBgTopView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(70, 70));
                make.center.equalTo(self.avatarBgBottomView);
            }];
            
            [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(60, 60));
                make.center.equalTo(self.avatarBgTopView);
            }];
            
            [avatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.avatarImageView);
            }];
            
            [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.avatarBgBottomView.mas_right).with.offset(10);
                make.bottom.equalTo(self.phoneLabel.mas_top).with.offset(-15);
            }];
            
            [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.nameLabel.mas_left);
                make.bottom.equalTo(self.mas_bottom).with.offset(-45);
            }];
            
            [self.notLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(90, 44));
                make.left.equalTo(self.avatarBgBottomView.mas_right);
                make.centerY.equalTo(self.avatarBgTopView.mas_centerY);
            }];
        }
    }
    return self;
}

- (void)setName:(NSString *)name
{
    self.nameLabel.text = name;
}

- (void)setPhoneNumber:(NSString *)phone
{
    if (phone) {
        self.phoneLabel.text = phone;
        self.notLoginBtn.hidden = YES;
    } else {
        self.phoneLabel.text = nil;
        self.nameLabel.text = nil;
        self.notLoginBtn.hidden = NO;
    }
}

- (void)changeAvatarAction:(id )sender
{
    self.changeAvatarBlock();
}

- (void)gotoLogin
{
    self.loginBlock();
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

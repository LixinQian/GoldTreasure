//
//  GTContactUsBarView.m
//  GoldTreasure
//
//  Created by wangyaxu on 29/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTContactUsBarView.h"
#import "GTOnlineServiceViewController.h"
#import "UIView+Extension.h"
#import "GTQiYuCustomerService.h"

#import <Masonry/Masonry.h>

@implementation GTContactUsBarView

- (instancetype)initWithBarMode:(ContactUsBarMode)mode
{
    self = [super init];
    if (self) {
        [self setupWithMode:mode];
    }
    return self;
}

- (void)setupWithMode:(ContactUsBarMode )mode
{
    UIButton *phoneIconBtn = [self buttonWithTitle:nil titleColor:nil titleFont:nil image:[UIImage imageNamed:@"phone"]];
    UIButton *phoneBtn = [self buttonWithTitle:SERVICETELE titleColor:[GTColor gtColorC5] titleFont:[GTFont gtFontF3] image:nil];
    UIButton *onlineIconBtn = [self buttonWithTitle:nil titleColor:nil titleFont:nil image:[UIImage imageNamed:@"online"]];
    UIButton *onlineBtn = [self buttonWithTitle:@"在线客服" titleColor:[GTColor gtColorC5] titleFont:[GTFont gtFontF3] image:nil];
    
    [phoneIconBtn addTarget:self action:@selector(clickPhoneNumberBtn:) forControlEvents:UIControlEventTouchUpInside];
    [phoneBtn addTarget:self action:@selector(clickPhoneNumberBtn:) forControlEvents:UIControlEventTouchUpInside];
    [onlineIconBtn addTarget:self action:@selector(clickOnlineBtn:) forControlEvents:UIControlEventTouchUpInside];
    [onlineBtn addTarget:self action:@selector(clickOnlineBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [UIView new];
    lineView.layer.cornerRadius = 0.5;
    lineView.backgroundColor = [GTColor gtColorC6];
    
    [self addSubview:phoneIconBtn];
    [self addSubview:phoneBtn];
    [self addSubview:onlineIconBtn];
    [self addSubview:onlineBtn];
    [self addSubview:lineView];
    
    CGFloat phoneX = 0;
    CGFloat onlineX = 0;
    switch (mode) {
        case ContactUsBarNoLeftMargin:
            phoneX = 0;
            onlineX = 30;
            break;
        case ContactUsBarCompact:
            phoneX = 33;
            onlineX = 30;
            break;
        case ContactUsBarRegular:
            phoneX = 15;
            onlineX = 40;
            break;
            
        default:
            break;
    }
    
    {
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(1, 14));
        }];
        
        [phoneIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(phoneX);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(phoneIconBtn.mas_right).with.offset(10);
            make.height.equalTo(@20);
            make.top.bottom.equalTo(self);
        }];
        
        [onlineIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lineView.mas_right).with.offset(onlineX);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [onlineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(onlineIconBtn.mas_right).with.offset(10);
            make.height.equalTo(@20);
            make.top.bottom.equalTo(self);

        }];
    }
}

- (void)clickPhoneNumberBtn:(UIButton *)button
{
    NSString *urlString = [NSString stringWithFormat:@"tel://%@", SERVICETELE];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

- (void)clickOnlineBtn:(UIButton *)button
{    
    QYSessionViewController *sessionViewController = [GTQiYuCustomerService defaultSessionControllerWithSessionType:QYSessionTypeService];
    sessionViewController.hidesBottomBarWhenPushed = YES;
    
    [self.firstAvailableUIViewController.navigationController pushViewController:sessionViewController animated:YES];
}

- (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)font image:(UIImage *)image
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title) {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    if (color) {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    if (font) {
        btn.titleLabel.font = font;
    }
    if (image) {
        [btn setBackgroundImage:image forState:UIControlStateNormal];
    }
    return btn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

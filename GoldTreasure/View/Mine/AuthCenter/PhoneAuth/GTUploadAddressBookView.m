//
//  GTUploadAddressBookView.m
//  GoldTreasure
//
//  Created by wangyaxu on 03/07/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTUploadAddressBookView.h"

#import <Masonry/Masonry.h>

@interface GTUploadAddressBookView ()

@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation GTUploadAddressBookView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setup
{
    UIImageView *mainImageView = [UIImageView new];
    mainImageView.image = [UIImage imageNamed:@"directories"];
    
    UILabel *tipLabel = [UILabel labelWithFont:[GTFont gtFontF3] textColor:[GTColor gtColorC5]];
    tipLabel.text = @"运营商认证需要先上传您的通讯录，仅用于查询个人征信，我们承诺保护用户隐私。";
    tipLabel.numberOfLines = 0;
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitBtn = submitBtn;
    [submitBtn setBackgroundColor:[GTColor gtColorC1]];
    submitBtn.titleLabel.font = [GTFont gtFontF1];
    [submitBtn setTitleColor:[GTColor gtColorC4] forState:UIControlStateNormal];
    [submitBtn setTitle:@"上传通讯录" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(clickSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clickCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:mainImageView];
    [self addSubview:tipLabel];
    [self addSubview:submitBtn];
    [self addSubview:closeBtn];
    
    {
        [mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(20);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(mainImageView.mas_bottom).with.offset(15);
            make.left.equalTo(self.mas_left).with.offset(19);
            make.right.equalTo(self.mas_right).with.offset(-19);
        }];
        
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.equalTo(self);
            make.height.equalTo(@50);
        }];
        
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(5);
            make.right.equalTo(self.mas_right).with.offset(-5);
        }];
    }
}

- (void)setSubmitBtnEnabled:(BOOL )enabled
{
    self.submitBtn.userInteractionEnabled = enabled;
}

- (void)clickCloseBtn:(UIButton *)button
{
    self.closeBlock();
}

- (void)clickSubmitBtn:(UIButton *)button
{
    self.uploadAddressBlock();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

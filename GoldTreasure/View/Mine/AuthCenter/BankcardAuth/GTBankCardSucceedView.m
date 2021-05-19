//
//  GTBankCardSucceedView.m
//  GoldTreasure
//
//  Created by wangyaxu on 30/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTBankCardSucceedView.h"
#import "GTContactUsBarView.h"

#import <Masonry/Masonry.h>

@interface GTBankCardSucceedView ()

@property (nonatomic, strong) UILabel *bankNameLabel;
@property (nonatomic, strong) UILabel *cardCodeLabel;
@property (nonatomic, strong) UILabel *addDateLabel;

@property (nonatomic, strong) UIView *changeCardView;

@end

@implementation GTBankCardSucceedView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bj_bankcard"]];
    
    self.bankIcon = [UIImageView new];
    self.bankIcon.layer.cornerRadius = 22;
    self.bankIcon.clipsToBounds = YES;
    
    self.bankNameLabel = [UILabel labelWithFont:[GTFont gtFontF2] textColor:[[GTColor gtColorC4] colorWithAlphaComponent:.8f]];
    
    UIFont *codeFont = [GTFont gtFontF7Medium];
    if (ScreenWidth < 375.0) {
        codeFont = [UIFont systemFontOfSize:21 weight:UIFontWeightMedium];
    }
    self.cardCodeLabel = [UILabel labelWithFont:codeFont textColor:[GTColor gtColorC4]];
    self.cardCodeLabel.textAlignment = NSTextAlignmentCenter;
    
    self.addDateLabel = [UILabel labelWithFont:[GTFont gtFontF4] textColor:[[GTColor gtColorC4] colorWithAlphaComponent:.5f]];
    
    UILabel *tipLabel = [UILabel labelWithFont:[GTFont gtFontF3] textColor:[GTColor gtColorC6] text:@"只能绑定一张银行卡。绑定后只能使用该卡进行借款。\n如有疑问，请联系客服："];
    tipLabel.numberOfLines = 0;
    
    GTContactUsBarView *barView = [[GTContactUsBarView alloc] initWithBarMode:ContactUsBarRegular];
    
    UIView *backView = [UIView new];
    backView.layer.cornerRadius = 5;
    backView.layer.borderColor = [GTColor gtColorC6].CGColor;
    backView.layer.borderWidth = 0.5;
    self.changeCardView = backView;
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"changeCard"]];
    
    UILabel *changeCardLabel = [UILabel labelWithFont:[GTFont gtFontF1] textColor:[GTColor gtColorC6] text:@"更换银行卡"];
    
    UIButton *changeCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeCardBtn addTarget:self action:@selector(clickChangeCard:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:backgroundImageView];
    [backgroundImageView addSubview:self.bankIcon];
    [backgroundImageView addSubview:self.bankNameLabel];
    [backgroundImageView addSubview:self.cardCodeLabel];
    [backgroundImageView addSubview:self.addDateLabel];
    [self addSubview:tipLabel];
    [self addSubview:barView];
    [self addSubview:backView];
    [backView addSubview:iconImageView];
    [backView addSubview:changeCardLabel];
    [backView addSubview:changeCardBtn];
    
    {
        //card image layout
        [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left).with.offset(15);
            make.right.equalTo(self.mas_right).with.offset(-15);
            make.width.mas_equalTo(backgroundImageView.mas_height).with.multipliedBy(345.0 / 190);
        }];
        
        [self.bankIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(44, 44));
            make.top.equalTo(backgroundImageView.mas_top).with.offset(25);
            make.left.equalTo(backgroundImageView.mas_left).with.offset(20);
        }];
        
        [self.bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bankIcon.mas_right).with.offset(15);
            make.centerY.equalTo(self.bankIcon.mas_centerY);
        }];
        
        [self.cardCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bankIcon.mas_bottom).with.offset(20);
            make.left.equalTo(backgroundImageView.mas_left).with.offset(10);
            make.right.equalTo(backgroundImageView.mas_right).with.offset(-10);
        }];
        
        [self.addDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundImageView.mas_left).with.offset(20);
            make.bottom.equalTo(backgroundImageView.mas_bottom).with.offset(-15);
        }];
        
        //page layout
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backgroundImageView.mas_bottom).with.offset(20);
            make.left.equalTo(self.mas_left).with.offset(15);
            make.right.equalTo(self.mas_right).with.offset(-15);
        }];
        
        [barView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipLabel.mas_bottom).with.offset(5);
            make.left.right.equalTo(self);
        }];
        
        //button layout
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(280, 50));
            make.top.equalTo(barView.mas_bottom).with.offset(50);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView.mas_left).with.offset(80);
            make.centerY.equalTo(backView.mas_centerY);
        }];
        
        [changeCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_right).with.offset(10);
            make.centerY.equalTo(backView.mas_centerY);
        }];
        
        [changeCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(backView);
        }];
    }    
}

- (void)setBankNumber:(NSString *)bankNumber
{
    self.cardCodeLabel.text = bankNumber;
}

- (void)setAddDate:(NSString *)addDate
{
    self.addDateLabel.text = addDate;
}

- (void)setBankName:(NSString *)bankName
{
    self.bankNameLabel.text = bankName;
}

- (void)setChangeCardBtnHidden:(BOOL )isHidden
{
    self.changeCardView.hidden = isHidden;
}

- (void)clickChangeCard:(UIButton *)button
{
    self.changeCardBlock();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

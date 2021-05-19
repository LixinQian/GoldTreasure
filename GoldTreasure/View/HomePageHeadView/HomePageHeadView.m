//
//  HomePageHeadView.m
//  GoldTreasure
//
//  Created by 王超 on 2017/6/27.
//  Copyright © 2017年 王超. All rights reserved.
//

#import "HomePageHeadView.h"
#import "Masonry.h"
#import "UIButton+GTImageTitleSpacing.h"

@interface HomePageHeadView ()

//@property (nonatomic, strong) UIView *headView;


/**
 底部的背景
 */
@property (nonatomic, strong) UIImageView *bgIMG;
@property (nonatomic, strong) UILabel *creditLineTitle;
@property (nonatomic, strong) UILabel *creditLineCount;
@property (nonatomic, strong) UILabel *usedCreditsTitle;
@property (nonatomic, strong) UILabel *usedCreditsCount;
@property (nonatomic, strong) UILabel *surplusCreditsTitle;
@property (nonatomic, strong) UILabel *surplusCreditsCount;
@property (nonatomic, strong) UIView *labelLine;

/**
 借款订单上方的分割线
 */
@property (nonatomic, strong) UIView *BtnLine;

/**
 右边的  >
 */
@property (nonatomic, strong) UIImageView *arrow;
@property (nonatomic, strong) UIButton *borrowBtn;

/**
 我的借款订单
 */
@property (nonatomic, strong) UIButton *orderBtn;
//@property (nonatomic, strong) UIButton *repaymentBtn;


/**
 白色背景
 */
@property (nonatomic, strong) UIView *bgView;
@end

@implementation HomePageHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [GTColor gtColorC3];
        [self createView];
    }
    return self;
}

- (void)createView
{
    self.bgIMG = [UIImageView new];
    [self addSubview:self.bgIMG];
    self.bgIMG.userInteractionEnabled = YES;
    self.bgIMG.image = [UIImage imageNamed:@"bj_home"];
    
    /************************修改的UI地方****************************/
    self.bgView = [UIView new];
    self.bgView.backgroundColor = [UIColor whiteColor]/*[GTColor gtColorC1]*/;
    [self insertSubview:self.bgView aboveSubview:self.bgIMG];
//    [self addSubview:self.bgView];
    /************************修改的UI地方****************************/
    
    self.creditLineTitle = [UILabel new];
    [self.bgView addSubview:self.creditLineTitle];
    self.creditLineTitle.text = @"信用额度（元）";
    self.creditLineTitle.font = [GTFont gtFontF3];
    self.creditLineTitle.textColor = [GTColor gtColorC6];
//    self.creditLineTitle.textAlignment = NSTextAlignmentCenter;
    
    self.creditLineCount = [UILabel new];
    [self.bgView addSubview:self.creditLineCount];
    self.creditLineCount.font = [GTFont gtFontF5];
    self.creditLineCount.text = @"0.00";
    self.creditLineCount.textColor = [GTColor gtColorC4];
//    self.creditLineCount.textAlignment = NSTextAlignmentCenter;
    
    self.usedCreditsTitle = [UILabel new];
    [self.bgView addSubview:self.usedCreditsTitle];
    self.usedCreditsTitle.text = @"已借款额度（元）";
    self.usedCreditsTitle.font = [GTFont gtFontF3];
    self.usedCreditsTitle.textColor = [GTColor gtColorC6];
//    self.usedCreditsTitle.textAlignment = NSTextAlignmentCenter;
    
    self.usedCreditsCount = [UILabel new];
    [self.bgView addSubview:self.usedCreditsCount];
    self.usedCreditsCount.font = [GTFont gtFontF2];
    self.usedCreditsCount.textColor = [GTColor gtColorC4];
    self.usedCreditsCount.text = @"0.00";
//    self.usedCreditsCount.textAlignment = NSTextAlignmentCenter;
    
    self.surplusCreditsTitle = [UILabel new];
    [self.bgView addSubview:self.surplusCreditsTitle];
    self.surplusCreditsTitle.text = @"剩余额度（元）";
    self.surplusCreditsTitle.font = [GTFont gtFontF3];
    self.surplusCreditsTitle.textColor = [GTColor gtColorC6];
//    self.surplusCreditsTitle.textAlignment = NSTextAlignmentCenter;
    
    self.surplusCreditsCount = [UILabel new];
    [self.bgView addSubview:self.surplusCreditsCount];
    self.surplusCreditsCount.text = @"0.00";
    self.surplusCreditsCount.font = [GTFont gtFontF2];
    self.surplusCreditsCount.textColor = [GTColor gtColorC4];
//    self.surplusCreditsCount.textAlignment = NSTextAlignmentCenter;
    
    self.labelLine = [UIView new];
    self.labelLine.backgroundColor = [GTColor gtColorC6];
    self.labelLine.alpha = 0.5;
    [self.bgView addSubview:self.labelLine];
    
    self.borrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bgView addSubview:self.borrowBtn];
//    [self.borrowBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    self.borrowBtn.backgroundColor = [GTColor gtColorC1];
    [self.borrowBtn setTitle:@"我要借款" forState:UIControlStateNormal];
    [self.borrowBtn setTitleColor:[GTColor gtColorC2] forState:UIControlStateNormal];
    [self.borrowBtn.titleLabel setFont:[GTFont gtFontF2]];
    self.borrowBtn.adjustsImageWhenHighlighted = NO;
    [self.borrowBtn addTarget:self action:@selector(borrowBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.BtnLine = [UIView new];
    self.BtnLine.backgroundColor = [GTColor gtColorC6];
    self.BtnLine.alpha = 0.5;
    [self.bgView addSubview:self.BtnLine];
    
    
    self.orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bgView addSubview:self.orderBtn];
    self.orderBtn.adjustsImageWhenHighlighted = NO;
    [self.orderBtn setTitle:@"我的借款订单" forState:UIControlStateNormal];
    [self.orderBtn setImage:[UIImage imageNamed:@"icon_jiekuandan"] forState:UIControlStateNormal];
    [self.orderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.orderBtn.titleLabel setFont:[GTFont gtFontF2]];
    [self.orderBtn addTarget:self action:@selector(orderBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
//    self.repaymentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.bgView addSubview:self.repaymentBtn];
//    self.repaymentBtn.adjustsImageWhenHighlighted = NO;
//    [self.repaymentBtn setTitle:@"还款" forState:UIControlStateNormal];
//    [self.repaymentBtn setImage:[UIImage imageNamed:@"icon_huankuandan"] forState:UIControlStateNormal];
//    [self.repaymentBtn setTitleColor:[GTColor gtColorC4] forState:UIControlStateNormal];
//    [self.repaymentBtn.titleLabel setFont:[GTFont gtFontF2]];
//    [self.repaymentBtn addTarget:self action:@selector(repaymentBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.arrow = [UIImageView new];
    self.arrow.image = [UIImage imageNamed:@"right"];
    [self.bgView addSubview:self.arrow];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.bgIMG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        //        make.top.mas_equalTo(self.headView.mas_bottom);
        make.right.equalTo(self);
        make.height.mas_equalTo(245 + 64);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(64 + 20);
        make.right.equalTo(self).offset(-10);
        make.bottom.mas_equalTo(self);
    }];
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;
    
    [self.creditLineTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView).offset(25);
        make.left.equalTo(self.bgView).offset(15);
        make.right.equalTo(self.bgView).offset(-15);
        make.height.mas_equalTo(16);
    }];
    [self.creditLineCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.creditLineTitle.mas_bottom).offset(10);
        make.left.equalTo(self).offset(18);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(38);
    }];
    [self.usedCreditsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.creditLineCount.mas_bottom).offset(27);
        make.left.equalTo(self.bgView).offset(15);
        make.width.mas_equalTo(ScreenWidth*0.5 -15.5);//
        make.height.mas_equalTo(16);
    }];
    [self.usedCreditsCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.usedCreditsTitle);
        make.top.mas_equalTo(self.usedCreditsTitle.mas_bottom).offset(10);
        make.width.equalTo(self.usedCreditsTitle);
        make.height.mas_equalTo(18);
    }];
    [self.labelLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.centerY.mas_equalTo(self.usedCreditsTitle.mas_bottom).offset(3);
        make.size.mas_equalTo(CGSizeMake(1, 20));
    }];
    [self.surplusCreditsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usedCreditsTitle);
        make.left.equalTo(self.labelLine.mas_right).offset(25);//
        make.right.equalTo(self.bgView.mas_right).offset(-50);//
        make.height.equalTo(self.usedCreditsTitle);
    }];
    [self.surplusCreditsCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usedCreditsCount);
        make.left.equalTo(self.surplusCreditsTitle);
        make.right.equalTo(self.surplusCreditsTitle);
        make.height.equalTo(self.usedCreditsCount);
    }];
    
    
    [self.borrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.mas_equalTo(self.usedCreditsCount.mas_bottom).offset(40);
        make.size.mas_equalTo(CGSizeMake(250,40));
    }];
    self.borrowBtn.layer.cornerRadius = 20;
    self.borrowBtn.layer.masksToBounds = YES;

    [self.BtnLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView).offset(15);
        make.right.mas_equalTo(self.bgView).offset(-15);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(self.bgView).offset(-51);
    }];
    
    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.BtnLine.mas_bottom).offset(15);
        make.right.mas_equalTo(self.bgView).offset(-15);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.BtnLine);
        make.left.mas_equalTo(self.bgView).offset(15);
        make.right.mas_equalTo(self.arrow.mas_left);
        make.height.mas_equalTo(50);
    }];
    
    [self.orderBtn layoutButtonWithEdgeInsetsStyle:GTButtonEdgeInsetsStyleLeft imageTitleSpace:
     15];
    self.orderBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.orderBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
//    [self.repaymentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self).offset(-35);
//        make.centerY.equalTo(self.orderBtn);
//        make.width.equalTo(self.orderBtn);
//        make.height.equalTo(self.orderBtn);
//    }];
//    [self.repaymentBtn layoutButtonWithEdgeInsetsStyle:GTButtonEdgeInsetsStyleTop imageTitleSpace:10];
    
    
    
}
-(void)setModel:(GTResModelUserInfo *)model {
    
    NSString *amount = model.authedCredit == nil ? @"1000.00" : [model.authedCredit centToYuan];
    self.creditLineCount.text = amount;
    
    self.usedCreditsCount.text = model.usedCredit == nil ? @"0.00" : [model.usedCredit centToYuan];
   
    double total = [amount doubleValue]*100;
    double used = [model.usedCredit doubleValue];
    double left = total-used > 0 ? total-used : 0.00;
    
    self.surplusCreditsCount.text = [NSString stringWithFormat:@"%.2f",left/100];
}
-(void)borrowBtnAction
{
    self.borrowBlock();
}
-(void)orderBtnAction
{
    self.orderBlock();
}
//-(void)repaymentBtnAction
//{
//    self.repaymentBlock();
//}

@end

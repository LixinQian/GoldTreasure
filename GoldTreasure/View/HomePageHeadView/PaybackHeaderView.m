//
//  PaybackHeaderView.m
//  GoldTreasure
//
//  Created by targeter on 2017/6/28.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "PaybackHeaderView.h"
#import <Masonry/Masonry.h>

@interface PaybackHeaderView()
/** bgImg */
@property(nonatomic, strong)UIImageView *bgImage;
/** 还款金额整体 */
@property(nonatomic, strong)UIView *containerView;
/** 还款金额Label */
@property(nonatomic, strong)UILabel *aTextLabel;
/** 还款金额图标 */
@property(nonatomic, strong)UIImageView *iconImage;
/** 最近还款日Label */
@property(nonatomic, strong)UILabel *latelyCashLabel;
/** 借款笔数Label */
@property(nonatomic, strong)UILabel *loanCountLabel;
/** 逾期笔数Label */
@property(nonatomic, strong)UILabel *deadlineCountLabel;
/** leftPortraitLine */
@property(nonatomic, strong)UIView *leftPortraitLine;
/** rightPortraitLine */
@property(nonatomic, strong)UIView *rightPortraitLine;
/** 日历底部 */
//@property(nonatomic, strong)UIImageView *calendarHeader;


/** 还款金额数据Label */
@property(nonatomic, strong)UILabel *cashLabel;
/** 最近还款日DateLabel */
@property(nonatomic, strong)UILabel *latelyCashDateLabel;
/** 借款笔数数据Label */
@property(nonatomic, strong)UILabel *loanCountDataLabel;
/** 逾期笔数DataLabel */
@property(nonatomic, strong)UILabel *deadlineCountDataLabel;


@end
@implementation PaybackHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createView];
    }
    return self;
}

- (void)setPaybackListResModel:(GTPaybackListResModel *)PaybackListResModel
{
    if ([PaybackListResModel.sumMoney integerValue] ) {
        _cashLabel.text = [PaybackListResModel.sumMoney centToYuan];
        _latelyCashDateLabel.text = [PaybackListResModel.recentPayDay localNetTimeToMonthWithDay];
        _loanCountDataLabel.text = [PaybackListResModel.payBackNum toString];
        _deadlineCountDataLabel.text = [PaybackListResModel.overDueNumber toString];

    }
    [self layoutIfNeeded];

}
- (void)createView
{
    //bgView
    __weak typeof (self) weakSelf = self;
    self.bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bj_payment"]];
    [self addSubview:self.bgImage];
    //calendarHeader
//    self.calendarHeader = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bj_payment2"]];
//    [self addSubview:self.calendarHeader];
    //借款金额大框
    self.containerView = [[UIView alloc] init];
    self.iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loan_16"]];
    [self.containerView addSubview:self.iconImage];
    self.aTextLabel = [[UILabel alloc] init];
    self.aTextLabel.text = @"总应还金额（元）";
    self.aTextLabel.textColor = [GTColor gtColorC2];
    self.aTextLabel.font = [GTFont gtFontF3];
    [self.containerView addSubview:self.aTextLabel];
    [self addSubview:self.containerView];
    //还款金额数据Label
    self.cashLabel = [[UILabel alloc] init];
    self.cashLabel.textColor = [GTColor gtColorC2];
    self.cashLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:24];
    self.cashLabel.text = @"0.00";
    [self addSubview:self.cashLabel];
    //最近还款日Label
    self.latelyCashLabel = [[UILabel alloc] init];
    self.latelyCashLabel.textColor = [GTColor gtColorC2];
    self.latelyCashLabel.font = [GTFont gtFontF3];
    self.latelyCashLabel.text = @"最近还款日";
    self.latelyCashLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.latelyCashLabel];
    //借款笔数Label
    self.loanCountLabel = [[UILabel alloc] init];
    self.loanCountLabel.textColor = [GTColor gtColorC2];
    self.loanCountLabel.font = [GTFont gtFontF3];
    self.loanCountLabel.text = @"借款笔数";
    self.loanCountLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.loanCountLabel];
    //逾期笔数Label
    self.deadlineCountLabel = [[UILabel alloc] init];
    self.deadlineCountLabel.textColor = [GTColor gtColorC2];
    self.deadlineCountLabel.font = [GTFont gtFontF3];
    self.deadlineCountLabel.text = @"逾期笔数";
    self.deadlineCountLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.deadlineCountLabel];


    
    //最近还款日count
    self.latelyCashDateLabel = [[UILabel alloc] init];
    self.latelyCashDateLabel.textColor = [GTColor gtColorC2];
    self.latelyCashDateLabel.font = [GTFont gtFontF3];
    self.latelyCashDateLabel.text = @"_";
    self.latelyCashDateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.latelyCashDateLabel];

    //借款笔数count
    self.loanCountDataLabel = [[UILabel alloc] init];
    self.loanCountDataLabel.textColor = [GTColor gtColorC2];
    self.loanCountDataLabel.font = [GTFont gtFontF3];
    self.loanCountDataLabel.text = @"0";
    [self addSubview:self.loanCountDataLabel];

    self.loanCountDataLabel.textAlignment = NSTextAlignmentCenter;
    //逾期笔数count
    self.deadlineCountDataLabel = [[UILabel alloc] init];
    self.deadlineCountDataLabel.textColor = [GTColor gtColorC2];
    self.deadlineCountDataLabel.font = [GTFont gtFontF3];
    self.deadlineCountDataLabel.text = @"0";
    self.deadlineCountDataLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.deadlineCountDataLabel];
    //portraitLines
    self.leftPortraitLine = [[UIView alloc] init];
    self.rightPortraitLine = [[UIView alloc] init];
    self.leftPortraitLine.backgroundColor = [GTColor gtColorC97];
    self.rightPortraitLine.backgroundColor = [GTColor gtColorC97];
    [self addSubview:self.leftPortraitLine];
    [self addSubview:self.rightPortraitLine];
    
    
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
    }];

//    [self.calendarHeader mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(weakSelf);
//        make.height.equalTo(@54);
//        make.bottom.equalTo(weakSelf);
//    }];

    [self.leftPortraitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.loanCountLabel.mas_centerY);
        make.left.equalTo(weakSelf.loanCountLabel);
        make.width.equalTo(@1);
        make.height.equalTo(@36);
    }];
    [self.rightPortraitLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.deadlineCountLabel.mas_centerY);
        make.left.equalTo(weakSelf.deadlineCountLabel);
        make.width.equalTo(@1);
        make.height.equalTo(@36);
    }];

    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf).with.equalTo(@86);
    }];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.containerView);
        make.top.equalTo(weakSelf.containerView);
        make.bottom.equalTo(weakSelf.containerView);
    }];
    [self.aTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImage.mas_right).with.equalTo(@10);
        make.right.equalTo(weakSelf.containerView);
        make.centerY.equalTo(weakSelf.containerView);
    }];
    [self.cashLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.iconImage).with.equalTo(@18);
    }];
    
    
    [self.latelyCashLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.top.equalTo(weakSelf).with.offset(169);
        make.right.equalTo(weakSelf.loanCountLabel.mas_left);
        make.width.equalTo(weakSelf.loanCountLabel);
    }];
    [self.loanCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.latelyCashLabel.mas_right);
        make.top.equalTo(weakSelf).with.offset(169);
        make.right.equalTo(weakSelf.deadlineCountLabel.mas_left);
        make.width.equalTo(weakSelf.deadlineCountLabel);
    }];
    [self.deadlineCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.loanCountLabel.mas_right);
        make.top.equalTo(weakSelf).with.offset(169);
        make.right.equalTo(weakSelf);
        make.width.equalTo(weakSelf.latelyCashLabel);
    }];

    [self.latelyCashDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.top.equalTo(weakSelf).with.offset(197);
        make.right.equalTo(weakSelf.loanCountDataLabel.mas_left);
        make.width.equalTo(weakSelf.loanCountDataLabel);
    }];
    [self.loanCountDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.latelyCashDateLabel.mas_right);
        make.top.equalTo(weakSelf).with.offset(197);
        make.right.equalTo(weakSelf.deadlineCountDataLabel.mas_left);
        make.width.equalTo(weakSelf.deadlineCountDataLabel);
    }];
    [self.deadlineCountDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.loanCountDataLabel.mas_right);
        make.top.equalTo(weakSelf).with.offset(197);
        make.right.equalTo(weakSelf);
        make.width.equalTo(weakSelf.latelyCashDateLabel);
    }];

    
}
@end

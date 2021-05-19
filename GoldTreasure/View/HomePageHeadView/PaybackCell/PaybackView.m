//
//  PaybackView.m
//  GoldTreasure
//
//  Created by targeter on 2017/6/27.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "PaybackView.h"
#import <Masonry/Masonry.h>
@interface PaybackView()

/** @"应还金额" */
@property(nonatomic, strong)UILabel *payText;
/** @"到期" */
@property(nonatomic, strong)UILabel *daoQi;
/** @"天数" */
@property(nonatomic, strong)UILabel *tianHou;
/** @"逾期" */
@property(nonatomic, strong)UILabel *yuQi;
/** @"天" */
@property(nonatomic, strong)UILabel *tian;
/** 还款按钮 */
@property(nonatomic, strong)UIButton *paybackButton;
/** 续借按钮 */
@property(nonatomic, strong)UIButton *persistButton;
/** @"借款金额" */
@property(nonatomic, strong)UILabel *jieKuanJinE;
/** @"滞纳金" */
@property(nonatomic, strong)UILabel *zhiNaJin;
/** 额外底部滞纳金和本借款金额 */
@property(nonatomic, strong)UIView *extraView;

@property(nonatomic, strong)UIView *mainView;

@end

@implementation PaybackView

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"paybackViewCellAddModel";
    
//    PaybackView *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil) {
//        cell = [[PaybackView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
    PaybackView *cell = [[PaybackView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];

    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self addmainView];
        [self addExtral];
        
    }
    return self;
}

- (void)setPaybackCellModel:(GTPaybackCellModel *)PaybackCellModel
{

    if (PaybackCellModel) {
        if (PaybackCellModel.lateFlag.intValue == 1) {
            [self mainViewLayoutUnavailable];
            self.lateFeeLabel.text = [PaybackCellModel.lateFee centToYuan];
            int sumMoney = PaybackCellModel.lateFee.intValue + PaybackCellModel.reqMoney.intValue;
            NSNumber *sum = [NSNumber numberWithInt:sumMoney];
            self.loanLimit.text = [sum centToYuan];
            self.lateDaysLabel.text = [PaybackCellModel.lateDays toString];

        } else {
            if ([PaybackCellModel.remainDays integerValue] != 0) {
                [self mainViewLayoutAvailable];
            } else {
                [self mainViewLayoutAvailableZero];
            }
        }
        


        self.loanLimit.text = [PaybackCellModel.reqMoney centToYuan];
        self.availableDaysLabel.text = [PaybackCellModel.remainDays toString];
        self.loanCashLabel.text = [PaybackCellModel.reqMoney centToYuan];

    }
    

    [self layoutIfNeeded];

}



- (void)addmainView
{
    //应还金额
    _mainView = [[UIView alloc] init];
    _loanLimit = [[UILabel alloc] init];
    _loanLimit.textColor = [GTColor gtColorC4];
    _loanLimit.font = [GTFont gtFontF7];
    _loanLimit.text = @"3141.59";
    [_mainView addSubview:_loanLimit];
    
    //"@应还金额"
    _payText = [[UILabel alloc] init];
    _payText.text = @"应还金额";
    _payText.textColor = [GTColor gtColorC6];
    _payText.font = [GTFont gtFontF3];
    [_mainView addSubview:_payText];
    
    
    // 天数和按钮
    _lateDaysLabel = [[UILabel alloc] init];
    _lateDaysLabel.font = [GTFont gtFontF48];

    // 天数和按钮
    _availableDaysLabel = [[UILabel alloc] init];
    _availableDaysLabel.font = [GTFont gtFontF48];
    
    
    
    _tianHou = [[UILabel alloc] init];
    _tianHou.text = @"天后";
    _tianHou.font = [GTFont gtFontF3];
    _tianHou.textColor = [GTColor gtColorC6];
    
    _daoQi = [[UILabel alloc] init];
    _daoQi.text = @"到期";
    _daoQi.font = [GTFont gtFontF3];
    _daoQi.textColor = [GTColor gtColorC72D];
    
    _yuQi = [[UILabel alloc] init];
    _yuQi.text = @"逾期";
    _yuQi.font = [GTFont gtFontF3];
    _yuQi.textColor = [GTColor gtColorC72D];
    
    _tian = [[UILabel alloc] init];
    _tian.text = @"天";
    _tian.font = [GTFont gtFontF3];
    _tian.textColor = [GTColor gtColorC72D];
    
    _paybackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_paybackButton setTitle:@"还款" forState:UIControlStateNormal];
    _paybackButton.titleLabel.font = [GTFont gtFontF3];
    [_paybackButton setTitleColor:[GTColor gtColorC4] forState:UIControlStateNormal];
    [_paybackButton addTarget:self action:@selector(paybackNow) forControlEvents:UIControlEventTouchUpInside];
    _paybackButton.backgroundColor = [GTColor gtColorC9E5];
    _paybackButton.layer.borderWidth = 1;
    _paybackButton.layer.borderColor = [GTColor gtColorC953].CGColor;
    _paybackButton.layer.cornerRadius = 5;
    _paybackButton.layer.masksToBounds = YES;
    
    _persistButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_persistButton setTitle:@"续借" forState:UIControlStateNormal];
    _persistButton.titleLabel.font = [GTFont gtFontF3];
    [_persistButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_persistButton addTarget:self action:@selector(Loanpersist) forControlEvents:UIControlEventTouchUpInside];
    _persistButton.backgroundColor = [GTColor gtColorC72D];
    _persistButton.layer.cornerRadius = 5;
    _persistButton.layer.masksToBounds = YES;
    
    
    //到期天数
    _availableDaysLabel.textColor = [GTColor gtColorC4];
    _availableDaysLabel.text = @"7";

    
    [_mainView addSubview:_availableDaysLabel];
    
    [_mainView addSubview:_tianHou];
    [_mainView addSubview:_daoQi];
    

    
    [_mainView addSubview:_paybackButton];
    [_mainView addSubview:_persistButton];
    
    //逾期天数
    _lateDaysLabel.textColor = [GTColor gtColorC72D];
    _lateDaysLabel.text = @"3";

    [_mainView addSubview:_lateDaysLabel];
    [_mainView addSubview:_yuQi];
    [_mainView addSubview:_tian];
    [self addSubview:_mainView];
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@100);
    }];
    

}

- (void)mainViewLayoutAvailable
{
    [self.loanLimit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView).with.offset(21);
        make.top.equalTo(self.mainView).with.offset(15);
    }];
    
    [self.payText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loanLimit);
        make.bottom.equalTo(self.mainView).with.offset(-25);
        
    }];

    [self.availableDaysLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mainView).with.offset(-3);
        make.centerY.equalTo(self.mainView);
        
    }];
    
    [self.tianHou mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.availableDaysLabel.mas_right);
        make.bottom.equalTo(self.mainView.mas_centerY);
    }];
    [self.daoQi mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.availableDaysLabel.mas_right);
        make.top.equalTo(self.mainView.mas_centerY);
    }];
    
    [self.paybackButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mainView).with.offset(-15);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.mainView);
    }];
}

- (void)mainViewLayoutAvailableZero
{
    [self.loanLimit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView).with.offset(21);
        make.top.equalTo(self.mainView).with.offset(15);
    }];
    
    [self.payText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loanLimit);
        make.bottom.equalTo(self.mainView).with.offset(-25);
        
    }];
    
    [self.availableDaysLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mainView).with.offset(-3);
        make.centerY.equalTo(self.mainView);
        
    }];
    
    [self.tianHou mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.availableDaysLabel.mas_right);
        make.bottom.equalTo(self.mainView.mas_centerY);
    }];
    [self.daoQi mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.availableDaysLabel.mas_right);
        make.top.equalTo(self.mainView.mas_centerY);
    }];
    
    [self.paybackButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mainView).with.offset(-15);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
        make.top.equalTo(self.mainView).with.offset(15);
        
    }];
    [self.persistButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mainView).with.offset(-15);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
        make.bottom.equalTo(self.mainView).with.offset(-15);
    }];


    
    
    
    
}

- (void)mainViewLayoutUnavailable
{
    [self.loanLimit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainView).with.offset(21);
        make.top.equalTo(self.mainView).with.offset(15);
    }];
    
    [self.payText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.loanLimit);
        make.bottom.equalTo(self.mainView).with.offset(-25);
        
    }];
    
    [self.paybackButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mainView).with.offset(-15);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
        make.top.equalTo(self.mainView).with.offset(15);

    }];
    [self.persistButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mainView).with.offset(-15);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
        make.bottom.equalTo(self.mainView).with.offset(-15);
    }];

    
    //逾期天数
    [self.yuQi mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainView.mas_centerY);
        make.centerX.equalTo(self.mainView.mas_centerX).with.offset(-1.5);
    }];
    [self.lateDaysLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mainView);
        make.left.equalTo(self.yuQi.mas_right);
    }];
    [self.tian mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainView.mas_centerY);
        make.left.equalTo(self.lateDaysLabel.mas_right);
        
    }];
    
    [self extralLayout];
}
- (void)addExtral
{
    _extraView = [[UIView alloc] init];
    _extraView.backgroundColor = [GTColor gtColorC3];
    
    _jieKuanJinE = [[UILabel alloc] init];
    _jieKuanJinE.textColor = [GTColor gtColorC5];
    _jieKuanJinE.font = [GTFont gtFontF3];
    _jieKuanJinE.text = @"借款金额";
    
    _loanCashLabel = [[UILabel alloc] init];
    _loanCashLabel.textColor = [GTColor gtColorC4];
    _loanCashLabel.font = [GTFont gtFontF2];
    _loanCashLabel.text = @"3000.00";

    
    _zhiNaJin = [[UILabel alloc] init];
    _zhiNaJin.textColor = [GTColor gtColorC5];
    _zhiNaJin.font = [GTFont gtFontF3];
    _zhiNaJin.text = @"滞纳金";
    
    _lateFeeLabel = [[UILabel alloc] init];
    _lateFeeLabel.textColor = [GTColor gtColorC4];
    _lateFeeLabel.font = [GTFont gtFontF2];
    _lateFeeLabel.text = @"31.41";


    [_extraView addSubview:_jieKuanJinE];
    [_extraView addSubview:_loanCashLabel];
    [_extraView addSubview:_zhiNaJin];
    [_extraView addSubview:_lateFeeLabel];
    
    [self addSubview:_extraView];
//    [self extralLayout];
    
}

- (void)extralLayout
{
    [self.jieKuanJinE mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.extraView);
        make.left.equalTo(self.extraView).with.offset(17);
    }];
    [self.loanCashLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jieKuanJinE.mas_right).with.offset(10);
        make.centerY.equalTo(self.extraView);
    }];
    [self.zhiNaJin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jieKuanJinE.mas_right).offset(100);
        make.centerY.equalTo(self.extraView);
    }];
    [self.lateFeeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.zhiNaJin.mas_right).offset(10);
        make.centerY.equalTo(self.extraView);
    }];
    
    [self.extraView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.left.right.bottom.equalTo(self);
    }];
    

}
- (void)paybackNow
{
    if (self.nowPayback != nil) {
        self.nowPayback();
    }
    
}

- (void)Loanpersist
{
    if (self.persistLoan != nil) {
        self.persistLoan();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end

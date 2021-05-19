//
//  LoanDeatialHeadrView.m
//  GoldTreasure
//
//  Created by targeter on 2017/6/30.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "LoanDeatialHeadrView.h"
#import <Masonry/Masonry.h>

typedef enum : NSUInteger {
    WeiShenHe                 = 0, // 1XX
    ShenHeWeiTongGuo          = 1, // 1XX
    ShenHeTongGuo             = 2, // 2XX
    YiFangKuan                = 3, // 3XX
    FangKuanShiBai            = 4, // 4XX
    YiHuanKuan                = 5, // 5XX
    HuaiZhang                 = 6, // 5XX

} DetailLoanStatus;
@interface LoanDeatialHeadrView()

/** upView */
@property(nonatomic, strong)UIView *upView;
/** bottomView */
@property(nonatomic, strong)UIView *bottomView;
/** bgImg */
@property(nonatomic, strong)UIImageView *bgImage;
/** 还款金额Label */
@property(nonatomic, strong)UILabel *aTextLabel;
/** 还款金额图标 */
@property(nonatomic, strong)UIImageView *iconImage;
/** 还款金额整体 */
@property(nonatomic, strong)UIView *containerView;
/** 固定周期Label */
@property(nonatomic, strong)UILabel *guDingZhouQi;
/** 手续费Label */
@property(nonatomic, strong)UILabel *shouXufei;
/** 借款状态Label */
@property(nonatomic, strong)UILabel *jieKuanZhuangTai;
/** 申请时间Label */
@property(nonatomic, strong)UILabel *shenQingShiJian;
/** 借款时间Label */
@property(nonatomic, strong)UILabel *jieKuanShiJian;
/** 固定周期data */

@end
@implementation LoanDeatialHeadrView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createUpView];
        [self createBottomView];
    }
    return self;

}

- (void)setModel:(GTLoanOrderDetailResModel *)model
{
    if (model) {
        self.cashLabel.text = [model.reqMoney centToYuan];
        switch (model.loanStatus.intValue) {
            case 0:
                self.loanOrderStausLabel.text = @"申请中";
                self.loanOrderStausLabel.textColor = [GTColor gtColorApplicateBlue];
                break;
            case 1:
                self.loanOrderStausLabel.text = @"申请失败";
                self.loanOrderStausLabel.textColor = [GTColor gtColorC7];
                break;
            case 2:
                self.loanOrderStausLabel.text = @"放款中";
                self.loanOrderStausLabel.textColor = [GTColor gtColorCD69];
                break;
            case 3:
                if (model.lateFlag.intValue == 1) {
                    self.loanOrderStausLabel.text = @"已逾期";
                    self.loanOrderStausLabel.textColor = [GTColor gtColorC950];
                } else {
                    self.loanOrderStausLabel.text = @"已放款";
                    self.loanOrderStausLabel.textColor = [GTColor gtColorCD69];
                }
                break;
            case 4:
                self.loanOrderStausLabel.text = @"放款中";
                self.loanOrderStausLabel.textColor = [GTColor gtColorCD69];
                break;
            case 5:
                self.loanOrderStausLabel.text = @"正常结束";
                self.loanOrderStausLabel.textColor = [GTColor gtColorC953];
                break;
            case 6:
                if (model.lateFlag.intValue == 1) {
                    self.loanOrderStausLabel.text = @"已逾期";
                    self.loanOrderStausLabel.textColor = [GTColor gtColorC950];
                } else {
                    self.loanOrderStausLabel.text = @"已放款";
                    self.loanOrderStausLabel.textColor = [GTColor gtColorCD69];
                }
                break;
                
        }
        self.applicateDateLabel.text = model.reqTime;
        NSString *appendA = [[model.startTime localNetTimeToDate] stringByAppendingString:@"至"];
        self.loanDateLabel.text = [appendA stringByAppendingString:[model.endTime localNetTimeToDate]];
        self.feeLabel.text = [[model.handleFee centToYuan] stringByAppendingString:@"元"];
    }
}
- (void)createUpView
{
    _upView = [[UIView alloc] init];
    _bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bj_order"]];
    [_upView addSubview:_bgImage];
    [self addSubview:_upView];
    
    
    
    //借款金额大框
    _containerView = [[UIView alloc] init];
    _iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loan_16"]];
    [_containerView addSubview:_iconImage];
    _aTextLabel = [[UILabel alloc] init];
    _aTextLabel.text = @"借款金额（元）";
    _aTextLabel.textColor = [GTColor gtColorC4];
    _aTextLabel.font = [GTFont gtFontF3];
    [_containerView addSubview:_aTextLabel];
    [_upView addSubview:_containerView];
    //还款金额数据Label
    _cashLabel = [[UILabel alloc] init];
    _cashLabel.textColor = [GTColor gtColorC4];
    _cashLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:24];
        _cashLabel.text = @"0.00";
    [_upView addSubview:_cashLabel];

    [_bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_upView);
    }];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_upView);
        make.top.equalTo(_upView).with.equalTo(@18);
    }];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_containerView);
        make.top.equalTo(_containerView);
        make.bottom.equalTo(_containerView);
    }];
    [self.aTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImage.mas_right).with.equalTo(@10);
        make.right.equalTo(_containerView);
        make.centerY.equalTo(_containerView);
    }];
    [self.cashLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_upView);
        make.top.equalTo(_containerView.mas_bottom).with.equalTo(@11);
    }];

    [_upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@100);
    }];
    
}
- (void)createBottomView
{
    _bottomView = [[UIView alloc] init];
    [self addSubview:_bottomView];
    
    _guDingZhouQi = [[UILabel alloc] init];
    _guDingZhouQi.textColor = [GTColor gtColorC6];
    _guDingZhouQi.font = [GTFont gtFontF2];
    _guDingZhouQi.text = @"固定周期";
    [_bottomView addSubview:_guDingZhouQi];
    
    _shouXufei = [[UILabel alloc] init];
    _shouXufei.textColor = [GTColor gtColorC6];
    _shouXufei.font = [GTFont gtFontF2];
    _shouXufei.text = @"手续费";
    [_bottomView addSubview:_shouXufei];
    
    _jieKuanZhuangTai = [[UILabel alloc] init];
    _jieKuanZhuangTai.textColor = [GTColor gtColorC6];
    _jieKuanZhuangTai.font = [GTFont gtFontF2];
    _jieKuanZhuangTai.text = @"借款状态";
    [_bottomView addSubview:_jieKuanZhuangTai];
    
    _shenQingShiJian = [[UILabel alloc] init];
    _shenQingShiJian.textColor = [GTColor gtColorC6];
    _shenQingShiJian.font = [GTFont gtFontF2];
    _shenQingShiJian.text = @"申请时间";
    [_bottomView addSubview:_shenQingShiJian];
    
    _jieKuanShiJian = [[UILabel alloc] init];
    _jieKuanShiJian.textColor = [GTColor gtColorC6];
    _jieKuanShiJian.font = [GTFont gtFontF2];
    _jieKuanShiJian.text = @"借款时间";
    [_bottomView addSubview:_jieKuanShiJian];

    _circleTimeLabel = [[UILabel alloc] init];
    _circleTimeLabel.textColor = [GTColor gtColorC4];
    _circleTimeLabel.font = [GTFont gtFontF2];
    _circleTimeLabel.text = @"7天";
    [_bottomView addSubview:_circleTimeLabel];
    
    _feeLabel = [[UILabel alloc] init];
    _feeLabel.textColor = [GTColor gtColorC4];
    _feeLabel.font = [GTFont gtFontF2];
    _feeLabel.text = @"0.00元";
        
    [_bottomView addSubview:_feeLabel];
    
    _loanOrderStausLabel = [[UILabel alloc] init];
    _loanOrderStausLabel.textColor = [GTColor gtColorC4];
    _loanOrderStausLabel.font = [GTFont gtFontF2];
    [_bottomView addSubview:_loanOrderStausLabel];
    
    _applicateDateLabel = [[UILabel alloc] init];
    _applicateDateLabel.textColor = [GTColor gtColorC4];
    _applicateDateLabel.font = [GTFont gtFontF2];
        _applicateDateLabel.text = @"2017.06.02 15:12";
    [_bottomView addSubview:_applicateDateLabel];
    
    _loanDateLabel = [[UILabel alloc] init];
    _loanDateLabel.textColor = [GTColor gtColorC4];
    _loanDateLabel.font = [GTFont gtFontF2];
        _loanDateLabel.text = @"2017.06.02至2017.06.08";

    [_bottomView addSubview:_loanDateLabel];


    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.top.equalTo(_upView.mas_bottom);
    }];
    
    [_guDingZhouQi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_bottomView).offset(15);
        make.height.mas_equalTo(18);
    }];
    [_shouXufei mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomView).offset(15);
        make.top.equalTo(_guDingZhouQi.mas_bottom).offset(14);
        make.height.mas_equalTo(18);

    }];
    [_jieKuanZhuangTai mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomView).offset(15);
        make.top.equalTo(_shouXufei.mas_bottom).offset(14);
        make.height.mas_equalTo(18);

    }];
    [_shenQingShiJian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomView).offset(15);
        make.top.equalTo(_jieKuanZhuangTai.mas_bottom).offset(14);
        make.height.mas_equalTo(18);

    }];
    [_jieKuanShiJian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomView).offset(15);
        make.top.equalTo(_shenQingShiJian.mas_bottom).offset(14);
        make.height.mas_equalTo(18);

    }];

    [_circleTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_guDingZhouQi);
        make.left.equalTo(_bottomView).offset(120);
    }];
    
    [_feeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_shouXufei);
        make.left.equalTo(_bottomView).offset(120);
    }];
    [_loanOrderStausLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_jieKuanZhuangTai);
        make.left.equalTo(_bottomView).offset(120);
    }];
    [_applicateDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_shenQingShiJian);
        make.left.equalTo(_bottomView).offset(120);
    }];
    [_loanDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_jieKuanShiJian);
        make.left.equalTo(_bottomView).offset(120);
    }];



}
@end

//
//  GTTableViewCell.m
//  GoldTreasure
//
//  Created by targeter on 2017/6/27.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTTableViewCell.h"
#import <Masonry/Masonry.h>
@interface GTTableViewCell()
@property(nonatomic, weak)UIView *loanCellView;
/** 借款状态 */
@property(nonatomic, strong)NSString *loanOrderStaus;
/** loanLimit金额 */
@property(nonatomic, strong)UILabel *loanLimit;
/** 申请日期 */
@property(nonatomic, strong)UILabel *applicateDate;
/** 还款日期 */
@property(nonatomic, strong)UILabel *payBackDate;
/** _statusIcon */
@property(nonatomic, strong)UIImageView *statusIcon;


@end
@implementation GTTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"loanList";
    
    GTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[GTTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (void)setOrderList:(GTResModelLoanOrder *)orderList
{
    if (orderList) {
        self.loanLimit.text = [[orderList.reqMoney centToYuan] addYuan];
        self.applicateDate.text = [orderList.reqTime substringWithRange:NSMakeRange(0, 10)];
        self.payBackDate.text = [orderList.endTime substringWithRange:NSMakeRange(0, 10)];
        self.payBackDate.textColor = [GTColor gtColorC5];
        self.loanOrderStaus = [orderList.loanStatus toString];
        if (orderList.loanStatus.intValue == 3 || orderList.loanStatus.intValue == 6) {
            switch (orderList.lateFlag.intValue) {
                case 0:
                    self.statusIcon.image = [UIImage imageNamed:@"3"];
                    break;
                case 1:
                    self.statusIcon.image = [UIImage imageNamed:@"6"];
                    self.payBackDate.textColor = [GTColor gtColorC950];
                    break;
            }
            
            } else {
                self.statusIcon.image = [UIImage imageNamed:self.loanOrderStaus];

            }
        }

    [self layoutIfNeeded];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [GTColor gtColorC3];
        WEAKSELF
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [UIColor whiteColor];
        backgroundView.layer.cornerRadius = 5;
        backgroundView.layer.masksToBounds = YES;
        [self addSubview:backgroundView];
        [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(weakSelf);
            make.top.equalTo(weakSelf).offset(1);
            make.right.equalTo(weakSelf).offset(-2);
        }];
        //左边图标
        UIImageView *moneyIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loan"]];
        [backgroundView addSubview:moneyIcon];
        [moneyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundView).with.offset(15);
            make.top.equalTo(backgroundView).with.offset(15);
            
        }];
        //"借款金额："
        UILabel *loanText = [[UILabel alloc] init];
        loanText.text = @"借款金额：";
        loanText.textColor = [GTColor gtColorC4];
        loanText.font = [GTFont gtFontF2];
        [backgroundView addSubview:loanText];
        [loanText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(moneyIcon.mas_right).with.offset(10);
            make.top.equalTo(backgroundView).with.offset(14);
        }];
        //借款金额额度
        _loanLimit = [[UILabel alloc] init];
        _loanLimit.textColor = [GTColor gtColorC4];
        _loanLimit.font = [GTFont gtFontF2];

        [backgroundView addSubview:_loanLimit];
        [_loanLimit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(loanText.mas_right).with.offset(0);
            make.top.equalTo(backgroundView).with.offset(14);
        }];
        //横向分割线
        UIView *landscapeSeperator = [[UIView alloc] init];
        landscapeSeperator.backgroundColor = [GTColor gtColorC8];
        [backgroundView addSubview:landscapeSeperator];
        [landscapeSeperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundView).with.offset(0);
            make.top.equalTo(backgroundView).with.offset(50);
            make.right.equalTo(backgroundView).with.offset(0);
            make.height.equalTo(@1);
        }];
        //借款状态
        _statusIcon = [[UIImageView alloc] init];

        [self addSubview:_statusIcon];
        [_statusIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf);
            make.top.equalTo(weakSelf);
            
        }];

        //@"申请日期"
        UILabel *applicateText = [[UILabel alloc] init];
        applicateText.text = @"申请日期";
        applicateText.textColor = [GTColor gtColorC6];
        applicateText.font = [GTFont gtFontF3];
        [backgroundView addSubview:applicateText];
        [applicateText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundView).with.offset(58);
            make.top.equalTo(landscapeSeperator).with.offset(10);
        }];
        //申请日期
        _applicateDate = [[UILabel alloc] init];
        _applicateDate.font = [GTFont gtFontF3];
        _applicateDate.textColor = [GTColor gtColorC5];
        [backgroundView addSubview:_applicateDate];
        [_applicateDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(applicateText);
            make.top.equalTo(applicateText.mas_bottom).with.offset(9);
        }];
        
        //@"还款日期"
        UILabel *payBackText = [[UILabel alloc] init];
        payBackText.text = @"还款日期";
        payBackText.textColor = [GTColor gtColorC6];
        payBackText.font = [GTFont gtFontF3];
        [backgroundView addSubview:payBackText];
        [payBackText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backgroundView).with.offset(-58);
            make.top.equalTo(landscapeSeperator).with.offset(10);
        }];
        //还款日期
        _payBackDate = [[UILabel alloc] init];
        _payBackDate.font = [GTFont gtFontF3];
        _payBackDate.textColor = [GTColor gtColorC5];
        [backgroundView addSubview:_payBackDate];
        [_payBackDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(payBackText);
            make.top.equalTo(payBackText.mas_bottom).with.offset(9);
        }];
        //竖直分割线
        UIView *portraitSeperator = [[UIView alloc] init];
        portraitSeperator.backgroundColor = [GTColor gtColorC8];
        [backgroundView addSubview:portraitSeperator];
        [portraitSeperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backgroundView);
            make.bottom.equalTo(backgroundView.mas_bottom).with.offset(-25);
            make.height.equalTo(@15);
            make.width.equalTo(@1);
        }];
        //设置圆角
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;

    }

    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

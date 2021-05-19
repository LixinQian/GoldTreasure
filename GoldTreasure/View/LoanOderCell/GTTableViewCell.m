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
@end
@implementation GTTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        __weak typeof (self) weakSelf = self;
        //左边图标
        UIImageView *moneyIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loan"]];
        [self addSubview:moneyIcon];
        [moneyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(15);
            make.top.equalTo(self).with.offset(15);
            
        }];
        //"借款金额："
        UILabel *loanText = [[UILabel alloc] init];
        loanText.text = @"借款金额：";
        loanText.textColor = [GTColor gtColorC4];
        loanText.font = [GTFont gtFontF2];
        [self addSubview:loanText];
        [loanText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(moneyIcon.mas_right).with.offset(10);
            make.top.equalTo(self).with.offset(14);
        }];
        //借款金额额度
        UILabel *loanLimit = [[UILabel alloc] init];
        loanLimit.textColor = [GTColor gtColorC4];
        loanLimit.font = [GTFont gtFontF2];
        if (self.LoanCash) {
            loanLimit.text = self.LoanCash;
        }else {
            loanLimit.text = @"1500.00";
        }
        [self addSubview:loanLimit];
        [loanLimit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(loanText.mas_right).with.offset(0);
            make.top.equalTo(self).with.offset(14);
        }];
        //借款状态
        UIImageView *stausIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1"]];
        [self addSubview:stausIcon];
        [stausIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(0);
            make.top.equalTo(self).with.offset(0);
            
        }];
        //横向分割线
        UIView *landscapeSeperator = [[UIView alloc] init];
        landscapeSeperator.backgroundColor = [UIColor grayColor];
        [self addSubview:landscapeSeperator];
        [landscapeSeperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(0);
            make.top.equalTo(self).with.offset(50);
            make.right.equalTo(self).with.offset(0);
            make.height.equalTo(@1);
        }];
        //@"申请日期"
        UILabel *applicateText = [[UILabel alloc] init];
        applicateText.text = @"申请日期";
        applicateText.textColor = [GTColor gtColorC6];
        applicateText.font = [GTFont gtFontF3];
        [self addSubview:applicateText];
        [applicateText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(58);
            make.top.equalTo(landscapeSeperator).with.offset(10);
        }];
        //申请日期
        UILabel *applicateDate = [[UILabel alloc] init];
        applicateDate.font = [GTFont gtFontF3];
        applicateDate.textColor = [GTColor gtColorC6];
        if (self.loanDate) {
            applicateDate.text = self.loanDate;
            
        }else {
            applicateDate.text = @"无";
            
        }
        [self addSubview:applicateDate];
        [applicateDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(applicateText);
            make.top.equalTo(applicateText.mas_bottom).with.offset(9);
        }];
        
        //@"还款日期"
        UILabel *payBackText = [[UILabel alloc] init];
        payBackText.text = @"还款日期";
        payBackText.textColor = [GTColor gtColorC6];
        payBackText.font = [GTFont gtFontF3];
        [self addSubview:payBackText];
        [payBackText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-58);
            make.top.equalTo(landscapeSeperator).with.offset(10);
        }];
        //还款日期
        UILabel *payBackDate = [[UILabel alloc] init];
        payBackDate.font = [GTFont gtFontF3];
        payBackDate.textColor = [GTColor gtColorC6];
        if (self.payDate) {
            payBackDate.text = self.payDate;
            
        }else {
            payBackDate.text = @"无";
            
        }
        [self addSubview:payBackDate];
        [payBackDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(payBackText);
            make.top.equalTo(payBackText.mas_bottom).with.offset(9);
        }];
        //竖直分割线
        UIView *portraitSeperator = [[UIView alloc] init];
        portraitSeperator.backgroundColor = [UIColor grayColor];
        [self addSubview:portraitSeperator];
        [portraitSeperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).with.offset(-25);
            make.height.equalTo(@15);
            make.width.equalTo(@1);
        }];
        //设置圆角
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

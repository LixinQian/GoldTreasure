//
//  GTAmountNormalCell.m
//  GoldTreasure
//
//  Created by 王超 on 2017/7/3.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTAmountNormalCell.h"
#import <Masonry/Masonry.h>

@interface GTAmountNormalCell ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *rightLbl;
@property (nonatomic, strong) UIButton *rateBtn;

@end
@implementation GTAmountNormalCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // NSLog(@"cellForRowAtIndexPath");
    static NSString *identifier = @"status";
    // 1.缓存中取
    GTAmountNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[GTAmountNormalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [GTFont gtFontF2];
        titleLabel.textColor = [GTColor gtColorC4];
        [self.contentView addSubview:titleLabel];
        self.titleLbl = titleLabel;
        
        UILabel *rightLabel = [UILabel new];
        rightLabel.font = [GTFont gtFontF2];
        rightLabel.textColor = [GTColor gtColorC5];
        rightLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:rightLabel];
        self.rightLbl = rightLabel;
        
        self.rateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rateBtn setImage:[UIImage imageNamed:@"explain"] forState:UIControlStateNormal];
        [self.rateBtn addTarget:self action:@selector(rateBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.rateBtn];
        self.rateBtn.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(autoScaleW(15));
        make.centerY.equalTo(self);
        make.height.mas_equalTo(autoScaleH(18));
//        make.size.mas_equalTo(CGSizeMake(100, 18));
    }];
    [self.rightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(autoScaleW(-15));
        make.centerY.equalTo(self);
        make.height.mas_equalTo(autoScaleH(18));
    }];
}
-(void)setRateBtnUI
{
    [self.rateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.titleLbl.mas_right).offset(autoScaleW(-10));
        make.size.mas_equalTo(CGSizeMake(autoScaleW(30), autoScaleH(30)));
    }];
}
-(void)rateBtnAction
{
    self.amountCellBlock();
}

-(void)setModel:(OrderModel *)model
{
    _model = model;
    NSString *textStr = [self titleArr][_indexP.section-1][_indexP.row];
    self.titleLbl.text = textStr;
    if (_indexP.section == 1) {
        if (_indexP.row == 1) {
            if (model.interestDay) {
                self.titleLbl.text = [textStr stringByReplacingOccurrencesOfString:@"~~" withString:[NSString stringWithFormat:@"%.2f%%",[model.interestDay doubleValue]/100]];
            }
        }else if (_indexP.row == 2)
        {
            if (model.magFeeDay) {
                double fee = [model.magFeeDay doubleValue]/100;
                
                self.titleLbl.text = [textStr stringByReplacingOccurrencesOfString:@"~~" withString:[NSString stringWithFormat:@"%.2f%%",fee]];
            }
            //布局利率按钮
            [self setRateBtnUI];
        }
    }
    else if (_indexP.section == 2)
    {
        if (_indexP.row == 1)
        {
            NSString *bank = [GTUser.manger.userInfoModel.bankName stringByAppendingString:@" (~)"];
            
//            NSLog(@"%@", [GTUser.manger.userInfoModel yy_modelToJSONObject]);
            NSString *number = [NSString stringWithFormat:@"%@",GTUser.manger.userInfoModel.cardNumber];
            if ([number isEqualToString:@"0"]) {
                self.rightLbl.text =bank;
                return;
            }
            self.rightLbl.text = [bank stringByReplacingOccurrencesOfString:@"~" withString:[number substringFromIndex:number.length-4]];
        }
    }
}
-(void)setIndexP:(NSIndexPath *)indexP
{
    _indexP = indexP;
}

-(void)setAmountWithIndexPath:(NSIndexPath *)indexP Model:(OrderModel *)model
{
    double interest = [model.borrowAmount doubleValue] * ([_model.interestDay doubleValue]/10000) * [model.period integerValue];
    double magFeeDay = [model.borrowAmount doubleValue] * ([_model.magFeeDay doubleValue]/10000) * [model.period integerValue];
    double arrivalAmount = [model.borrowAmount doubleValue] - interest - magFeeDay;
    
    NSString *tian = @"天";
    NSString *yuan = @"元";
    if (indexP.section == 1) {
        if (indexP.row == 0) {
            self.rightLbl.text = [[NSString stringWithFormat:@"%ld",[model.period integerValue]] stringByAppendingString:tian];
            
        }else if (indexP.row == 1)
        {
            self.rightLbl.text = [[NSString stringWithFormat:@"%.2f",interest] stringByAppendingString:yuan];
        }else if (indexP.row == 2)
        {
            self.rightLbl.text = [[NSString stringWithFormat:@"%.2f",magFeeDay] stringByAppendingString:yuan];
        }
    }
    else
    {
    
        if (indexP.row == 0) {
          
            self.rightLbl.text = [[NSString stringWithFormat:@"%.2f",arrivalAmount] stringByAppendingString:yuan];
        }
        
    }
}

-(NSArray *)titleArr
{
    return @[@[@"固定周期",@"借款利息（~~/天）",@"管理费（~~/天）"],
             @[@"到账金额",@"收款卡号"]];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

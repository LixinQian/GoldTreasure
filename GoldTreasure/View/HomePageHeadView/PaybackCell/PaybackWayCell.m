//
//  PaybackWayCell.m
//  GoldTreasure
//
//  Created by targeter on 2017/7/3.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "PaybackWayCell.h"
#import <Masonry/Masonry.h>
@interface PaybackWayCell()

/** topLabel */
@property(nonatomic, strong)UILabel *topLabel;
/** bottomLabel */
@property(nonatomic, strong)UILabel *bottomLabel;
/** 图片 */
@property(nonatomic, strong)UIImageView *imageLeft;


@end

@implementation PaybackWayCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"paybackWay";
    PaybackWayCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PaybackWayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setViews];
        [self setFooterLine];
        [self setHeaderLine];
        [self setSingleButton];
    }
    return self;
}


- (void)setHeaderLine
{
    _headerLine = [[UIView alloc] init];
    _headerLine.backgroundColor = [GTColor gtColorC8];
    [self addSubview:_headerLine];
    [_headerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.height.equalTo(@1);
    }];
    _headerLine.hidden = YES;
}

- (void)setFooterLine
{
    _footerLine = [[UIView alloc] init];
    _footerLine.backgroundColor = [GTColor gtColorC15];
    [self addSubview:_footerLine];
    [_footerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.height.equalTo(@1);
    }];
    _footerLine.hidden = YES;
}

-(void)setValueWithIndex:(NSInteger)index;
{
    if (index == 1) {
        self.imageLeft.image = [UIImage imageNamed:@"icon_lianlianpay"];
        self.topLabel.text = @"连连支付";
        self.bottomLabel.text = @"推荐支付方式";
    } else if (index == 2) {
        self.imageLeft.image = [UIImage imageNamed:@"icon_alipay"];
        self.topLabel.text = @"支付宝支付";
        self.bottomLabel.text = @"推荐已开通支付宝支付的用户使用";
    }
}

- (void)setViews
{
    [self imageLeft];
    [self topLabel];
    [self bottomLabel];
}

- (UIImageView *)imageLeft
{
    _imageLeft = [[UIImageView alloc] init];
    [self addSubview:_imageLeft];
    [_imageLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.height.equalTo(@51);
        make.width.equalTo(@50);
    }];
    return _imageLeft;
}

- (UILabel *)topLabel
{
    _topLabel = [[UILabel alloc] init];
    _topLabel.textColor = [GTColor gtColorC4];
    _topLabel.font = [GTFont gtFontF2];
    [self addSubview:_topLabel];
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageLeft.mas_right).offset(10);
        make.top.equalTo(_imageLeft);
        make.height.equalTo(@18);
    }];
    return _topLabel;
}

- (UILabel *)bottomLabel
{
    _bottomLabel = [[UILabel alloc] init];
    _bottomLabel.textColor = [GTColor gtColorC6];
    _bottomLabel.font = [GTFont gtFontF3];
    [self addSubview:_bottomLabel];
    [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageLeft.mas_right).offset(10);
        make.top.equalTo(_topLabel.mas_bottom).offset(12);
        make.height.equalTo(@16);
    }];
    return _bottomLabel;
}

- (void)setSingleButton
{
    _singleButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"not_selected"]];
    [self addSubview:_singleButton];
    [_singleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-15);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        _singleButton.image = [UIImage imageNamed:@"selected"];
    } else {
        _singleButton.image = [UIImage imageNamed:@"not_selected"];
    }
}

@end

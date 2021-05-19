//
//  LateFeeHeaderCell.m
//  GoldTreasure
//
//  Created by targeter on 2017/6/30.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "LateFeeHeaderCell.h"
#import <Masonry/Masonry.h>
#import "GTUserSettingsViewController.h"

@interface LateFeeHeaderCell()
/** 滞纳金 */
@property(nonatomic, strong)UILabel *zhiNaJin;

@end
@implementation LateFeeHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setUpZhiNaJin];
        [self setUpHeaderLine];
        [self setUpComma];
//        self.comma.hidden = YES;
    }
    return self;
}

- (void)setUpZhiNaJin
{
    _zhiNaJin = [[UILabel alloc] init];
    _zhiNaJin.textColor = [GTColor gtColorC5];
    _zhiNaJin.font = [GTFont gtFontF2];
    _zhiNaJin.text = @"滞纳金";
    [self addSubview:_zhiNaJin];
    
    [_zhiNaJin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).equalTo(@9);
        make.left.equalTo(self).equalTo(@15);
        make.height.equalTo(@18);
    }];


}

- (void)setUpComma
{
    _comma = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"explain"]];
    [self addSubview:_comma];
    [_comma mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.zhiNaJin);
        make.left.equalTo(_zhiNaJin.mas_right).offset(10);
    }];
}

- (void)setUpHeaderLine
{
    _footerLine = [[UIView alloc] init];
    _footerLine.backgroundColor = [GTColor gtColorC8];
    [self addSubview:_footerLine];
    [_footerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.height.equalTo(@1);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

//    if (selected) {
//        if (_status = 1) {
//            self.tap();
//    }
//
//    }
}

@end

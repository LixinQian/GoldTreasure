//
//  LateFeeCell.m
//  GoldTreasure
//
//  Created by targeter on 2017/6/30.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "LateFeeCell.h"
#import <Masonry/Masonry.h>
@interface LateFeeCell()


@end

@implementation LateFeeCell

- (void)setLateFeeModel:(GTLatefees *)lateFeeModel
{
    self.feeDateLabel.text = [lateFeeModel.createTime localNetTimeToDate];
    self.type = lateFeeModel.type.intValue;
    if (lateFeeModel.type.intValue == 2) {
        lateFeeModel.money = [NSNumber numberWithInt:-lateFeeModel.money.intValue];
        self.feeLabel.text = [[lateFeeModel.money centToYuan] addYuan];
    } else {
        self.feeLabel.text = [[lateFeeModel.money centToYuan] addYuan];

    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setSubView];
    }
    return self;
}
- (void)setSubView
{
    _feeDateLabel = [[UILabel alloc] init];
    _feeDateLabel.textColor = [GTColor gtColorC5];
    _feeDateLabel.font = [GTFont gtFontF2];
    _feeDateLabel.text = @"_";

    [self addSubview:_feeDateLabel];

    
    [_feeDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.height.equalTo(@18);
        make.left.equalTo(self).offset(15);
    }];
    
    _feeLabel = [[UILabel alloc] init];
    _feeLabel.textColor = [GTColor gtColorC950];
    _feeLabel.font = [GTFont gtFontF2];
    _feeLabel.text = @"0.00 元";

    [self addSubview:_feeLabel];
    
    
    [_feeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.height.equalTo(@18);
        make.right.equalTo(self).offset(-15);
    }];

    
    

    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.textColor = [GTColor gtColorC8];
    lineLabel.text = @"_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ ";
    lineLabel.font = [GTFont gtFontF1];
    lineLabel.lineBreakMode = NSLineBreakByClipping;
    lineLabel.numberOfLines = 1;
    [self addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-15);
        make.left.equalTo(self).offset(15);
    }];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  NowPaybackCell.m
//  GoldTreasure
//
//  Created by targeter on 2017/7/3.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "NowPaybackCell.h"
#import <Masonry/Masonry.h>

@interface NowPaybackCell()

/** title */
@property(nonatomic, strong)UILabel *titleLabel;
/** value */
@property(nonatomic, strong)UILabel *valueLabel;

@end
@implementation NowPaybackCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // NSLog(@"cellForRowAtIndexPath");
    static NSString *identifier = @"paybackClick";
    // 1.缓存中取
    NowPaybackCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[NowPaybackCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setLabels];
        [self setFooterLine];
        [self setHeaderLine];
        
    }
    return self;
}

/** 设置左右两边的title和数值 */
-(void)setTitle:(NSString *)Title AndValue:(NSString *)Value;
{
    self.titleLabel.text = Title;
    self.valueLabel.text = Value;
}

- (void)setLabels
{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [GTColor gtColorC6];
    _titleLabel.font = [GTFont gtFontF2];
    [self addSubview:_titleLabel];
    
    _valueLabel = [[UILabel alloc] init];
    _valueLabel.textColor = [GTColor gtColorC4];
    _valueLabel.font = [GTFont gtFontF2];
    
    [self addSubview:_valueLabel];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(14);
        make.height.equalTo(@18);
    }];
    
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(120);
        make.centerY.equalTo(_titleLabel);
        make.height.equalTo(@18);
    }];

}

- (void)setHeaderLine
{
    _headerLine = [[UIView alloc] init];
    _headerLine.backgroundColor = [GTColor gtColorC15];
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
    _footerLine.backgroundColor = [GTColor gtColorC8];
    [self addSubview:_footerLine];
    [_footerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.height.equalTo(@1);
    }];
    _footerLine.hidden = YES;
}


@end

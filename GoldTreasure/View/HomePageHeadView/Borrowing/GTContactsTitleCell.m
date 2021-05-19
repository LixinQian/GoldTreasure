//
//  GTContactsTitleCell.m
//  GoldTreasure
//
//  Created by 王超 on 2017/7/1.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTContactsTitleCell.h"
#import <Masonry/Masonry.h>

@interface GTContactsTitleCell ()

@property (nonatomic, weak) UIView *line;
@property (nonatomic, weak) UILabel *titleLabel;

@end
@implementation GTContactsTitleCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // NSLog(@"cellForRowAtIndexPath");
    static NSString *identifier = @"status";
    // 1.缓存中取
    GTContactsTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[GTContactsTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [GTFont gtFontF2];
        titleLabel.textColor = [GTColor gtColorC9];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIView *line = [UIView new];
        line.backgroundColor = [GTColor gtColorC1];
        line.layer.cornerRadius = 2;
        line.layer.masksToBounds = YES;
        [self.contentView addSubview:line];
        self.line = line;
        [self setFooterLine];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(autoScaleW(15));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(autoScaleW(6), autoScaleH(20)));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line.mas_right).offset(autoScaleW(10));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(autoScaleW(100), autoScaleH(18)));
    }];
}

-(void)setValueWithIndex:(NSInteger)index
{
    NSString *str = @"紧急联系人";
    self.titleLabel.text = [str stringByAppendingString:[NSString stringWithFormat:@"%ld",index+1]];
}

-(void)setValueWithTitle:(NSString *)Title
{
    self.titleLabel.text = Title;
}

- (void)setFooterLine
{
    _footerLine = [[UIView alloc] init];
    _footerLine.backgroundColor = [GTColor gtColorC15];
    [self addSubview:_footerLine];
    [_footerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
    _footerLine.hidden = YES;
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

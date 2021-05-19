//
//  GTMineTableViewCell.m
//  GoldTreasure
//
//  Created by wangyaxu on 27/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTMineTableViewCell.h"

#import <Masonry/Masonry.h>

@interface GTMineTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation GTMineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _lineView = [UIView new];
        _lineView.backgroundColor = [GTColor gtColorC8];
        [self addSubview:_lineView];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@.5f);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self.mas_left).with.offset(15);
        }];
    }
    return self;
}

- (void)setIcon:(UIImage *)image
{
    [self.contentView addSubview:self.iconImageView];
    self.iconImageView.image = image;
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).with.offset(15);
    }];
}

- (void)setTitle:(NSString *)title
{
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.text = title;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        if (_iconImageView) {
            make.left.equalTo(self.iconImageView.mas_right).with.offset(12);
        } else {
            make.left.equalTo(self.contentView.mas_left).with.offset(15);
        }
    }];
}

- (void)setSubTitle:(NSString *)subTitle withOffset:(CGFloat)offset
{
    [self.contentView addSubview:self.subTitleLabel];
    self.subTitleLabel.text = subTitle;
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).with.offset(offset);
    }];
}

- (void)shouldHideSeparatorLine:(BOOL)hidden
{
    self.lineView.hidden = hidden;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[GTFont gtFontF2] textColor:[GTColor gtColorC4]];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel labelWithFont:[GTFont gtFontF2] textColor:[GTColor gtColorC6]];
    }
    return _subTitleLabel;
}

@end

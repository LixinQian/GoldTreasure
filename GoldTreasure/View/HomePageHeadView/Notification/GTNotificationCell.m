//
//  GTNotificationCell.m
//  GoldTreasure
//
//  Created by 王超 on 2017/7/6.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTNotificationCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface GTNotificationCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UILabel *details;

@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIButton *doBtn;

@end

@implementation GTNotificationCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [GTColor gtColorC3];
        [self createView];
    }
    return self;
}

-(void)createView
{
    _bgView = [[UIView alloc]init];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 5;
    _bgView.layer.masksToBounds = YES;
    [self.contentView addSubview:_bgView];
    
    _icon = [[UIImageView alloc]init];
    [_bgView addSubview:_icon];
    
    _title = [[UILabel alloc]init];
    _title.font = [GTFont gtFontF2];
    _title.textColor = [GTColor gtColorC4];
    [_bgView addSubview:_title];
    
    _time = [[UILabel alloc]init];
    _time.font = [GTFont gtFontF3];
    _time.textColor = [GTColor gtColorC6];
    _time.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:_time];
    
    _line1 = [[UIView alloc]init];
    _line1.backgroundColor = [GTColor gtColorC8];
    [_bgView addSubview:_line1];
    
    _details = [[UILabel alloc]init];
    _details.textColor = [GTColor gtColorC6];
    _details.font = [GTFont gtFontF3];
    _details.numberOfLines = 0;
    [_bgView addSubview:_details];
    
    _line2 = [[UIView alloc]init];
    _line2.backgroundColor = [GTColor gtColorC8];
    [_bgView addSubview:_line2];
    _doBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _doBtn.adjustsImageWhenHighlighted = NO;
    [_doBtn addTarget:self action:@selector(doAction) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_doBtn];
    _doBtn.titleLabel.font = [GTFont gtFontF2];
    [_doBtn setTitleColor:[GTColor gtColorBlue] forState:UIControlStateNormal];
    
    [self setlayout];
}

-(void)setlayout
{
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(7.5);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView).offset(-7.5);
    }];
    
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bgView.mas_top).offset(25);
        make.left.equalTo(_bgView).offset(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_icon);
        make.left.equalTo(_icon.mas_right).offset(10);
    }];
    
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_icon);
        make.right.equalTo(_bgView).offset(-10);
    }];
    
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_bgView);
        make.top.equalTo(_bgView).offset(50);
        make.height.mas_equalTo(1);
    }];
    
    [_details mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView).offset(15);
        make.right.equalTo(_bgView).offset(-15);
        make.top.equalTo(_line1.mas_bottom).offset(10);
        
    }];
    
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bgView).offset(15);
        make.top.equalTo(_details.mas_bottom).offset(10);
        make.right.equalTo(_bgView).offset(-15);
        make.height.mas_equalTo(1);
    }];
    [_doBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bgView);
        make.top.equalTo(_line2.mas_bottom).offset(9);
        make.height.mas_equalTo(18);
        make.bottom.equalTo(_bgView).offset(-13);
    }];
    
}

-(void)doAction
{
    self.notiBlock(self.model);
}
-(void)setModel:(GTNotificationModel *)model
{
    _model = model;
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:model.logo]];
    _title.text = model.mTitle;
    _time.text = [model.createTime substringFromIndex:5];
    _details.text = model.content;
    [_doBtn setTitle:[NSString stringWithFormat:@"%@>>",model.bText] forState:UIControlStateNormal];
    
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

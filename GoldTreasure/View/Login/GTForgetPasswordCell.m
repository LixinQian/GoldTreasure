//
//  GTForgetPasswordCell.m
//  GoldTreasure
//
//  Created by 王超 on 2017/6/29.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTForgetPasswordCell.h"
#import <Masonry/Masonry.h>

@interface GTForgetPasswordCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *codeBtn;

@end

@implementation GTForgetPasswordCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

-(void)createView
{
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [GTFont gtFontF2];
    self.titleLabel.textColor = [GTColor gtColorC4];
    [self.contentView addSubview:self.titleLabel];
    self.subTitleTF = [UITextField new];
    self.subTitleTF.font = [GTFont gtFontF2];
    self.subTitleTF.textColor = [GTColor gtColorC4];
    [self.contentView addSubview:self.subTitleTF];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(autoScaleW(15));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(autoScaleW(80), autoScaleH(18)));
    }];
}

-(void)setCellWithStyle:(CellStyle)style
{
    switch (style) {
        case CellStyleNormal:
        {
            [self.subTitleTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.titleLabel.mas_right).offset(autoScaleW(5));
                make.centerY.equalTo(self);
                make.right.mas_equalTo(self).offset(autoScaleW(-15));
                make.height.mas_equalTo(autoScaleH(18));
            }];
        }
            break;
        case CellStyleCode:
        {
            [self.subTitleTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.titleLabel.mas_right).offset(autoScaleW(5));
                make.centerY.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(autoScaleW(100), autoScaleH(18)));
            }];
            self.codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.codeBtn.layer.cornerRadius = 5;
            self.codeBtn.layer.masksToBounds = YES;
            [self.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
            [self.codeBtn setTitleColor:[GTColor gtBtnColorC] forState:UIControlStateNormal];
            self.codeBtn.titleLabel.font = [GTFont gtFontF2];
            self.codeBtn.backgroundColor = [GTColor gtColorC1];
            [self.codeBtn setBackgroundImage:[UIImage initWithColor:[GTColor gtColorC1]] forState:UIControlStateNormal];
            [self.codeBtn addTarget:self action:@selector(codeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.codeBtn];
            [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.right.mas_equalTo(self).offset(autoScaleW(-15));
                make.size.mas_equalTo(CGSizeMake(autoScaleW(110), autoScaleH(34)));
            }];
        }
            break;
        default:
            break;
    }
}
-(void)setValueWithIndex:(NSInteger)index Flag:(NSInteger)flag
{
    self.titleLabel.text = [[[[self textArr] objectAtIndex:flag-1] objectAtIndex:index] objectForKey:@"mTitle"];
    self.subTitleTF.placeholder = [[[[self textArr] objectAtIndex:flag-1] objectAtIndex:index] objectForKey:@"subTitle"];
    
    if (flag == 1) {
        if (index < 2) {
            self.subTitleTF.keyboardType = UIKeyboardTypePhonePad;
        }
        else
        {
            self.subTitleTF.secureTextEntry = YES;
        }
    }
    else
    {
        self.subTitleTF.secureTextEntry = YES;
    }
}
-(NSString *)getText
{
    return self.subTitleTF.text;
}
-(void)codeBtnAction:(UIButton *)btn
{
    self.myBolck(btn);
}
-(NSArray *)textArr
{
    return @[@[@{@"mTitle"    :@"手机号码",
                 @"subTitle" :@"请输入手机号码"},
               @{@"mTitle"    :@"验证码",
                 @"subTitle" :@"请输入验证码"},
               @{@"mTitle"    :@"新密码",
                 @"subTitle" :@"请输入6-16位新密码"},
               @{@"mTitle"    :@"重复密码",
                 @"subTitle" :@"重复新密码"},],
             @[@{@"mTitle"    :@"原密码",
                 @"subTitle" :@"请输入原密码"},
               @{@"mTitle"    :@"新密码",
                 @"subTitle" :@"请输入6-16位新密码"},
               @{@"mTitle"    :@"重复密码",
                 @"subTitle" :@"重复新密码"},]]
    ;
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

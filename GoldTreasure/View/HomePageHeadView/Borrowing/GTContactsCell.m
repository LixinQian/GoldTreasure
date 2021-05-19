//
//  GTContactsCell.m
//  GoldTreasure
//
//  Created by 王超 on 2017/7/1.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTContactsCell.h"
#import <Masonry/Masonry.h>

@interface GTContactsCell ()<UITextFieldDelegate>

@property (nonatomic, weak) UILabel *titleLabel;


@end

@implementation GTContactsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [GTFont gtFontF2];
        titleLabel.textColor = [GTColor gtColorC4];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UITextField *titleTF = [UITextField new];
        titleTF.font = [GTFont gtFontF2];
        titleTF.textColor = [GTColor gtColorC4];
        titleTF.textAlignment = NSTextAlignmentRight;
        titleTF.delegate = self;
        [self.contentView addSubview:titleTF];
        self.titleTF = titleTF;
        
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(autoScaleW(15));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(autoScaleW(70), autoScaleH(18)));
    }];
    [self.titleTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(autoScaleW(-15));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(autoScaleW(200), autoScaleH(18)));
    }];

}

-(void)setValueWithIndex:(NSInteger)index
{
    self.titleLabel.text = [[self textArr][index] objectForKey:@"mTitle"];
    self.titleTF.placeholder = [[self textArr][index] objectForKey:@"placeholder"];
    if (index == 2) {
        self.titleTF.keyboardType = UIKeyboardTypePhonePad;
    }
}

-(NSString *)getTextFieldText
{
    return self.titleTF.text;
}

//现在输入字数
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger maxLength = 11;//设置限制字数
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (toBeString.length > maxLength && range.length!=1){
        textField.text = [toBeString substringToIndex:maxLength];
        
        return NO;
        
    }
    
    return YES;
}
-(NSArray *)textArr
{
    return @[@{@"mTitle"      :@"姓名",
               @"placeholder":@"请输入姓名"},
             @{@"mTitle"      :@"关系",
               @"placeholder":@"请选择与你的关系"},
             @{@"mTitle"      :@"联系电话",
               @"placeholder":@"请输入联系电话"}];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

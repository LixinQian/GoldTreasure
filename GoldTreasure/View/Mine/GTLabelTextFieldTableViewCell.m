//
//  GTLabelTextFieldTableViewCell.m
//  GoldTreasure
//
//  Created by wangyaxu on 29/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTLabelTextFieldTableViewCell.h"

#import <Masonry/Masonry.h>

@interface GTLabelTextFieldTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *underLineView;

@end

@implementation GTLabelTextFieldTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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
    
    self.textField = [UITextField new];
    self.textField.font = [GTFont gtFontF2];
    self.textField.textColor = [GTColor gtColorC5];
    self.textField.textAlignment = NSTextAlignmentRight;
    [self.textField setValue:[GTColor gtColorC7] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.underLineView = [UIView new];
    self.underLineView.backgroundColor = [GTColor gtColorC15];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.textField];
    [self addSubview:self.underLineView];
    
    {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).with.offset(-15);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@220).with.priorityLow();
            make.left.greaterThanOrEqualTo(self.titleLabel.mas_right).with.offset(10);
        }];
        
        [self.underLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@.5f);
            make.right.bottom.equalTo(self);
            make.left.equalTo(self.mas_left).with.offset(15);
        }];
    }
}

- (void)setTitle:(NSString *)title placeHolder:(NSString *)holder
{
    self.titleLabel.text = title;
    self.textField.placeholder = holder;
    [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
            make.right.equalTo(self.contentView.mas_right);
        } else {
            make.right.equalTo(self.contentView.mas_right).with.offset(-15);
        }
    }];
}

- (void)setTextFieldText:(NSString *)text
{
    self.textField.text = text;
}

- (NSString *)getTextFieldText
{
    return self.textField.text;
}

- (void)setTextFieldEnabled:(BOOL)enabled
{
    self.textField.userInteractionEnabled = enabled;
}

- (void)setTextFieldInputType:(UIKeyboardType )keyboardType
{
    self.textField.keyboardType = keyboardType;
}

- (void)setTextFieldSecureTextEntry:(BOOL )isSecure
{
    self.textField.secureTextEntry = isSecure;
}

- (void)shouldHideSeparatorLine:(BOOL )hidden
{
    self.underLineView.hidden = hidden;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

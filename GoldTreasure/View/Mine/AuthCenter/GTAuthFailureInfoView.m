//
//  GTAuthFailureInfoView.m
//  GoldTreasure
//
//  Created by wangyaxu on 29/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTAuthFailureInfoView.h"
#import "GTContactUsBarView.h"

#import <Masonry/Masonry.h>

@interface GTAuthFailureInfoView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *reasonLabel;

@end

@implementation GTAuthFailureInfoView

- (instancetype)initWithTitle:(NSString *)title reason:(NSString *)reason btnTitle:(NSString *)btnTitle
{
    self = [super init];
    if (self) {
        [self setupWithTitle:title reason:reason btnTitle:btnTitle];
    }
    return self;
}

- (void)setupWithTitle:(NSString *)title reason:(NSString *)reason btnTitle:(NSString *)btnTitle
{
    UIImageView *mainImageView = [UIImageView new];
    mainImageView.image = [UIImage imageNamed:@"fail-1"];
    
    self.titleLabel = [UILabel labelWithFont:[GTFont gtFontF1] textColor:[GTColor gtColorC4]];
    self.titleLabel.text = title;
    
    UIView *line = [UIView new];
    line.backgroundColor = [GTColor gtColorC8];
    
    UIView *markPoint = [UIView new];
    markPoint.layer.cornerRadius = 4;
    markPoint.backgroundColor = [GTColor gtColorC1];
    
    UILabel *reasonTitleLabel = [UILabel labelWithFont:[GTFont gtFontF2] textColor:[GTColor gtColorC5]];
    reasonTitleLabel.text = @"失败原因";
    
    self.reasonLabel = [UILabel labelWithFont:[GTFont gtFontF2] textColor:[GTColor gtColorC4]];
    self.reasonLabel.numberOfLines = 0;
    self.reasonLabel.text = reason;
    
    UILabel *contactLabel = [UILabel labelWithFont:[GTFont gtFontF3] textColor:[GTColor gtColorC6]];
    contactLabel.text = @"如有疑问，请联系客服：";
    
    GTContactUsBarView *contactUsBar = [[GTContactUsBarView alloc] initWithBarMode:ContactUsBarCompact];
    
    [self addSubview:mainImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:line];
    [self addSubview:markPoint];
    [self addSubview:reasonTitleLabel];
    [self addSubview:self.reasonLabel];
    [self addSubview:contactLabel];
    [self addSubview:contactUsBar];
    
    {
        [mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(mainImageView.mas_bottom).with.offset(20);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@.5f);
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(20);
            make.left.equalTo(self.mas_left).with.offset(15);
            make.right.equalTo(self.mas_right).with.offset(-15);
        }];
        
        [reasonTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).with.offset(30);
            make.left.equalTo(markPoint.mas_right).with.offset(10);
        }];
        
        [markPoint mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(8, 8));
            make.centerY.equalTo(reasonTitleLabel.mas_centerY);
            make.left.equalTo(self.mas_left).with.offset(15);
        }];
        
        [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(reasonTitleLabel.mas_left);
            make.right.lessThanOrEqualTo(self.mas_right).with.offset(-15);
            make.top.equalTo(reasonTitleLabel.mas_bottom).with.offset(10);
        }];
        
        [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.reasonLabel.mas_left);
            make.top.equalTo(self.reasonLabel.mas_bottom).with.offset(15);
        }];
        
        [contactUsBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contactLabel.mas_bottom).with.offset(5);
            make.left.right.equalTo(self);
        }];
        
    }
    
    if (btnTitle) {
        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [submitBtn setBackgroundColor:[GTColor gtColorC1]];
        submitBtn.titleLabel.font = [GTFont gtFontF1];
        [submitBtn setTitleColor:[GTColor gtColorC4] forState:UIControlStateNormal];
        submitBtn.layer.cornerRadius = 5;
        [submitBtn setTitle:btnTitle forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(clickSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:submitBtn];

        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@50);
            make.top.equalTo(contactUsBar.mas_bottom).with.offset(20);
            make.left.equalTo(self.mas_left).with.offset(15);
            make.right.equalTo(self.mas_right).with.offset(-15);
        }];
    }

}

- (void)clickSubmitBtn:(UIButton *)button
{
    self.submitInfoBlock();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

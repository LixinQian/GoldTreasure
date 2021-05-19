//
//  GTContactUsItemView.m
//  GoldTreasure
//
//  Created by wangyaxu on 30/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTContactUsItemView.h"

#import <Masonry/Masonry.h>

@interface GTContactUsItemView ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation GTContactUsItemView

- (instancetype)initWithIcon:(UIImage *)icon title:(NSString *)title tip:(NSString *)tipString
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupWithIcon:icon title:title tip:tipString];
    }
    return self;
}

- (void)setupWithIcon:(UIImage *)icon title:(NSString *)title tip:(NSString *)tipString
{
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:icon];
    
    UILabel *titleLabel = [UILabel labelWithFont:[GTFont gtFontF2] textColor:[GTColor gtColorC4] text:title];
    
    UILabel *tipLabel = [UILabel labelWithFont:[GTFont gtFontF3] textColor:[GTColor gtColorC6] text:tipString];
    
    self.lineView = [UIView new];
    self.lineView.backgroundColor = [GTColor gtColorC8];
    
    [self addSubview:iconImageView];
    [self addSubview:titleLabel];
    [self addSubview:tipLabel];
    [self addSubview:self.lineView];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(iconImageView.mas_right).with.offset(10);
    }];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).with.offset(10);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@.5f);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.bottom.equalTo(self);
    }];
}

- (void)setSeparatorLineHidden:(BOOL)hidden
{
    self.lineView.hidden = hidden;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

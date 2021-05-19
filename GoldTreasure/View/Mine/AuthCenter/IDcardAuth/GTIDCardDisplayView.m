//
//  GTIDCardDisplayView.m
//  GoldTreasure
//
//  Created by wangyaxu on 29/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTIDCardDisplayView.h"

#import <Masonry/Masonry.h>

@interface GTIDCardDisplayView ()

@property (nonatomic, strong) NSMutableArray<UIImageView *> *imagesArray;

@end

@implementation GTIDCardDisplayView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}

- (void)setup
{
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"身份证照片";
    titleLabel.font = [GTFont gtFontF2];
    titleLabel.textColor = [GTColor gtColorC4];
    [self addSubview:titleLabel];
    {
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(10);
            make.left.equalTo(self.mas_left).with.offset(15);
        }];
    }
    
    UIView *line = [UIView new];
    line.backgroundColor = [GTColor gtColorC15];
    [self addSubview:line];
    {
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@.5f);
            make.top.equalTo(titleLabel.mas_bottom).with.offset(8);
            make.left.equalTo(self.mas_left).with.offset(15);
            make.right.equalTo(self.mas_right).with.offset(-15);
        }];
    }
    
    for (int i = 0; i < 3; i ++) {
        UIImageView *imageView = [UIImageView new];
        imageView.backgroundColor = [UIColor yellowColor];
        [self addSubview:imageView];
        [self.imagesArray addObject:imageView];
    }
        
    [self.imagesArray[0] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.imagesArray[0].mas_height).with.multipliedBy(160.0 / 100);
        make.top.equalTo(line.mas_bottom).with.offset(15);
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
    
    [self.imagesArray[1] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.imagesArray[1].mas_height).with.multipliedBy(160.0 / 100);
        make.top.equalTo(self.imagesArray[0].mas_top);
        make.left.equalTo(self.imagesArray[0].mas_right).with.offset(25);
        make.bottom.equalTo(self.imagesArray[2].mas_top).with.offset(-15);
        make.right.equalTo(self.mas_right).with.offset(-15);
    }];
    
    [self.imagesArray[2] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.imagesArray[2].mas_height).with.multipliedBy(160.0 / 100);
        make.top.equalTo(self.imagesArray[0].mas_bottom).with.offset(15);
        make.left.right.equalTo(self.imagesArray[0]);
        make.bottom.equalTo(self.mas_bottom).with.offset(-20);
    }];
}

- (void)setImagesWithArray:(NSArray<UIImage *> *)array
{
    [self.imagesArray enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.image = array[idx];
    }];
}

- (NSMutableArray<UIImageView *> *)imagesArray
{
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  GTAuthSuccessInfoView.m
//  GoldTreasure
//
//  Created by wangyaxu on 28/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTAuthSuccessInfoView.h"
#import <Masonry/Masonry.h>
@interface GTAuthSuccessInfoView ()

@property (nonatomic, strong) NSMutableArray<UILabel *> *titlesArray;
@property (nonatomic, strong) NSMutableArray<UILabel *> *contentsArray;

@end

@implementation GTAuthSuccessInfoView

- (instancetype)initWithTitlesArray:(NSArray<NSString *> *)array markedSet:(NSSet<NSString *> *)set
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configWithArray:array set:set];
    }
    return self;
}

- (void)configWithArray:(NSArray *)array set:(NSSet *)set
{
    __block NSMutableSet *markedIndexes = [NSMutableSet set];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [GTFont gtFontF2];
        titleLabel.textColor = [GTColor gtColorC6];
        titleLabel.text = obj;
        
        UILabel *contentLabel = [UILabel new];
        contentLabel.font = [GTFont gtFontF2];
        contentLabel.textColor = [GTColor gtColorC4];
        
        [self addSubview:titleLabel];
        [self addSubview:contentLabel];
        [self.titlesArray addObject:titleLabel];
        [self.contentsArray addObject:contentLabel];
        
        for (NSString *mark in set) {
            if ([obj isEqualToString:mark]) {
                //找到被标记的项
                [markedIndexes addObject:@(idx)];
            }
        }
    }];
    
    [self.titlesArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
    }];
    
    [self.contentsArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(120);
    }];
    
    [self.titlesArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:10 leadSpacing:15 tailSpacing:15];
    [self.contentsArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:10 leadSpacing:15 tailSpacing:15];
    
    for (NSNumber *mark in markedIndexes) {
        UILabel *label = self.contentsArray[mark.integerValue];
        label.textColor = [GTColor gtColorC13];
        UIImageView *markImageView = [UIImageView new];
        markImageView.image = [UIImage imageNamed:@"adopt"];
        [self addSubview:markImageView];
        
        [markImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(label.mas_centerY);
            make.left.equalTo(label.mas_right).with.offset(8);
        }];
    }
}

- (void)fillContentsWithArray:(NSArray<NSString *> *)array
{
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = self.contentsArray[idx];
        label.text = obj;
    }];
}

- (NSMutableArray *)titlesArray
{
    if (!_titlesArray) {
        _titlesArray = [NSMutableArray array];
    }
    return _titlesArray;
}

- (NSMutableArray *)contentsArray
{
    if (!_contentsArray) {
        _contentsArray = [NSMutableArray array];
    }
    return _contentsArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

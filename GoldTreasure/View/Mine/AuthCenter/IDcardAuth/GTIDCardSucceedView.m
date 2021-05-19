//
//  GTIDCardSucceedView.m
//  GoldTreasure
//
//  Created by wangyaxu on 29/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTIDCardSucceedView.h"
#import "GTAuthSuccessInfoView.h"
//#import "GTIDCardDisplayView.h"
#import "GTContactUsBarView.h"

#import <Masonry/Masonry.h>

@interface GTIDCardSucceedView ()

@property (nonatomic, strong) GTAuthSuccessInfoView *authInfoView;
//@property (nonatomic, strong) GTIDCardDisplayView *displayView;

@end


@implementation GTIDCardSucceedView

- (instancetype)initWithInfoArray:(NSArray<NSDictionary *> *)array
{
    self = [super init];
    if (self) {
        NSMutableArray<NSString *> *titlesArray = [NSMutableArray array];
        NSMutableArray<NSString *> *contentsArray = [NSMutableArray array];
        
        for (NSDictionary *dic in array) {
            [titlesArray addObject:dic.allKeys.firstObject];
            [contentsArray addObject:dic.allValues.firstObject];
        }
        
        [self setupWithTitlesArray:titlesArray];
        [self.authInfoView fillContentsWithArray:contentsArray];
    }
    return self;
}

- (void)setupWithTitlesArray:(NSArray<NSString *> *)array
{
    NSSet *markedSet = [NSSet setWithObjects:@"审核状态", nil];
    GTAuthSuccessInfoView *authInfoView = [[GTAuthSuccessInfoView alloc] initWithTitlesArray:array markedSet:markedSet];
    self.authInfoView = authInfoView;
    
    UILabel *tipLabel = [UILabel labelWithFont:[GTFont gtFontF3] textColor:[GTColor gtColorC6] text:@"实名认证通过后不可更改。\n如有疑问，请联系客服："];
    tipLabel.numberOfLines = 0;
    
    GTContactUsBarView *barView = [[GTContactUsBarView alloc] initWithBarMode:ContactUsBarRegular];
    
    [self addSubview:authInfoView];
    [self addSubview:tipLabel];
    [self addSubview:barView];
    
    {
        [self.authInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.mas_top);
        }];
        
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.authInfoView.mas_bottom).with.offset(10);
            make.left.equalTo(self.mas_left).with.offset(15);
            make.right.equalTo(self.mas_right).with.offset(-15);
        }];
        
        [barView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipLabel.mas_bottom).with.offset(5);
            make.left.right.equalTo(self);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }

    
//    GTIDCardDisplayView *displayView = [GTIDCardDisplayView new];
//    [self addSubview:displayView];
//    self.displayView = displayView;
//    
//    [self.displayView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.and.bottom.equalTo(self);
//        make.top.equalTo(self.authInfoView.mas_bottom).with.offset(15);
//    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

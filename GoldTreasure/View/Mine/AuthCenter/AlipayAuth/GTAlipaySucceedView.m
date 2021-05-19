//
//  GTAlipaySucceedView.m
//  GoldTreasure
//
//  Created by wangyaxu on 30/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTAlipaySucceedView.h"
#import "GTAuthSuccessInfoView.h"
#import "GTContactUsBarView.h"

#import <Masonry/Masonry.h>

@interface GTAlipaySucceedView ()

@property (nonatomic, strong) GTAuthSuccessInfoView *authInfoView;

@end

@implementation GTAlipaySucceedView

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
    NSSet *markedSet = [NSSet setWithObjects:@"认证状态", nil];
    GTAuthSuccessInfoView *authInfoView = [[GTAuthSuccessInfoView alloc] initWithTitlesArray:array markedSet:markedSet];
    self.authInfoView = authInfoView;
    
    UILabel *tipLabel = [UILabel labelWithFont:[GTFont gtFontF3] textColor:[GTColor gtColorC6] text:@"支付宝认证两个月更新一次，请及时认证。\n如有疑问，请联系客服："];
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
        }];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

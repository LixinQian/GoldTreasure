//
//  feeSummaryFooterView.m
//  GoldTreasure
//
//  Created by targeter on 2017/7/1.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "feeSummaryFooterView.h"
#import <Masonry/Masonry.h>

@interface feeSummaryFooterView()

/** 总额 */
@property(nonatomic, strong)UILabel *zongE;
/** footerLine */
@property(nonatomic, strong)UIView *footerLine;

@end
@implementation feeSummaryFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

- (void)createView
{
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor = [UIColor whiteColor];
    
    [self setBackgroundView:view];
    _zongE = [[UILabel alloc] init];
    _zongE.textColor = [GTColor gtColorC5];
    _zongE.font = [GTFont gtFontF2];
    _zongE.text = @"总额";
    
    [self addSubview:_zongE];
    
    
    [_zongE mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.height.equalTo(@18);
        make.left.equalTo(self).offset(15);
    }];
    
    _feeSummary = [[UILabel alloc] init];
    _feeSummary.textColor = [GTColor gtColorC5];
    _feeSummary.font = [GTFont gtFontF2];
    //    _feeLabel.text = self.fee;
    _feeSummary.text = @"＝0.00 元";
    
    [self addSubview:_feeSummary];
    
    
    [_feeSummary mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.height.equalTo(@18);
        make.right.equalTo(self).offset(-15);
    }];
    
    _footerLine = [[UIView alloc] init];
    [self addSubview:_footerLine];
    _footerLine.backgroundColor = [GTColor gtColorC8];
    [_footerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.height.equalTo(@1);
    }];
    

}
@end

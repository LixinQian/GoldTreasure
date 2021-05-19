//
//  GTFlexSliderCell.m
//  GoldTreasure
//
//  Created by 王超 on 2017/6/27.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTFlexSliderCell.h"
#import "SDCycleScrollView.h"
#import <Masonry/Masonry.h>

@interface GTFlexSliderCell ()<SDCycleScrollViewDelegate>

/**
 *  轮播图
 */
@property (nonatomic, strong)SDCycleScrollView *bannerView;
@property (nonatomic,strong) UIView *bgView;

@end

@implementation GTFlexSliderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [GTColor gtColorC3];
        self.bgView = [UIView new];
        self.bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.bgView];
        self.bgView.layer.cornerRadius = 5;
        self.bgView.layer.masksToBounds = YES;
//        
//        self.bgView.layer.shadowOffset =CGSizeMake(0, 1);
//        self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.bgView.layer.shadowRadius = 1;
//        self.bgView.layer.shadowOpacity = .5f;
//        CGRect shadowFrame = self.bgView.layer.bounds;
//        CGPathRef shadowPath = [UIBezierPath bezierPathWithRect:shadowFrame].CGPath;
//        self.bgView.layer.shadowPath = shadowPath;
        
//        self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:self.bgView.frame delegate:self placeholderImage:nil];
        self.bannerView = [SDCycleScrollView new];
        self.bannerView.delegate = self;
        //样式为pageControl加动画
//        self.bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        self.bannerView.currentPageDotColor = [UIColor orangeColor];
        self.bannerView.pageDotColor = [UIColor lightGrayColor];
        self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        self.bannerView.alpha = 1;
        
        self.bannerView.placeholderImage = [UIImage imageNamed:@"tu"];
        //轮播自动滚动时间
        self.bannerView.autoScrollTimeInterval = 5;
        [self.bgView addSubview:self.bannerView];
        self.bannerView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        

    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(10);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.bottom.mas_equalTo(self).offset(-10);
    }];
    
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView).offset(10);
        make.left.right.equalTo(self.bgView);
        make.bottom.mas_equalTo(self.bgView).offset(-10);
    }];
    
}
//-(void)reSetArr
//{
//    self.bannerView.imageURLStringsGroup = self.bannerDataArr;
//}
// 设值
-(void)setBannerDataArr:(NSArray *)bannerDataArr {
    
    _bannerDataArr = bannerDataArr;
    _bannerView.imageURLStringsGroup = bannerDataArr;
}
#pragma mark - 轮播图的协议方法

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    self.myBlock(index);
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

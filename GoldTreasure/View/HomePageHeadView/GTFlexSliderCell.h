//
//  GTFlexSliderCell.h
//  GoldTreasure
//
//  Created by 王超 on 2017/6/27.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^flexSliderBlock)(NSInteger index);

@interface GTFlexSliderCell : UITableViewCell

/**
 *  存放轮播图的数据
 */
@property (nonatomic, strong) NSArray *bannerDataArr;

@property (nonatomic, copy) flexSliderBlock myBlock;

//-(void)reSetArr;

@end

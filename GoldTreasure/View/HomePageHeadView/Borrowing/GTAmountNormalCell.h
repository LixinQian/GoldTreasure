//
//  GTAmountNormalCell.h
//  GoldTreasure
//
//  Created by 王超 on 2017/7/3.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

typedef void(^AmountBlock)();

@interface GTAmountNormalCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setAmountWithIndexPath:(NSIndexPath *)indexP Model:(OrderModel *)model;

@property (nonatomic, strong) OrderModel *model;

@property (nonatomic, strong) NSIndexPath *indexP;

@property (nonatomic, copy) AmountBlock amountCellBlock;

@end

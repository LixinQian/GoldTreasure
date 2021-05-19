//
//  GTSelectAmountCell.h
//  GoldTreasure
//
//  Created by 王超 on 2017/7/3.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

typedef void(^selectAmountBlock)(OrderModel *model);

@interface GTSelectAmountCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, copy) selectAmountBlock selectBlock;

@end

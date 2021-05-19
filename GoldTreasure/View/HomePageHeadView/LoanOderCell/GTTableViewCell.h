//
//  GTTableViewCell.h
//  GoldTreasure
//
//  Created by targeter on 2017/6/27.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GTResModelLoanOrder;
@interface GTTableViewCell : UITableViewCell



/** LoanOrderResModel */
@property(nonatomic, strong)GTResModelLoanOrder *orderList;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

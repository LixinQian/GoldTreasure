//
//  PaybackView.h
//  GoldTreasure
//
//  Created by targeter on 2017/6/27.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^tapBlock)();
@class GTPaybackCellModel;
@interface PaybackView : UITableViewCell
/** block跳转 */
@property(nonatomic, copy)tapBlock persistLoan;
/** block跳转 */
@property(nonatomic, copy)tapBlock nowPayback;


/** 应还金额 */
@property(nonatomic, strong)UILabel *loanLimit;
/** 到期天数 */
@property(nonatomic, strong)UILabel *availableDaysLabel;
/** 逾期天数 */
@property(nonatomic, strong)UILabel *lateDaysLabel;
/** 借款金额 */
@property(nonatomic, strong)UILabel *loanCashLabel;
/** 滞纳金 */
@property(nonatomic, strong)UILabel *lateFeeLabel;
/** PaybackCellModel */
@property(nonatomic, strong)GTPaybackCellModel *PaybackCellModel;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end



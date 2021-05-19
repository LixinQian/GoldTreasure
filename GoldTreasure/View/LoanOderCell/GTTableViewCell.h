//
//  GTTableViewCell.h
//  GoldTreasure
//
//  Created by targeter on 2017/6/27.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTTableViewCell : UITableViewCell

/** 借款状态 */
@property(nonatomic, strong)NSString *loanOrderStaus;
/** 借款金额 */
@property(nonatomic, strong)NSString *LoanCash;
/** 借款日期 */
@property(nonatomic, strong)NSString *loanDate;
/** 还款日期 */
@property(nonatomic, strong)NSString *payDate;



@end

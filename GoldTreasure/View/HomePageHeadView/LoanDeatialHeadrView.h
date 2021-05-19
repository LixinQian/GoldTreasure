//
//  LoanDeatialHeadrView.h
//  GoldTreasure
//
//  Created by targeter on 2017/6/30.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GTLoanOrderDetailResModel;
typedef void(^addBottomButtonsBlock)();

@interface LoanDeatialHeadrView : UITableViewCell

/** block跳转 */
@property(nonatomic, copy)addBottomButtonsBlock addBottom;
/** 还款金额数据Label */
@property(nonatomic, strong)UILabel *cashLabel;
/** 固定周期data */
@property(nonatomic, strong)UILabel *circleTimeLabel;
/** 手续费data */
@property(nonatomic, strong)UILabel *feeLabel;
/** 借款状态data */
@property(nonatomic, strong)UILabel *loanOrderStausLabel;
/** 申请时间data */
@property(nonatomic, strong)UILabel *applicateDateLabel;
/** 借款时间data */
@property(nonatomic, strong)UILabel *loanDateLabel;

/** model */
@property(nonatomic, strong)GTLoanOrderDetailResModel *model;


@end


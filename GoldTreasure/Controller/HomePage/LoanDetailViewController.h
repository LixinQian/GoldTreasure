//
//  LoanDetailViewController.h
//  GoldTreasure
//
//  Created by targeter on 2017/6/30.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTBaseViewController.h"
@class GTLoanOrderDetailReqModel;

@interface LoanDetailViewController : GTBaseViewController

/** LoanOrderDetailReqModel */
@property(nonatomic, strong)GTLoanOrderDetailReqModel *reqModel;

@end

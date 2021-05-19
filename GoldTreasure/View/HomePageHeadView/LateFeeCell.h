//
//  LateFeeCell.h
//  GoldTreasure
//
//  Created by targeter on 2017/6/30.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LateFeeCell : UITableViewCell

/** 日期Label */
@property(nonatomic, strong)UILabel *feeDateLabel;
/** 金额Label */
@property(nonatomic, strong)UILabel *feeLabel;
/** GTLatefees */
@property(nonatomic, strong)GTLatefees *lateFeeModel;
/** type 1 || 2 */
@property (nonatomic, assign)int type;

@end

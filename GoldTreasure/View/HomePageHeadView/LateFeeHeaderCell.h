//
//  LateFeeHeaderCell.h
//  GoldTreasure
//
//  Created by targeter on 2017/6/30.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^tapBlock)();

@interface LateFeeHeaderCell : UITableViewCell

/** block跳转 */
@property(nonatomic, copy)tapBlock tap;
/** headerLine */
@property(nonatomic, strong)UIView *footerLine;
/** 问号❓ */
@property(nonatomic, strong)UIImageView *comma;

@end

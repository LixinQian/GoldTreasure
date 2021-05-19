//
//  PaybackEndViewController.h
//  GoldTreasure
//
//  Created by targeter on 2017/7/13.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaybackEndViewController : GTBaseViewController
/** payCash */
@property(nonatomic, strong)NSString *payCashString;

//区别还款还是续借进来的,1还款，2续借
@property (nonatomic, assign) NSInteger payType;

@end

//
//  HomePageHeadView.h
//  GoldTreasure
//
//  Created by 王超 on 2017/6/27.
//  Copyright © 2017年 王超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

typedef void(^headViewBlock)();

@interface HomePageHeadView : UIView

@property (nonatomic, strong) GTResModelUserInfo *model;

@property (nonatomic, copy) headViewBlock borrowBlock;
@property (nonatomic, copy) headViewBlock orderBlock;
//@property (nonatomic, copy) headViewBlock repaymentBlock;

@end

//
//  PaybackListResModel.m
//  GoldTreasure
//
//  Created by targeter on 2017/7/4.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "PaybackListResModel.h"
#import "PaybackCellModel.h"
#import "YYModel.h"
@implementation PaybackListResModel

// 返回 loans
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"loans" : [PaybackCellModel class] };
}


@end

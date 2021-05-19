//
//  GTDBUserModel.m
//  GoldTreasure
//
//  Created by ZZN on 2017/7/7.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTDBUserModel.h"

@implementation GTDBUserModel


/// Dic -> model
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
    NSNumber *intId = dic[@"custId"];
    self.custId = [NSString stringWithFormat:@"%@",intId];
    return YES;
}

/// model -> Dic
- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    
//    dic[@"t"] = @([self.time timeIntervalSince1970] * 1000).description;
    dic[@"custId"] = [[NSNumber alloc] initWithFloat:self.custId.floatValue];
    return YES;
}


+(NSString *)primaryKey {
   return @"custId";
}
@end

// 关联属性
@implementation GTDBCommonModel

//+(NSString *)primaryKey {
//    
//    return @"actId";
//}

@end

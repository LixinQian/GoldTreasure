//
//  GTNetError.m
//  GoldTreasure
//
//  Created by ZZN on 2017/6/27.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTNetError.h"

@implementation GTNetError

- (instancetype) initErrCode:(NSInteger)code msg:(NSString *)msg {
    if (!self) {
        self = [self init];
    }

    self.msg = msg;
    return [super initWithDomain:@"GTNetError" code:code userInfo:nil];
}

//
- (NSDictionary *) toDictionary {
    
    NSDictionary *dict = @{
                           @"code":@(self.code),
                           @"":self.msg
                           };
    return dict;
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"错误号:%ld, 错误原因 %@",(long)self.code,self.msg];
}


@end

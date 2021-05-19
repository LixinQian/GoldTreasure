//
//  NSDictionary+Extension.h
//  GoldTreasure
//
//  Created by ZZN on 2017/6/30.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (JSONString)

-(NSString *)JSONString{
    
    NSString *jsonString = [[NSString alloc]init];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                        
                                                      options:0
                        
                                                        error:&error];
    
    if (!jsonData) {
        
        GTLog(@"error: %@", error);
        
    } else {
        
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    return mutStr;
}

@end

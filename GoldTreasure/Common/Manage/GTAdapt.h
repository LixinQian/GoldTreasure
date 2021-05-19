//
//  GTAdapt.h
//  GoldTreasure
//
//  Created by ZZN on 2017/7/11.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTAdapt : NSObject


/**

 @{
    @"mClass": @"ViewController",
    @"mDict": @{
        @"ID": @"1",
        @"type": @"view"
    }
 };
 @param params 路由解析
 */
+ (void)push:(NSDictionary *)params;
+ (void)push:(NSDictionary *)params andNavController:(UINavigationController *)nav;
@end

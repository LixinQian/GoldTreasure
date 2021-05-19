//
//  GTAdapt.m
//  GoldTreasure
//
//  Created by ZZN on 2017/7/11.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "GTAdapt.h"

@interface GTAdapt()

@end

@implementation GTAdapt

+(void)push:(NSDictionary *)params {
    
    
    NSString *classStr = [NSString stringWithFormat:@"%@",params[@"mClass"]];
    Class newClass = NSClassFromString(classStr);
    
    if (!newClass) { return; }
    
    id instance = [[newClass alloc] init];

    NSDictionary *dict = [params[@"mDict"] isEqual: [NSDictionary class]] ? params[@"mDict"] : [NSDictionary dictionary]  ;
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([GTAdapt checkIsExistPropertyWithInstance:instance verifyPropertyName:key]) {
            
            [instance setValue:obj forKey:key];
        }
    }];
    
    // jump导航控制器
    [[GTHUD currentNav] pushViewController:instance animated:true];
    
}

+(void)push:(NSDictionary *)params andNavController:(UINavigationController *)nav {
    
    
    NSString *classStr = [NSString stringWithFormat:@"%@",params[@"mClass"]];
    Class newClass = NSClassFromString(classStr);
    
    if (!newClass) { return; }
    
    id instance = [[newClass alloc] init];
    
    NSDictionary *dict = [params[@"mDict"] isEqual: [NSDictionary class]] ? params[@"mDict"] : [NSDictionary dictionary]  ;
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([GTAdapt checkIsExistPropertyWithInstance:instance verifyPropertyName:key]) {
            
            [instance setValue:obj forKey:key];
        }
    }];
    // jump导航控制器
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [nav pushViewController:instance animated:true];
    }];
}


+ (BOOL)checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName {
    
    unsigned int outCount = 0;
    // 获取对象里的属性列表
    objc_property_t *properties = class_copyPropertyList([instance class], &outCount);
    
    
    for (int i = 0; i < outCount; i++) {
        
        objc_property_t property =properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        //  is have
        if ([propertyName isEqualToString:verifyPropertyName]) {
            
            free(properties);
            return true;
        }
    }
    
    free(properties);
    return NO;
}
@end

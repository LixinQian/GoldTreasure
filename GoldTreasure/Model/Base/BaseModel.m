//
//  BaseModel.m
//  GoldTreasure
//
//  Created by 王超 on 2017/6/23.
//  Copyright © 2017年 王超. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

@implementation BaseModel

//归档与解归档的方法
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        //获取所有属性
        NSArray * porpertyArray = [self getAllPropertys];
        for (NSString * name in porpertyArray) {
            //去掉属性名前面的_
            NSString * key = [name substringFromIndex:1];
            //约定好的键值对 c+key
            [self setValue:[coder decodeObjectForKey:[NSString stringWithFormat:@"c%@",key]] forKey:key];
        }
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)coder
{
    
    //获取所有属性
    NSArray * porpertyArray = [self getAllPropertys];
    for (NSString * name in porpertyArray) {
        //去掉属性名前面的_
        NSString * key = [name substringFromIndex:1];
        //约定好的键值对 c+key
        [coder encodeObject:[self valueForKey:key] forKey:[NSString stringWithFormat:@"c%@",key]];
    }
}


-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    return ;
}

-(void)creatModelWithDic:(NSDictionary *)dic{
    [self setValuesForKeysWithDictionary:dic];
}


-(NSDictionary *)modelMappingToDictionary{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    NSArray * arr = [NSArray arrayWithArray:[self getAllPropertys]];
    for (int i=0; i<arr.count; i++) {
        if ([self valueForKey:arr[i]]!=nil) {
            [dic setObject:[self valueForKey:arr[i]] forKey:[arr[i] substringFromIndex:1]];
        }
    }
    return dic;
}
-(void)creatModelWithData:(NSData *)data{
    NSDictionary * dic = [self dictionaryWithJSData:data];
    [self creatModelWithDic:dic];
}

-(NSDictionary *)dictionaryWithJSData:(NSData *)data{
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return dic;
}

-(NSArray *)getAllPropertys{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    
    unsigned int * count = malloc(sizeof(unsigned int));
    //调用runtime的方法
    //Ivar：方法返回的对象内容对象，这里将返回一个Ivar类型的指针
    //class_copyIvarList方法可以捕获到类的所有变量，将变量的数量存在一个unsigned int的指针中
    Ivar * mem = class_copyIvarList([self class], count);
    //进行遍历
    for (int i=0; i< *count ; i++) {
        //通过移动指针进行遍历
        Ivar var = * (mem+i);
        //获取变量的名称
        const char * name = ivar_getName(var);
        NSString * str = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        [array addObject:str];
    }
    //释放内存
    free(count);
    //注意处理野指针
    count=nil;
    return array;
}
//打印方法
-(NSString *)description{
    NSMutableString * str = [[NSMutableString alloc]initWithFormat:@"{\n"];
    for (NSString * key in [self modelMappingToDictionary].allKeys) {
        [str appendFormat:@"%@:%@;\n",key,[self valueForKey:key]];
    }
    [str appendFormat:@"}"];
    return str;
}

@end

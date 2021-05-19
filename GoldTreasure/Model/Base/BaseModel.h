//
//  BaseModel.h
//  GoldTreasure
//
//  Created by 王超 on 2017/6/23.
//  Copyright © 2017年 王超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

/**
 *  使用字典直接为model赋值
 *
 *  @param dic 原始字典
 */
-(void)creatModelWithDic:(NSDictionary *)dic;
/**
 *  提供一个字典的映射方法，将属性转化为字典
 *
 *  @return 对象数据对应的字典
 */
-(NSDictionary *)modelMappingToDictionary;
/**
 *  这个方法将json数据直接映射成model 数据格式必须正规
 *
 *  @param data 原始json数据
 */
-(void)creatModelWithData:(NSData *)data;

@end

//
//  GTAuthSuccessInfoView.h
//  GoldTreasure
//
//  Created by wangyaxu on 28/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTAuthSuccessInfoView : UIView

//根据标题数组与标记项初始化
- (instancetype)initWithTitlesArray:(NSArray<NSString *> *)array markedSet:(NSSet<NSString *> *)set;

//根据内容填充数据
- (void)fillContentsWithArray:(NSArray<NSString *> *)array;

@end

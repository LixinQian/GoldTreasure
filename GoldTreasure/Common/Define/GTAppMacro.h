//
//  GTAppMacro.h
//  GoldTreasure
//
//  Created by ZZN on 2017/6/28.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#ifndef GTAppMacro_h
#define GTAppMacro_h


// App 类型
#define __DEV true
// 打印调试开关
#define __DEBUG



// block self define
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;
#define WS(weakSelf) __weak __typeof(&*self) weakSelf = self

//是否为空或是[NSNull null]
#define NotNilAndNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))





#endif /* GTAppMacro_h */




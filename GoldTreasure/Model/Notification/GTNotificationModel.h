//
//  GTNotificationModel.h
//  GoldTreasure
//
//  Created by 王超 on 2017/7/6.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import "BaseModel.h"
#import <Realm/Realm.h>

@interface GTNotificationModel : RLMObject


/** 通知类型的icon */
@property (nonatomic, copy) NSString *logo;
/** 通知标题 */
@property (nonatomic, copy) NSString *mTitle;
/** 通知时间 */
@property (nonatomic, copy) NSString *createTime;
/** 通知内容 */
@property (nonatomic, strong) NSString *content;

/** 按钮的标题 */
@property (nonatomic, strong) NSString *bText;
/** 通知的路由 */
@property (nonatomic, strong) NSString *appUrl;

/** 表ID */
@property (nonatomic, strong) NSString *custId;
/** type = 1 时 全局 推送 */
@property (nonatomic, strong) NSString *type;

@end


//
//  GTNotificationCell.h
//  GoldTreasure
//
//  Created by 王超 on 2017/7/6.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTNotificationModel.h"

typedef void(^notiCellBlock)(GTNotificationModel *model);

@interface GTNotificationCell : UITableViewCell

@property (nonatomic, strong) GTNotificationModel *model;

@property (nonatomic, copy) notiCellBlock notiBlock;

@end

//
//  GTIDCardAuthViewController.h
//  GoldTreasure
//
//  Created by wangyaxu on 29/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTBaseViewController.h"

@interface GTIDCardAuthViewController : GTBaseViewController

@property (nonatomic, weak) id<AuthStatusRefreshProtocol> delegate;

- (instancetype)initWithUserAuth:(GTAuthStatus)status userSelf:(BOOL)byUserSelf;

- (void)setOrderId:(NSString *)orderId;

- (void)setLocation:(CLLocation *)location;

@end

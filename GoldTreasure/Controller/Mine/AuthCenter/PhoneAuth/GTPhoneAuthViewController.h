//
//  GTPhoneAuthViewController.h
//  GoldTreasure
//
//  Created by wangyaxu on 29/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTBaseViewController.h"

@interface GTPhoneAuthViewController : GTBaseViewController

@property (nonatomic, weak) id<AuthStatusRefreshProtocol> delegate;

- (instancetype)initWithCarrierAuth:(GTAuthStatus)status;

- (void)setOrderId:(NSString *)orderId;

@end

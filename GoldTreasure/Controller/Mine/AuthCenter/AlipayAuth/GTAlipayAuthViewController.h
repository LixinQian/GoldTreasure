//
//  GTAlipayAuthViewController.h
//  GoldTreasure
//
//  Created by wangyaxu on 29/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTBaseViewController.h"

@interface GTAlipayAuthViewController : GTBaseViewController

//@property (nonatomic, weak) id<AuthStatusRefreshProtocol> delegate;

- (instancetype)initWithAlipayAuth:(GTAuthStatus)status;

@end

//
//  GTBankCardAuthViewController.h
//  GoldTreasure
//
//  Created by wangyaxu on 29/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import "GTBaseViewController.h"

@class GTBankCardAuthModel;

@interface GTBankCardAuthViewController : GTBaseViewController

//@property (nonatomic, weak) id<AuthStatusRefreshProtocol> delegate;

- (instancetype)initWithBankCardAuth:(GTAuthStatus)status;

- (instancetype)initWithBankCardAuthModel:(GTBankCardAuthModel *)model;

@end

//
//  GTBankCardCommitViewController.h
//  GoldTreasure
//
//  Created by wangyaxu on 03/07/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^submitBankcard)(NSString *mobile, NSString *bankNo);

@interface GTBankCardCommitViewController : UIViewController

@property (nonatomic, copy) submitBankcard commitBlock;

- (void)reInputBankcardNumber;

- (void)setSubmitBtnEnabled:(BOOL )enabled;

@end

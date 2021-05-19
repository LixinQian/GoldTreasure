//
//  GTAlipaySubmitView.h
//  GoldTreasure
//
//  Created by wangyaxu on 05/07/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^submitAliPayBlock)(NSString *account, NSString *password);

@interface GTAlipaySubmitView : UIView

@property (nonatomic, copy) submitAliPayBlock submitInfoBlock;

- (void)setSubmitBtnEnabled:(BOOL )enabled;

@end

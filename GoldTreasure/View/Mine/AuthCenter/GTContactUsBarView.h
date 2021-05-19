//
//  GTContactUsBarView.h
//  GoldTreasure
//
//  Created by wangyaxu on 29/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ContactUsBarNoLeftMargin,
    ContactUsBarCompact,
    ContactUsBarRegular,
} ContactUsBarMode;

@interface GTContactUsBarView : UIView

- (instancetype)initWithBarMode:(ContactUsBarMode )mode;

@end

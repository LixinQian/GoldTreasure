//
//  GTAuthFailureInfoView.h
//  GoldTreasure
//
//  Created by wangyaxu on 29/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTAuthFailureInfoView : UIView

@property (nonatomic, copy) btnClickBlock submitInfoBlock;

- (instancetype)initWithTitle:(NSString *)title reason:(NSString *)reason btnTitle:(NSString *)btnTitle;

@end

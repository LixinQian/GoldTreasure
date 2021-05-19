//
//  GTBankCardSucceedView.h
//  GoldTreasure
//
//  Created by wangyaxu on 30/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTBankCardSucceedView : UIView

@property (nonatomic, copy) btnClickBlock changeCardBlock;

@property (nonatomic, strong) UIImageView *bankIcon;

- (void)setBankNumber:(NSString *)bankNumber;

- (void)setAddDate:(NSString *)addDate;

- (void)setBankName:(NSString *)bankName;

- (void)setChangeCardBtnHidden:(BOOL )isHidden;

@end

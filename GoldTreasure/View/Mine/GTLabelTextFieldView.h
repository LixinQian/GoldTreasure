//
//  GTLabelTextFieldView.h
//  GoldTreasure
//
//  Created by wangyaxu on 06/07/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTLabelTextFieldView : UIView

- (void)setTitle:(NSString *)title placeHolder:(NSString *)holder;

- (void)setTextFieldText:(NSString *)text;

- (NSString *)getTextFieldText;

- (void)setTextFieldEnabled:(BOOL )enabled;

- (void)setTextFieldInputType:(UIKeyboardType )keyboardType;

- (void)setTextFieldSecureTextEntry:(BOOL )isSecure;

- (void)shouldHideSeparatorLine:(BOOL )hidden;

@end

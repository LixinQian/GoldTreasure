//
//  GTContactUsItemView.h
//  GoldTreasure
//
//  Created by wangyaxu on 30/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTContactUsItemView : UIView

- (instancetype)initWithIcon:(UIImage *)icon title:(NSString *)title tip:(NSString *)tipString;

- (void)setSeparatorLineHidden:(BOOL)hidden;

@end

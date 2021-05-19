//
//  GTMineTableViewCell.h
//  GoldTreasure
//
//  Created by wangyaxu on 27/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTMineTableViewCell : UITableViewCell

- (void)setIcon:(UIImage *)image;

- (void)setTitle:(NSString *)title;

- (void)setSubTitle:(NSString *)subTitle withOffset:(CGFloat )offset;

- (void)shouldHideSeparatorLine:(BOOL )hidden;

@end

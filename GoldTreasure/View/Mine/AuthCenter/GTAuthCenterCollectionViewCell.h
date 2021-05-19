//
//  GTAuthCenterCollectionViewCell.h
//  GoldTreasure
//
//  Created by wangyaxu on 28/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTAuthCenterCollectionViewCell : UICollectionViewCell

- (void)setAuthState:(GTAuthStatus )state;

- (void)setIconWithImageName:(NSString *)name;

- (void)setTitle:(NSString *)title;

@end

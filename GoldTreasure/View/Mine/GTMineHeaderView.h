//
//  GTMineHeaderView.h
//  GoldTreasure
//
//  Created by wangyaxu on 27/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^actionBlock)();

@interface GTMineHeaderView : UIView

@property (nonatomic, copy) actionBlock changeAvatarBlock;
@property (nonatomic, copy) actionBlock loginBlock;

@property (nonatomic, strong) UIImageView *avatarImageView;

- (void)setName:(NSString *)name;

- (void)setPhoneNumber:(NSString *)phone;

@end

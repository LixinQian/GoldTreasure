//
//  GTShowSignature.h
//  GoldTreasure
//
//  Created by 王超 on 2017/7/5.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTSignatureView.h"

typedef void(^SaveSuccessBlock)(UIImage *image);

@interface GTShowSignature : UIView

//确定
@property (nonatomic, strong) UIButton *okBtn;

-(instancetype)init;

-(void)showView;

@property (nonatomic, copy) SaveSuccessBlock saveBlock;

@end

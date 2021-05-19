//
//  GTSignatureView.h
//  GoldTreasure
//
//  Created by 王超 on 2017/7/4.
//  Copyright © 2017年 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SaveSuccessBlock)(UIImage *image);
typedef void(^setBtnBlock)(NSInteger count);

@interface GTSignatureView : UIView

// 初始化相关参数
- (instancetype)initSignatureView;
// back操作
- (void)doCancel;
// 保存Image
- (void)saveImage:(SaveSuccessBlock)saveSuccessBlock;

-(void)resetLabel;

@property (nonatomic, copy) setBtnBlock setBlock;

@end

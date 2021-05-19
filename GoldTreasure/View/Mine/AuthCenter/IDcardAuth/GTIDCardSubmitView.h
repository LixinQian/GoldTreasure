//
//  GTIDCardSubmitView.h
//  GoldTreasure
//
//  Created by wangyaxu on 29/06/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^submitIdcardBlock)(NSString *name, NSString *idCard, UIImage *frontImage, UIImage *backImage, UIImage *fullImage);

@interface GTIDCardSubmitView : UIView

@property (nonatomic, copy) btnClickBlock takePhotoBlock;
@property (nonatomic, copy) submitIdcardBlock submitBlock;

@property (nonatomic, assign) NSUInteger imagesCount;

- (void)setFrontImage:(UIImage *)image;

- (void)setBackImage:(UIImage *)image;

- (void)setFullImage:(UIImage *)image;

- (void)setSubmitBtnEnabled:(BOOL )enabled;

@end

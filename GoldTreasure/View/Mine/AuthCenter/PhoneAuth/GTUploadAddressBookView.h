//
//  GTUploadAddressBookView.h
//  GoldTreasure
//
//  Created by wangyaxu on 03/07/2017.
//  Copyright © 2017 zhaofanjinrong.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTUploadAddressBookView : UIView

@property (nonatomic, copy) btnClickBlock uploadAddressBlock;
@property (nonatomic, copy) btnClickBlock closeBlock;

- (void)setSubmitBtnEnabled:(BOOL )enabled;

@end
